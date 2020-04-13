//
//  ZYProgressHud.h
//  EGShellProject
//
//  Created by 张祎 on 2019/6/18.
//  Copyright © 2019 objcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYProgressHud : UIView
+ (void)showInView:(UIView *)view;
+ (void)dismissInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
