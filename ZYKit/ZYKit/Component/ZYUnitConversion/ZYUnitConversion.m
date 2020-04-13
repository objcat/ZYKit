//
//  ZYUnitConversion.m
//  MongolianReadProject
//
//  Created by 张祎 on 2018/4/16.
//  Copyright © 2018年 张祎. All rights reserved.
//

#import "ZYUnitConversion.h"

@implementation ZYUnitConversion

+ (NSString *)fileSizeWithByte:(NSInteger)byte {
    
    NSString *size;
    
    if (byte / 1024.0 < 1) {
        size = [NSString stringWithFormat:@"%ldB", byte];
    }
    
    else if (byte / 1024.0 < 1024) {
        size = [NSString stringWithFormat:@"%.2lfKB", byte / 1024.0];
    }
    
    else if (byte / 1048576.0 < 1024) {
        size = [NSString stringWithFormat:@"%.2lfM", byte / 1048576.0];
    }
    
    else if (byte / 1073741824.0 < 1024) {
        size = [NSString stringWithFormat:@"%.2lfG", byte / 1073741824.0];
    }
    
    if (size.integerValue < 0) {
        return @"0";
    }
    
    return size;
}

@end
