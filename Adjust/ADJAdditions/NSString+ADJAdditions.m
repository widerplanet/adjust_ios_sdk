//
//  NSString+ADJAdditions.m
//  Adjust
//
//  Created by Christian Wellenbrock on 23.07.12.
//  Copyright (c) 2012-2014 adjust GmbH. All rights reserved.
//

#import "NSString+ADJAdditions.h"

@implementation NSString(ADJAdditions)

- (NSString *)adjTrim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString *)adjUrlEncode {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
#pragma clang diagnostic pop

    // Alternative:
    // return [self stringByAddingPercentEncodingWithAllowedCharacters:
    //        [NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "]];
}

- (NSString *)adjRemoveColons {
    return [self stringByReplacingOccurrencesOfString:@":" withString:@""];
}

+ (BOOL) adjIsEqual:(NSString *)first toString:(NSString *)second {
    if (first == nil && second == nil) {
        return YES;
    }
    
    return [first isEqualToString:second];
}

@end
