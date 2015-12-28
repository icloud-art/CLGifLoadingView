//
//  CLRefreshView.h
//  CLMJRefresh
//
//  Created by Charles on 15/12/28.
//  Copyright © 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLRefreshView : UIView
@property (weak,nonatomic) UIScrollView * scrollView;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
@end
