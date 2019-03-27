//
//  TutorialDetailViewController.m
//  iHealthS
//
//  Created by Wu on 2019/3/23.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "TutorialDetailViewController.h"
#import "URLSessionManager.h"
#import "UIView+Constraint.h"
#import "MagicTutorialDetail.h"

@interface TutorialDetailViewController () <UITableViewDataSource>

@property (nonatomic, strong) MagicTutorialType *tutorialType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MagicTutorialDetail *detail;

@end

@implementation TutorialDetailViewController

#pragma mark - Public

- (instancetype)initWithTutorialType:(MagicTutorialType *)tutorialType {
    self = [super init];
    if (self) {
        self.tutorialType = tutorialType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contencell"];
    [self.view addSubview:self.tableView];
    [self.tableView constraints:self.view];
    [self requestDetail:self.tutorialType];
}

- (void)requestDetail:(MagicTutorialType *)tutorialType {
    NSDictionary *params = @{@"type":self.tutorialType.type,
                             @"page":@"1"};
    [[URLSessionManager shared] requestURL:@"http://47.75.131.189/c210496866fe223ab4a4af746934820b/" method:@"POST" params:params completion:^(NSDictionary *dicData) {
        NSArray *dic = [dicData objectForKey:@"data"];
        MagicTutorialDetail *detail = [[MagicTutorialDetail alloc] initWithAttributes:[dic[0] objectForKey:@"data"]];
        self.detail = detail;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.detail == nil) return 0;
    return self.detail.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"titlecell", @"subtitlecell",@"contencell"];
    NSString *identifier = identifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        if ([identifier isEqualToString:@"titlecell"]) {
            
        }
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"123";
    return cell;
}

@end
