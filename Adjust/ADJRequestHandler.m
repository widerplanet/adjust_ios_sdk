//
//  ADJRequestHandler.m
//  Adjust
//
//  Created by Christian Wellenbrock on 2013-07-04.
//  Copyright (c) 2013 adjust GmbH. All rights reserved.
//

#import "ADJActivityPackage.h"
#import "ADJLogger.h"
#import "ADJUtil.h"
#import "NSString+ADJAdditions.h"
#import "ADJAdjustFactory.h"
#import "ADJActivityKind.h"

static const char * const kInternalQueueName = "io.adjust.RequestQueue";

#pragma mark - private
@interface ADJRequestHandler()

@property (nonatomic, strong) dispatch_queue_t internalQueue;
@property (nonatomic, weak) id<ADJPackageHandler> packageHandler;
@property (nonatomic, weak) id<ADJLogger> logger;
@property (nonatomic, strong) NSURL *baseUrl;

@end

#pragma mark -
@implementation ADJRequestHandler

+ (ADJRequestHandler *)handlerWithPackageHandler:(id<ADJPackageHandler>)packageHandler {
    return [[ADJRequestHandler alloc] initWithPackageHandler:packageHandler];
}

- (id)initWithPackageHandler:(id<ADJPackageHandler>) packageHandler {
    self = [super init];
    if (self == nil) return nil;

    self.internalQueue = dispatch_queue_create(kInternalQueueName, DISPATCH_QUEUE_SERIAL);
    self.packageHandler = packageHandler;
    self.logger = ADJAdjustFactory.logger;
    self.baseUrl = [NSURL URLWithString:ADJUtil.baseUrl];

    return self;
}

- (void)sendPackage:(ADJActivityPackage *)activityPackage
          queueSize:(NSUInteger)queueSize
{
    [ADJUtil launchInQueue:self.internalQueue
                selfInject:self
                     block:^(ADJRequestHandler* selfI) {
                         [selfI sendI:selfI
                     activityPackage:activityPackage
                           queueSize:queueSize];
                     }];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"URLSession:didBecomeInvalidWithError");
}
/*
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"URLSession:didReceiveChallenge:completionHandler");
}
*/
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"URLSession:task:didCompleteWithError:");

    if (error != nil) {
        NSLog(@"error not nil");

        NSLog(@"error.localizedDescription %@", error.localizedDescription);
    }
}
/*
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:");
}
*/
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * _Nullable))completionHandler
{
    NSLog(@"URLSession:task:needNewBodyStream");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    NSLog(@"URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler");
}
/*
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"URLSession:dataTask:didReceiveResponse:completionHandler");
}
*/
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"URLSession:dataTask:didBecomeDownloadTask");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
    NSLog(@"URLSession:dataTask:didBecomeStreamTask");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"URLSession:dataTask:didReceiveData");

    NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] adjTrim];
    [ADJAdjustFactory.logger verbose:@"Response: %@", responseString];

    ADJResponseData *responseData = [ADJResponseData buildResponseData:nil];
    [ADJUtil saveJsonResponse:data responseData:responseData];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    NSLog(@"URLSession:dataTask:willCacheResponse:completionHandler");
}

- (void)teardown {
    [ADJAdjustFactory.logger verbose:@"ADJRequestHandler teardown"];

    self.internalQueue = nil;
    self.packageHandler = nil;
    self.logger = nil;
    self.baseUrl = nil;
}

#pragma mark - internal
- (void)sendI:(ADJRequestHandler *)selfI
activityPackage:(ADJActivityPackage *)activityPackage
   queueSize:(NSUInteger)queueSize
{

    [ADJUtil sendPostRequest:selfI.baseUrl
                   queueSize:queueSize
          prefixErrorMessage:activityPackage.failureMessage
          suffixErrorMessage:@"Will retry later"
             activityPackage:activityPackage
          urlSessionDelegate:selfI
         responseDataHandler:^(ADJResponseData * responseData)
    {
        if (responseData.jsonResponse == nil) {
            [selfI.packageHandler closeFirstPackage:responseData activityPackage:activityPackage];
            return;
        }

        [selfI.packageHandler sendNextPackage:responseData];
     }];
}

@end
