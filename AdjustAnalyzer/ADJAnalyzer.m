//
//  ADJActivityHandler.m
//  Adjust
//
//  Created by Christian Wellenbrock on 2013-07-01.
//  Copyright (c) 2013 adjust GmbH. All rights reserved.
//

#import "ADJAnalyzer.h"
#import "ADJUtil.h"

@implementation ADJAnalyzer

// Called from main app to initialize the test session and receive commands
+ (void)init:(NSString *)baseUrl
onReceiveCommand:(void (^)(NSString *callingClass, NSString *funcName, NSDictionary *params))onReceiveCommand
{
    if(!onReceiveCommand) {
        NSLog(@"No callback received");
        return;
    }
    
    //set base url
    [ADJUtil setBaseUrl:baseUrl];
    
    // making a POST request to /init
    NSString *targetUrl = [NSString stringWithFormat:@"%@/init_session", baseUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:targetUrl]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable responseData,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          if (responseData == nil) {
              NSLog(@"Couldn't retrieve response from %@", targetUrl);
              return;
          }
          
          //Parse cookie to retrieve test Session ID
          [ADJAnalyzer parseCookieAndSetTestSessionIdUrl:response];
          
          //Get the response
          NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
          if (responseStr == nil || responseStr.length == 0) {
              return;
          }
          
          NSLog(@"Data received: %@", responseStr);
          
          //Parse from JSON
          NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:kNilOptions
                                                                 error:&error];
          
          if(error != nil) {
              NSLog(@"Error parsing JSON.");
              return;
          } else {
              NSLog(@"Array: %@", jsonArray);
          }
          
          for (NSDictionary *dict in jsonArray) {
              NSString *callingClass = [dict objectForKey:@"className"];
              NSString *funcName = [dict objectForKey:@"functionName"];
              NSDictionary *paramsDict = [dict objectForKey:@"params"];
              
              //              NSLog(@"ADJAnalyzer: calling Class: %@ || funcName: %@ || params: %@", callingClass, funcName, paramsStr);
              if([callingClass isEqual:@"TestLibrary"]) {
                  [ADJAnalyzer onReceiveTestCommand:funcName params:paramsDict];
              }
              else {
                  onReceiveCommand(callingClass, funcName, paramsDict);
              }
          }
      }] resume];
}


// Get the testSession ID from the cookie
+ (void)parseCookieAndSetTestSessionIdUrl:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResp allHeaderFields] forURL:[response URL]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[response URL] mainDocumentURL:nil];
    for (NSHTTPCookie *cookie in cookies) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithInt:cookie.version] forKey:NSHTTPCookieVersion];
        
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:31536000] forKey:NSHTTPCookieExpires];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        //decode the first cookie's value from an encoded base64 string
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:cookie.value options:0];
        
        NSError *error;
        NSDictionary *cookieDict = [NSJSONSerialization JSONObjectWithData:decodedData options:kNilOptions error:&error];
        
        if(error != nil) {
            NSLog(@"Error parsing decoded cookie");
            return;
        }
        
        NSString *testSessionId = [cookieDict objectForKey:@"testSessionId"];
        NSString *targetUrl = [NSString stringWithFormat:@"%@/%@", [ADJUtil baseUrl], testSessionId];
        
        NSLog(@"Test session url: %@", targetUrl);
        
        //set base url
        [ADJUtil setBaseUrl:targetUrl];
    }
}

//Called when receiving a command related to the test library
+ (void)onReceiveTestCommand:(NSString *)funcName
                      params:(NSDictionary *)params
{
    if([funcName isEqual: @"onCreate"]) {
        NSString *appToken = [params objectForKey:@"appToken"][0];
        NSString *environment = [params objectForKey:@"environment"][0];
        
        ADJConfig *config = [ADJConfig configWithAppToken:appToken environment:environment];
        [config setLogLevel:ADJLogLevelVerbose];
        [Adjust appDidLaunch:config];
        [Adjust trackSubsessionStart];
    }
}

@end
