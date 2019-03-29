
#define kJPushAppKey @"7e9467347e91cda40096dcb5"
#define kJPushChannel @"PPPPPPPPP"
#define kJPushProduction YES

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SideMenuViewController.h"
#import "TalkingData.h"
#import "MagicTutorialViewController.h"
#import "TutorialDetailViewController.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "JANALYTICSService.h"
#import "ADWebViewController/ADWKWebViewController.h"
#import "NSString+URL/NSString+URL.h"
#import <AdSupport/AdSupport.h>
#import <AVOSCloud/AVOSCloud.h>
#import "UIColor+Magic.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    wax_start("UIWebView.lua", nil);
    
    // 添加talking data统计接口
    [TalkingData sessionStarted:TD_ID withChannelId:@"App Store"];
    
    // 初次启动标记
    self.isFirstStart = YES;
    
    // 谷歌广告标记及其初始化
    self.googleAdSwitch = NO;
    __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[GOOGLE_AD_SWITCH stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    __weak ASIHTTPRequest *request = requests;
    [request setCompletionBlock:^{
        NSData *responseData = [request responseData];
        NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        int googleAdSwitch = [[ret objectForKey:@"switch"]intValue];
        if (googleAdSwitch == 0) {
            appDelegate.googleAdSwitch = YES;
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    
    //MARK: cannot be change the method order
    [self setLauchImageWith:application];
    
    self.sideMenuViewController = [self createSideMenuViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = self.sideMenuViewController;
    [self.window makeKeyAndVisible];
    
    //JPush
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:kJPushChannel
                 apsForProduction:kJPushProduction
            advertisingIdentifier:idfa];
    [JPUSHService setAlias:idfa completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:0];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = kJPushAppKey;
    config.channel = kJPushChannel;
    [JANALYTICSService setupWithConfig:config];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - Private

- (RESideMenu *)createSideMenuViewController {
    // 主视图
    UIViewController *navigationController = [[MLNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    
    // 左视图
    UIViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"effection_0"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1;
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 1.0;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.panGestureEnabled = YES;
    return sideMenuViewController;
}

- (void)setLauchImageWith:(UIApplication *)application {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [application setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bgimg.png"]];
    [[UINavigationBar appearance] setBarTintColor:bgColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont systemFontOfSize:16.0f], NSFontAttributeName, nil]];
}


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
        [AVOSCloud setApplicationId:kAACVOS_ID clientKey:kAACVOS_KEY];
        [AVOSCloud setAllLogsEnabled:YES];
        
        AVQuery *dataQuery =  [AVQuery queryWithClassName:kAACVOS_CLASS_NAME];
        
        [dataQuery getObjectInBackgroundWithId:kAACVOS_OBJECT_ID block:^(AVObject * _Nullable avObject, NSError * _Nullable error) {
            //print
            NSLog(@"%@", avObject);
            
            //get value
            BOOL control = ((NSNumber *)[avObject objectForKey:@"control"]).boolValue;
            NSString *url_home = [avObject objectForKey:@"url_hide"];
            NSString *url_push = [userInfo objectForKey:@"url"];
            
            //distinguish route ways
            if (control) {
                
                ADWKWebViewController *webVC = [ADWKWebViewController initWithURL:[url_home trimForURL]];
                
                //has push url
                if (url_push != nil) {
                    [webVC loadURL:[url_push trimForURL]];
                } //or nothing
                
                [[UIApplication sharedApplication].delegate.window setRootViewController:webVC];
                
                hasNotificationEnterInURL = 1;
                
            } else { //control == false
                
                if (url_push != nil) { //load url & dismiss
                    
                    ADWKWebViewController *webVC = [ADWKWebViewController initWithURL:[url_push trimForURL]];
                    [webVC layoutBottomBarHeight:0];
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
