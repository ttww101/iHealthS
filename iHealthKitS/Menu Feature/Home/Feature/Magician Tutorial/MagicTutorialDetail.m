//
//  MagicTutorialDetail.m
//  iHealthS
//
//  Created by Wu on 2019/3/23.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "MagicTutorialDetail.h"

@implementation MagicTutorialDetail

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
//        NSArray *arr = (NSArray *)attributes;
//        int i = 0;
//        for (id object in arr) {
//            i++;
//        }
//        NSLog(@"%@", @(i));
        self.mainTitle = [attributes objectForKey:@"main_title"];
        self.title = [attributes objectForKey:@"title"];
//        self.imageURLs = [attributes objectForKey:@"image"];
        self.imageURLs = @[@"1234", @"123"];
        self.contents = @[@"12344", @"1234"];
//        self.contents = [attributes objectForKey:@"text"];
    }
    return self;
}

@end
