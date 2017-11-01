//
//  ATAAdjustDelegate.m
//  AdjustTestApp
//
//  Created by Pedro on 26.10.17.
//  Copyright © 2017 adjust. All rights reserved.
//
#import <objc/runtime.h>
#import "ATAAdjustDelegate.h"

@interface ATAAdjustDelegate ()

@property (nonatomic, strong) ATLTestLibrary *testLibrary;

@end

@implementation ATAAdjustDelegate

- (id)initWithTestLibrary:(ATLTestLibrary *)testLibrary {
    self = [super init];

    if (nil == self) {
        return nil;
    }

    self.testLibrary = testLibrary;

    return self;
}

- (void)swizzleCallbackMethod:(SEL)originalSelector
             swizzledSelector:(SEL)swizzledSelector {
    Class className = [self class];

    Method originalMethod = class_getInstanceMethod(className, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(className, swizzledSelector);

    BOOL didAddMethod = class_addMethod(className,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(className,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)attributionCallbackSendAll:(ADJAttribution *)attribution {
    NSLog(@"Attribution callback called!");
    NSLog(@"Attribution: %@", attribution);

    [self.testLibrary addInfoToSend:@"trackerToken" value:attribution.trackerToken];
    [self.testLibrary addInfoToSend:@"trackerName" value:attribution.trackerName];
    [self.testLibrary addInfoToSend:@"network" value:attribution.network];
    [self.testLibrary addInfoToSend:@"campaign" value:attribution.campaign];
    [self.testLibrary addInfoToSend:@"adgroup" value:attribution.adgroup];
    [self.testLibrary addInfoToSend:@"creative" value:attribution.creative];
    [self.testLibrary addInfoToSend:@"clickLabel" value:attribution.clickLabel];
    [self.testLibrary addInfoToSend:@"adid" value:attribution.adid];

    [self.testLibrary sendInfoToServer];
}

@end
