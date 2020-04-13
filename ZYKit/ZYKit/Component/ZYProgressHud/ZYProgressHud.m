//
//  ZYProgressHud.m
//  EGShellProject
//
//  Created by 张祎 on 2019/6/18.
//  Copyright © 2019 objcat. All rights reserved.
//

#import "ZYProgressHud.h"
#import "ZYProgressContentView.h"

@interface ZYProgressHud ()
@property (strong, nonatomic) ZYProgressContentView *contentView;
@end

@implementation ZYProgressHud

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:@"ZYProgressContentView" owner:nil options:nil][0];
        [self addSubview:self.contentView];
    }
    return self;
}

+ (void)showInView:(UIView *)view {
    ZYProgressHud *hud = [[ZYProgressHud alloc] init];
    hud.frame = view.bounds;
    hud.tag = 12365;
    [view addSubview:hud];
}


+ (void)dismissInView:(UIView *)view {
    [[view viewWithTag:12365] removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}


@end
