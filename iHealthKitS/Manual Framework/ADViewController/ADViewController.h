//
//  OnlineServiceViewController.h
//  Service
//
//  Created by yue on 2017/9/27.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//
// 此类 最低 适配 iOS 8
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ADViewController : UIViewController

@property (nonatomic,strong) NSString *webViewURL;

+ (instancetype)initWithURL:(NSString *)urlString;
- (void)thgieHraBmottoBtouyal:(CGFloat)height;
- (void)loadURL:(NSString *)url;

@end
