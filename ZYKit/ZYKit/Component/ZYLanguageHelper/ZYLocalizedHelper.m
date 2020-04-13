//
//  ZYLanguageHelper.m
//
//  Created by 张祎 on 2018/4/27.
//  Copyright © 2018年 张祎. All rights reserved.
//

#import "ZYLocalizedHelper.h"

/** 中文 */
NSString * const CHINESE = @"zh-Hans";
/** 蒙古文 */
NSString * const MONGOLIAN = @"mn";
/** 英文 */
NSString * const ENGLISH = @"en";

#define DEFAULTLANGUAGE CHINESE

@interface ZYLocalizedHelper ()
@property (class, readonly) NSBundle *bundle;
@property (class, readonly) NSString *tableName;
@property (class, readonly) NSUserDefaults *lanUserDefaults;
@end

@implementation ZYLocalizedHelper

+ (NSBundle *)bundle {
    NSString *ud_language = ZYLocalizedHelper.language;
    if (!ud_language) {
        // 设置默认语言为中文
        ZYLocalizedHelper.language = DEFAULTLANGUAGE;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:self.language ofType:@"lproj"];
    return [NSBundle bundleWithPath:path];
}

+ (NSString *)textWithKey:(NSString *)key {
    NSString *text = NSLocalizedStringFromTableInBundle(key, self.tableName, self.bundle, @"");
    return text;
}

+ (NSUserDefaults *)lanUserDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:@"zy_localized_language"];
}

+ (NSString *)language {
    return [self.lanUserDefaults objectForKey:@"language"];
}

+ (void)setLanguage:(NSString *)language {
    [self.lanUserDefaults setObject:language forKey:@"language"];
}

/** 本地化文件名称 */
+ (NSString *)tableName {
    return @"zy_localized_language";
}

@end
