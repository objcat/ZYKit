//
//  ZYTimePickerView.h
//  ZYAnimationView
//
//  Created by 张祎 on 2019/7/11.
//  Copyright © 2019 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYAnimationView.h"


@interface ZYTimePickerView : ZYAnimationView
@property (copy, nonatomic) void (^determinBlock) (NSString *);
+ (instancetype)timePickerWithCurrentTime:(NSString *)CurrentTime determinBlock:(void (^)(NSString * time))determinBlock;
@end

