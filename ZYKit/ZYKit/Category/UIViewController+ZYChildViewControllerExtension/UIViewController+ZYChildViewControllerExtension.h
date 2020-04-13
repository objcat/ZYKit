//
//  UIViewController+ZYChildViewControllerExtension.h
//  xib控制器测试
//
//  Created by 张祎 on 2017/9/22.
//  Copyright © 2017年 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZYChildViewControllerExtension)

/**
 转换到子视图控制器

 @param index 数组中的位置 self.childViewControllers
 */
- (void)zy_transitionFromViewControllerWithIndex:(NSInteger)index;

/**
 当前视图控制器 这个属性不需要动
 */
@property (nonatomic, weak) UIViewController *currentVC;

@end
