//
//  ZYLocalizedHelper.h
//
//  Created by 张祎 on 2018/4/27.
//  Copyright © 2018年 objcat. All rights reserved.
//  切换语言工具类

#import <Foundation/Foundation.h>

/** 中文 */
extern NSString * const CHINESE;
/** 蒙古文 */
extern NSString * const MONGOLIAN;
/** 英文 */
extern NSString * const ENGLISH;

#define ZYLocalizedString(x) [ZYLocalizedHelper textWithKey:x]

@interface ZYLocalizedHelper : NSObject
/** 切换语言 - 请参考枚举 */
@property (class) NSString *language;
/** 根据key获取本地化语言a */
+ (NSString *)textWithKey:(NSString *)key;

@end
