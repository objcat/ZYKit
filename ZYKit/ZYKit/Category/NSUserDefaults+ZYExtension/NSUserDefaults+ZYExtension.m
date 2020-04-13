//
//  NSUserDefaults+ZYExtension.m
//  ZYKit
//
//  Created by 张祎 on 2018/9/21.
//  Copyright © 2018年 objcat. All rights reserved.
//

#import "NSUserDefaults+ZYExtension.h"

@implementation NSUserDefaults (ZYExtension)
- (void)clean {
    NSUserDefaults *ud = self;
    NSDictionary *dic = [ud dictionaryRepresentation];
    for (id key in dic) {
        [ud removeObjectForKey:key];
    }
    [ud synchronize];
}
@end
