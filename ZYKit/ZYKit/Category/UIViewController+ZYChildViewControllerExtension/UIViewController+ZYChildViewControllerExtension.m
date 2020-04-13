//
//  UIViewController+ZYChildViewControllerExtension.m
//  xib控制器测试
//
//  Created by 张祎 on 2017/9/22.
//  Copyright © 2017年 张祎. All rights reserved.
//

#import "UIViewController+ZYChildViewControllerExtension.h"
#import <objc/runtime.h>
static NSString *currentVCKey = @"currentVCKey";

@implementation UIViewController (ZYChildViewControllerExtension)
- (void)zy_transitionFromViewControllerWithIndex:(NSInteger)index {
    
    // 如果没有子控制器 不做任何操作
    if (self.childViewControllers.count <= 0) {
        return;
    }
    
    //如果当前控制器为空  默认第一个控制器
    if (self.currentVC == nil) {
        self.currentVC = self.childViewControllers[0];
    }
    
    //如果是当前控制器与所转换控制器为同一个控制器  不进行任何操作
    if (self.currentVC == self.childViewControllers[index]) {
        return;
    }
    
    [self transitionFromViewController:self.currentVC toViewController:self.childViewControllers[index] duration:0 options:0 animations:nil completion:nil];
    
    self.currentVC = self.childViewControllers[index];
}

- (void)setCurrentVC:(UIViewController *)currentVC {
    objc_setAssociatedObject(self, &currentVCKey, currentVC, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)currentVC {
    return objc_getAssociatedObject(self, &currentVCKey);
}

@end
