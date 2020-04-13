//
//  ZYAnimationView.h
//  ZYAnimationView
//
//  Created by 张祎 on 2019/7/11.
//  Copyright © 2019 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZYAnimationView : UIView
- (void)show;
- (void)hidden;
- (BOOL)anySubViewScrolling:(UIView *)view;
@end

