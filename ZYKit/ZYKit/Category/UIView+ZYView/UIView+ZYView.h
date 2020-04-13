//
//  UIView+ZYView.h
//  ZYKit
//
//  Created by 张祎 on 4/15/16.
//  Copyright © 2016 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZYView)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

/**
 *  获取当前视图控制器
 */
- (UIViewController *)viewController;
@end
