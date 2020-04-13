//
//  ZYDatePickerView.h
//  EGShellProject
//
//  Created by 张祎 on 2019/7/16.
//  Copyright © 2019 objcat. All rights reserved.
//

#import "ZYAnimationView.h"

@interface ZYDatePickerView : ZYAnimationView
@property (copy, nonatomic) void (^determinBlock) (NSDate *);
+ (instancetype)datePickerWithCurrentDate:(NSDate *)date determinBlock:(void (^)(NSDate * date))determinBlock;
@end
