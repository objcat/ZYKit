//
//  ZYTabBarItem.h
//  二级页面tabbar测试
//
//  Created by 张祎 on 2019/7/8.
//  Copyright © 2019 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYTabBarItem : UIControl
+ (instancetype)tabBarWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *selectedImage;
@end

NS_ASSUME_NONNULL_END
