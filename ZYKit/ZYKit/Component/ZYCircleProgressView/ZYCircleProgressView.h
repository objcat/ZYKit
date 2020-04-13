//
//  ZYCircleProgressView.h
//  圆形进度条
//
//  Created by 张祎 on 2019/7/11.
//  Copyright © 2019 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYCircleProgressViewType) {
    /** 渐变 */
    ZYCircleProgressViewTypeGradual,
    /** 普通颜色 */
    ZYCircleProgressViewTypeColor,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZYCircleProgressView : UIView

/** 设置进度 默认动画 0.5s */
@property (assign, nonatomic) CGFloat progress;
/** 进度条颜色 */
@property (strong, nonatomic) UIColor *progressTintColor;
/** 背景颜色 */
@property (strong, nonatomic) UIColor *trackTintColor;
/** 颜色填充类型 */
@property (assign, nonatomic) ZYCircleProgressViewType type;
/** 进度条宽度 */
@property (assign, nonatomic) CGFloat lineWidth;

- (void)drawProgress;

/**
 设置进度以及动画时间

 @param progress 进度
 @param duration 动画时间
 */
- (void)setProgress:(CGFloat)progress duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
