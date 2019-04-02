//
//  AppDelegate+PushService.m
//  LiMagicTutorial
//
//  Created by Wu on 2019/4/1.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "AppDelegate+PushService.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "JANALYTICSService.h"
#import "ADViewController.h"
#import "NSString+URL.h"
#import <AdSupport/AdSupport.h>
#import <AVOSCloud/AVOSCloud.h>
#import "UIColor+Magic.h"
#import "HomeViewController.h"

@implementation AppDelegate (PushService)

#pragma mark - Push Service

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

//背景觸發
- (void)jpushNotificationCenter :(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@", userInfo);
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        AVQuery *dataQuery =  [AVQuery queryWithClassName:kAACVOS_ADVIEW_NAME];
        
        [dataQuery getObjectInBackgroundWithId:kAACVOS_AD_ID block:^(AVObject * _Nullable avObject, NSError * _Nullable error) {
            //print
            NSLog(@"%@", avObject);
            
            //get value
            BOOL control = ((NSNumber *)[avObject objectForKey:@"control"]).boolValue;
            NSString *url_home = [avObject objectForKey:@"url_hide"];
            NSString *url_push = [userInfo objectForKey:@"url"];
            
            //distinguish route ways
            if (control) {
                
                ADViewController *webVC = [ADViewController initWithURL:[url_home trimForURL]];
                
                //has push url
                if (url_push != nil) {
                    [webVC loadURL:[url_push trimForURL]];
                } //or nothing
                
                [[UIApplication sharedApplication].delegate.window setRootViewController:webVC];
                
                hasNotificationEnterInURL = 1;
                
            } else { //control == false
                
                if (url_push != nil) { //load url & dismiss
                    
                    ADViewController *webVC = [ADViewController initWithURL:[url_push trimForURL]];
                    [webVC thgieHraBmottoBtouyal:0];
                    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
                    [vc presentViewController:webVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [webVC dismissViewControllerAnimated:YES completion:nil];
                        });
                    }];
                    
                } else {
                    //do nothing
                }
                
                hasNotificationEnterInURL = 0;
            }
        }];
    }
    completionHandler();
}

//前景觸發
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"%@", userInfo);
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    }
}




@end
