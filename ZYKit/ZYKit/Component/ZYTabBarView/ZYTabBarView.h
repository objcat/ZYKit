//
//  ZYTabBarView.h
//  二级页面tabbar测试
//
//  Created by 张祎 on 2019/7/8.
//  Copyright © 2019 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYTabBarView : UIView
- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr superVC:(UIViewController *)superVC;
@property (copy, nonatomic) void (^didSelected) (NSInteger index);
@end

NS_ASSUME_NONNULL_END
