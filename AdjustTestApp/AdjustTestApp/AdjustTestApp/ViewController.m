//
//  ViewController.m
//  AdjustTestApp
//
//  Created by Pedro on 23.08.17.
//  Copyright © 2017 adjust. All rights reserved.
//

#import "ViewController.h"
#import "Adjust.h"
#import "ATLTestLibrary.h"
#import "ATAAdjustCommandExecutor.h"
#import "ADJAdjustFactory.h"

@interface ViewController ()
@property (nonatomic, strong) ATLTestLibrary * testLibrary;
@property (nonatomic, strong) ATAAdjustCommandExecutor * adjustCommandExecutor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.adjustCommandExecutor = [[ATAAdjustCommandExecutor alloc] init];
    NSString * baseUrl = @"http://127.0.0.1:8080";
    [ADJAdjustFactory setTestingMode:baseUrl];

    self.testLibrary = [ATLTestLibrary testLibraryWithBaseUrl:baseUrl andCommandDelegate:self.adjustCommandExecutor];
    [self.adjustCommandExecutor setTestLibrary:self.testLibrary];
//    [self.testLibrary setTests:[NSString stringWithFormat:@"%@;%@;%@",
//                                @"current/attributionCallback/Test_AttributionCallback_ask_in_multiple",
//                                @"current/attributionCallback/Test_AttributionCallback_ask_in_once",
//                                @"current/attributionCallback/Test_AttributionCallback_no_ask_in"]];
//    [self.testLibrary setTests:[NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@",
//                                @"current/appSecret/Test_AppSecret_no_secret",
//                                @"current/appSecret/Test_AppSecret_with_secret",
//                                @"current/attributionCallback/Test_AttributionCallback_ask_in_multiple",
//                                @"current/attributionCallback/Test_AttributionCallback_ask_in_once",
//                                @"current/attributionCallback/Test_AttributionCallback_no_ask_in",
//                                @"current/deeplink/Test_Deeplink_afterStart_beforeResume",
//                                @"current/deeplink/Test_Deeplink_afterStartAndResume",
//                                @"current/deeplink/Test_Deeplink_beforeResume_restart",
//                                @"current/deeplink/Test_Deeplink_beforeStart",
//                                @"current/defaultTracker/Test_DefaultTracker_empty_string",
//                                @"current/defaultTracker/Test_DefaultTracker_null_string",
//                                @"current/defaultTracker/Test_DefaultTracker_valid_string",
//                                @"current/delayStart/Test_DelayStart_delay_0",
//                                @"current/delayStart/Test_DelayStart_delay_5_call_sendFirstPackages",
//                                @"current/delayStart/Test_DelayStart_delay_5",
//                                @"current/delayStart/Test_DelayStart_delay_15",
//                                @"current/delayStart/Test_DelayStart_delay_negative",
//                                @"current/disableEnable/Disable_pushToken_enable",
//                                @"current/disableEnable/Disable_referrer_enable",
//                                @"current/disableEnable/Disable_restart_track",
//                                @"current/disableEnable/Disable_start_enable",
//                                @"current/disableEnable/Disable_track_Enable_track",
//                                @"current/event/Test_Event_Count_6events",
//                                @"current/event/Test_Event_EventToken_Malformed",
//                                @"current/event/Test_Event_OrderId",
//                                @"current/event/Test_Event_Params",
//                                @"current/event/Test_Event_Revenue_invalid",
//                                @"current/event/Test_Event_Revenue_valid",
//                                @"current/eventBuffering/Test_EventBuffering_agnostic_packets",
//                                @"current/eventBuffering/Test_EventBuffering_install_only",
//                                @"current/eventBuffering/Test_EventBuffering_sensitive_packets",
//                                @"current/initMalformed/Test_Init_Malformed_empty_appToken",
//                                @"current/initMalformed/Test_Init_Malformed_empty_environment",
//                                @"current/initMalformed/Test_Init_Malformed_missing_appToken",
//                                @"current/initMalformed/Test_Init_Malformed_missing_environment",
//                                @"current/initMalformed/Test_Init_Malformed_wrong_appToken",
//                                @"current/initMalformed/Test_Init_Malformed_wrong_environment",
//                                @"current/offlineMode/Test_OfflineMode",
//                                @"current/sdkInfo/Test_PushToken_after_install",
//                                @"current/sdkInfo/Test_PushToken_before_install_kill_in_between",
//                                @"current/sdkInfo/Test_PushToken_before_install",
//                                @"current/sdkInfo/Test_PushToken_between_create_and_resume",
//                                @"current/sdkInfo/Test_PushToken_multiple_tokens",
//                                @"current/sdkPrefix/Test_SdkPrefix_empty_value",
//                                @"current/sdkPrefix/Test_SdkPrefix_null_value",
//                                @"current/sdkPrefix/Test_SdkPrefix_with_value",
//                                @"current/sendInBackground/Test_SendInBackground_send_false",
//                                @"current/sendInBackground/Test_SendInBackground_send_true",
//                                @"current/sessionCount/Test_SessionCount",
//                                @"current/sessionEventCallbacks/Test_EventCallback_failure",
//                                @"current/sessionEventCallbacks/Test_EventCallback_success",
//                                @"current/sessionEventCallbacks/Test_SessionCallback_failure",
//                                @"current/sessionEventCallbacks/Test_SessionCallback_success",
//                                @"current/sessionParams/Test_SessionParams_add",
//                                @"current/sessionParams/Test_SessionParams_overwrite",
//                                @"current/sessionParams/Test_SessionParams_remove",
//                                @"current/sessionParams/Test_SessionParams_reset",
//                                @"current/subsessionCount/Test_SubsessionCount"]];
    [self startTestSession];
}

- (void)startTestSession {
    [self.testLibrary startTestSession:@"ios4.12.0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)restartTestClick:(UIButton *)sender {
    [self startTestSession];
}


@end
