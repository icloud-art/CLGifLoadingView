//
//  CLGifLoadView.h
//  CLMJRefresh
//
//  Created by Charles on 15/12/18.
//  Copyright © 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CLLoadState){
    CLLoadStateLoading,
    CLLoadStateFinish,
    CLLoadStateFailed
};
typedef void(^RetryBlock)();

@interface CLGifLoadView : UIView
{
    RetryBlock myRetryBlock;
}
@property (assign,nonatomic) CLLoadState state;
@property (assign,nonatomic) RetryBlock retryBlcok;
@end
