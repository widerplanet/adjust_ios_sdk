//
//  ViewControlleriOS.m
//  AdjustExample-iOS
//
//  Created by Pedro Filipe on 12/10/15.
//  Copyright © 2015 adjust. All rights reserved.
//

#import "Adjust.h"
#import "Constants.h"
#import "URLRequest.h"
#import "ViewControlleriOS.h"
#import "ADJAnalyzer.h"
#import "ADJDictionary.h"

@interface ViewControlleriOS ()

@end

@implementation ViewControlleriOS

- (void)viewDidLoad {
    [super viewDidLoad];
    [ADJAnalyzer init:@"http://192.168.8.138:8080"
     onReceiveCommand:^(NSString *callingClass, NSString *funcName, NSDictionary *paramsDict) {
         [ADJDictionary executeCommand:callingClass funcName:funcName paramsDict:paramsDict];
     }];
}

@end
