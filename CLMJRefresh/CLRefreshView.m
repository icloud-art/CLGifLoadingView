//
//  CLRefreshView.m
//  CLMJRefresh
//
//  Created by Charles on 15/12/28.
//  Copyright © 2015年 Charles. All rights reserved.
//

#import "CLRefreshView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface CLRefreshView()<UIScrollViewDelegate>
{
    BOOL isStop;
}
@property (strong,nonatomic) NSMutableArray * dataSource;

@end
@implementation CLRefreshView
- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    if (self = [super init]) {
        self.frame = CGRectMake(0,-64, kScreenWidth, 64);
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i<6; i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 30)/2,34/2 , 30, 30)];
            imageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"PullReflashIcon_%zi",i]];
            imageView.tag = i+100;
            [self.dataSource addObject:imageView];
            [self addSubview:imageView];
        }
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = 64;
        self.scrollView.contentInset = inset;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView = scrollView;
        self.scrollView.delegate = self;
        [self.scrollView addSubview:self];
        [self showAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissView];
        });

        NSLog(@"刷新");
    }
    return self;
}

- (void)showAnimation{
    if (isStop) {
        return;
    }
    for (int i=0; i<self.dataSource.count; i++) {
                UIImageView * imageView = self.dataSource[i];
        [self performSelector:@selector(animation:) withObject:imageView afterDelay:i*0.2 inModes:@[NSRunLoopCommonModes]];
    }
}
- (void)animation:(UIImageView *)imageView{
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
- (void)dismissAnimation:(UIImageView *)imageView{
    [UIView animateWithDuration:0.25 animations:^{
        imageView.frame = CGRectMake(imageView.frame.origin.x, -64, imageView.frame.size.width, imageView.frame.size.height);
        imageView.alpha = 1;
    }];
}
- (void)dismissView{
    for (int i = (int)self.dataSource.count - 1; i>=0; i--) {
        UIImageView * imageView = self.dataSource[i];
        [self performSelector:@selector(dismissAnimation:) withObject:imageView afterDelay:i*0.2 inModes:@[NSDefaultRunLoopMode]];
    }
    isStop = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = _scrollView.contentInset;
            inset.top = 64;
            self.scrollView.contentInset = inset;
            // 2.设置滚动位置
            self.scrollView.contentOffset = CGPointMake(0, 0);
            isStop = NO;
        }];
    });
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"start dragging");
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"totops");
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"endScroll");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"didScrollView");
    CGFloat offset = scrollView.contentOffset.y;
    if (offset == 0) {
        for (int i = 0; i<self.dataSource.count; i++) {
            UIImageView * imageView = self.dataSource[i];
            imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 30)/2,34/2 , 30, 30);
            imageView.alpha = 1;
        }
    }
    else if (offset == -64){
        [UIView animateWithDuration:0.25 animations:^{
            // 1.增加65的滚动区域
            UIEdgeInsets inset = _scrollView.contentInset;
            inset.top = 64;
            scrollView.contentInset = inset;
            // 2.设置滚动位置
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    NSLog(@"offset is %f",offset);
    if (offset == -64) {
        [self showAnimation];
        scrollView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissView];
        });
    }
    

    NSLog(@"didEndScrollView");
}

@end
