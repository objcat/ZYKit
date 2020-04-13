//
//  ZYDefine.h
//  ZYKit
//
//  Created by 张祎 on 16/4/8.
//  Copyright © 2016年 张祎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/** Release去掉打印 */
#ifdef DEBUG
#define ZYLog(...) NSLog(__VA_ARGS__)
#else
#define ZYLog(...)
#endif

/** swizzling(该方法来自网易云信) */
static inline void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/** 去除PerformSelector警告 */
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/** 设备尺寸 判断 */
#define IPHONE3_5 ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 480) || ([UIScreen mainScreen].bounds.size.width == 480 && [UIScreen mainScreen].bounds.size.height == 320)
#define IPHONE4_0 ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 568) || ([UIScreen mainScreen].bounds.size.width == 568 && [UIScreen mainScreen].bounds.size.height == 320)
#define IPHONE4_7 ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 667) || ([UIScreen mainScreen].bounds.size.width == 667 && [UIScreen mainScreen].bounds.size.height == 375)
#define IPHONE5_5 ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 736) || ([UIScreen mainScreen].bounds.size.width == 736 && [UIScreen mainScreen].bounds.size.height == 414)
#define IPHONE5_8 ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812) || ([UIScreen mainScreen].bounds.size.width == 812 && [UIScreen mainScreen].bounds.size.height == 375)































