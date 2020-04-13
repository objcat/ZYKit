//
//  ZYAnimationView.m
//  ZYAnimationView
//
//  Created by 张祎 on 2019/7/11.
//  Copyright © 2019 张祎. All rights reserved.
//

#import "ZYAnimationView.h"

@interface ZYAnimationView ()
@property (strong, nonatomic) UIControl *blockView;
@end

@implementation ZYAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addBlockView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addBlockView];
}

- (void)addBlockView {
    self.blockView = [[UIControl alloc] init];
    self.blockView.backgroundColor = [UIColor blackColor];
    self.blockView.frame = [UIScreen mainScreen].bounds;
    self.blockView.alpha = 0;
    [self.blockView addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInside {
    [self hidden];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.blockView];
    [window addSubview:self];
    self.blockView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
        self.blockView.alpha = 0.8;
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
        self.blockView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.blockView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

//判断是否在滚动
- (BOOL)anySubViewScrolling:(UIView *)view {
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    
    for (UIView *subView in view.subviews) {
        if ([self anySubViewScrolling:subView]) {
            return YES;
        }
    }
    
    return NO;
}

@end
