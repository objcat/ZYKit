//
//  UIView+MasonryExtension.m
//  EGShellProject
//
//  Created by 张祎 on 2019/5/12.
//  Copyright © 2019年 objcat. All rights reserved.
//

#import "UIView+MasonryExtension.h"
#import "Masonry.h"

@implementation UIView (MasonryExtension)
- (void)fullViewControllerAutoLayout {
    UIViewController *superVC = [self viewController];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superVC.mas_topLayoutGuide);
        make.left.right.equalTo(superVC.view);
        make.bottom.equalTo(superVC.mas_bottomLayoutGuide);
    }];
}

- (UIViewController *)viewController{
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
