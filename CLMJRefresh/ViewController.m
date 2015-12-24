//
//  ViewController.m
//  CLMJRefresh
//
//  Created by Charles on 15/12/18.
//  Copyright © 2015年 Charles. All rights reserved.
//

#import "ViewController.h"
#import "CLRefreshHeader.h"
#import "CLGifLoadView.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView * mTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Charles";
    self.view.backgroundColor = [UIColor whiteColor];
    self.mTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.mTableView.delegate =self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
    self.mTableView.header = [CLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.mTableView.header beginRefreshing];
    
    CLGifLoadView * gifLoading = [[CLGifLoadView alloc]initWithFrame:self.view.bounds];
    gifLoading.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:gifLoading];
    
    __weak CLGifLoadView * gifload = gifLoading;
    [gifLoading setRetryBlcok:^{
        NSLog(@"重试");
        [gifload setState:CLLoadStateLoading];
    }];
}

- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mTableView.header endRefreshing];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strId = @"ID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zi行",indexPath.row+1];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
