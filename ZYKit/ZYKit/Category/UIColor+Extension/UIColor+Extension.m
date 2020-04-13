//
//  UIColor+Extension.m
//  EGShellProject
//
//  Created by 张祎 on 2019/4/17.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF) / 255.0f;
    float green = ((baseValue >> 16) & 0xFF) / 255.0f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
    float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+ (UIColor *)mainColor {
    return [UIColor colorWithRed:57 / 255.0 green:152 / 255.0 blue:247 / 255.0 alpha:1];;
}

+ (UIColor *)colorWithRGBA:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)colorWithProgress:(CGFloat)progress {
    
    if (progress <= 25) {
        return [UIColor colorWithHexString:@"#F25643"];
    } else if (progress <= 50) {
        return [UIColor colorWithHexString:@"#FF943E"];
    } else if (progress <= 75) {
        return [UIColor colorWithHexString:@"#3296FB"];
    } else {
        return [UIColor colorWithHexString:@"#15BC83"];
    }
}

- (BOOL)isEqualToColor:(UIColor *)color {
    UIColor *color1 = self;
    UIColor *color2 = color;
    CGFloat red1, green1, blue1, alpha1;
    CGFloat red2, green2, blue2, alpha2;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    if (red1 == red2 && green1 == green2 && blue1 == blue2 && alpha1 == alpha2) {
        return YES;
    } else {
        return NO;
    }
}

@end
