//
//  ChineseInclude.m
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "ChineseInclude.h"

@implementation ChineseInclude
//判断是否为汉字
+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end
