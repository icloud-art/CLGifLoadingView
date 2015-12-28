//
//  CLViewController.m
//  CLMJRefresh
//
//  Created by Charles on 15/12/28.
//  Copyright © 2015年 Charles. All rights reserved.
//

#import "CLViewController.h"
#import "CLRefreshView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface CLViewController ()
@property (strong,nonatomic) NSMutableArray * dataSource;
@end

@implementation CLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    CLRefreshView * header = [[CLRefreshView alloc]initWithScrollView:scrollView];
//    self.automaticallyAdjustsScrollViewInsets = NO;

//    [self.view addSubview:header];
//    [header setScrollView:scrollView];
    
}
- (void)initView{
    self.dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<6; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 30)/2, 100, 30, 30)];
        imageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"PullReflashIcon_%zi",i]];
        imageView.tag = i+100;
        [self.dataSource addObject:imageView];
        [self.view addSubview:imageView];
    }
    [self showAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissView];
    });

}

- (void)showAnimation{
    
    for (int i=0; i<self.dataSource.count; i++) {
        UIImageView * imageView = self.dataSource[i];
        [self performSelector:@selector(barItemAnimation:) withObject:imageView afterDelay:i*0.2 inModes:@[NSRunLoopCommonModes]];
    }
}
- (void)barItemAnimation:(UIImageView *)imageView{
    [imageView.layer removeAllAnimations];
    imageView.alpha = 1;
    [UIView animateWithDuration:0.8 animations:^{
        imageView.alpha = 0.2;
        imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
        imageView.layer.shadowOpacity = 0.2;
        imageView.layer.shadowOffset = CGSizeMake(0, 1);
        imageView.layer.shadowRadius = 2;
    } completion:^(BOOL finished) {
        imageView.alpha = 1;
    }];
    if (imageView.tag == 105) {
        [self showAnimation];
    }
}
- (void)dismissView{
    for (int i = (int)self.dataSource.count - 1; i>=0; i--) {
        [UIView animateWithDuration:0.35 delay:i*0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            UIImageView * imageView = self.dataSource[i];
            imageView.frame = CGRectMake(imageView.frame.origin.x, 0, imageView.frame.size.width, imageView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
