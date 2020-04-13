//
//  UIColor+Extension.h
//  EGShellProject
//
//  Created by 张祎 on 2019/4/17.
//  Copyright © 2019年 objcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

/**
 通过16进制字符串创建颜色, 例如: #F173AC 是粉色
 @param hexString 16进制字符串
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)mainColor;

+ (UIColor *)colorWithRGBA:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithProgress:(CGFloat)progress;

- (BOOL)isEqualToColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
