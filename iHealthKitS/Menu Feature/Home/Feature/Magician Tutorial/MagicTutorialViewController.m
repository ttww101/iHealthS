//
//  MagicTutorialViewController.m
//  iHealthS
//
//  Created by Wu on 2019/3/23.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "MagicTutorialViewController.h"
#import "BaseViewController.h"
#import "UIView+Constraint.h"
#import "TutorialDetailViewController.h"

@interface MagicTutorialViewController ()

@property (strong, nonatomic) NSMutableArray<MagicTutorialType *> *mTypes;

@end

@implementation MagicTutorialViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController type:(NSMutableArray *)mTypes {
    self.mTypes = mTypes;
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *mVCArr = [NSMutableArray new];
    NSMutableArray *mtitles = [NSMutableArray new];
    for (MagicTutorialType *type in self.mTypes) {
        TutorialDetailViewController *vc = [[TutorialDetailViewController alloc] initWithTutorialType:type];
        [mVCArr addObject:vc];
        [mtitles addObject:type.title];
    }
    self.buttonText = mtitles;
    [self.viewControllerArray addObjectsFromArray:mVCArr];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *button = [UIButton new];
    [button setTitle:@"關閉" forState:UIControlStateNormal];
    [self.navigationView addSubview:button];
    button.frame = CGRectMake(self.view.frame.size.width - 100, -24, 100, 44);
    [button addTarget:self action:@selector(closeButtonDidTouchupInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.selectionBar setBackgroundColor:[UIColor whiteColor]];
    [self.selectionBar setAlpha:0.8];
    [self setNavigationBackgroundColor];
}

- (void)setNavigationBackgroundColor {
    self.navigationBar.barTintColor = [UIColor colorWithRed:51/255.f green:18/255.f blue:47/255.f alpha:1];//%%% buttoncolors
}

- (void)closeButtonDidTouchupInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
