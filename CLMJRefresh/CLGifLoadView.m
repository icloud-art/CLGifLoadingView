//
//  CLGifLoadView.m
//  CLMJRefresh
//
//  Created by Charles on 15/12/18.
//  Copyright © 2015年 Charles. All rights reserved.
//


#import "CLGifLoadView.h"
#import "UIView+MJExtension.h"

@interface CLGifLoadView()
@property (weak, nonatomic) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@property (strong, nonatomic) UILabel * stateLabel;

@property (strong, nonatomic) UIButton * btnRetry;

@end

@implementation CLGifLoadView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeView];
    }
    return self;
}

- (void)makeView{
    // 设置普通状态的动画图片
    self.gifView = [self gifView];
    self.gifView.frame = CGRectMake(0,0, 214/2, 133/2);
    self.gifView.backgroundColor = [UIColor clearColor];
    self.gifView.center = self.center;
    
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.gifView.frame.origin.x, CGRectGetMaxY(self.gifView.frame) + 10, self.gifView.frame.size.width, 20)];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.font = [UIFont systemFontOfSize:12.0f];
    self.stateLabel.textColor = [UIColor lightGrayColor];
    self.stateLabel.text = @"努力加载中...";
    [self addSubview:self.stateLabel];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:CLLoadStateLoading];

    [self setState:CLLoadStateLoading];
}
#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(CLLoadState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(CLLoadState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法

- (void)placeSubviews
{
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

- (void)setState:(CLLoadState)state
{
    // 根据状态做事情
    if (state == CLLoadStateLoading) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        [self.gifView stopAnimating];
        self.gifView.frame = CGRectMake(0,0, 214/2, 133/2);
        self.gifView.center = self.center;
        
        self.stateLabel.frame = CGRectMake(self.gifView.frame.origin.x, CGRectGetMaxY(self.gifView.frame) + 10, self.gifView.frame.size.width, 20);
        self.stateLabel.text = @"努力加载中...";

        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }

    }else if (state == CLLoadStateFinish){
        [self hide:self After:2];
    }
    else if(state == CLLoadStateFailed){
        [self.gifView stopAnimating];
        self.gifView.image = [UIImage imageNamed:@"icon_error_unkown"];
        self.gifView.frame = CGRectMake(0, 0, 236/2, 256/2);
        self.gifView.center = self.center;
        self.stateLabel.frame = CGRectMake(self.gifView.frame.origin.x - 5, CGRectGetMaxY(self.gifView.frame) + 10, self.gifView.frame.size.width + 10, 20);
        self.stateLabel.text = @"加载数据失败,请重试~";
        if (!self.btnRetry) {
            self.btnRetry = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btnRetry.frame = CGRectMake(self.gifView.frame.origin.x, CGRectGetMaxY(self.stateLabel.frame) + 10, self.gifView.frame.size.width, 30);
            [self.btnRetry setTitle:@"重试" forState:UIControlStateNormal];
            [self.btnRetry setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.btnRetry.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            self.btnRetry.backgroundColor = [UIColor whiteColor];
            self.btnRetry.layer.cornerRadius = 2.0f;
            self.btnRetry.clipsToBounds = YES;
            [self.btnRetry addTarget:self action:@selector(btnRetry:) forControlEvents:UIControlEventTouchUpInside];
            self.btnRetry.layer.borderWidth = .5f;
            self.btnRetry.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [self addSubview:self.btnRetry];
        }
        else{
            self.btnRetry.frame = CGRectMake(self.gifView.frame.origin.x, CGRectGetMaxY(self.stateLabel.frame) + 10, self.gifView.frame.size.width, 30);
            self.btnRetry.hidden = NO;
        }
    }
}
- (void)btnRetry:(UIButton *)sender{
    self.btnRetry.hidden = YES;
    myRetryBlock();
    [self setState:CLLoadStateLoading];
}
- (void)setRetryBlcok:(RetryBlock)retryBlcok{
    myRetryBlock = retryBlcok;
}

- (void)hide{
    [self removeFromSuperview];
}
- (void)hide:(UIView *)view After:(NSTimeInterval)duration{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];

    });
}
@end
