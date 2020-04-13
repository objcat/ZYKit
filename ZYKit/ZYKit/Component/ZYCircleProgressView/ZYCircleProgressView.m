//
//  ZYCircleProgressView.m
//  圆形进度条
//
//  Created by 张祎 on 2019/7/11.
//  Copyright © 2019 张祎. All rights reserved.
//

#import "ZYCircleProgressView.h"
#import "UIColor+Extension.h"

@interface ZYCircleProgressView ()
@property (strong, nonatomic) CAShapeLayer *outLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIImageView *gradientImageView;
@end

@implementation ZYCircleProgressView

- (void)drawProgress {
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width - 5) / 2 startAngle:-M_PI_2 endAngle:M_PI * 3.0 / 2.0 clockwise:YES];
    self.outLayer = [CAShapeLayer layer];
    self.outLayer.strokeColor = self.trackTintColor.CGColor ? : [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1].CGColor;
    self.outLayer.lineWidth = self.lineWidth ? : 5;
    self.outLayer.fillColor = [UIColor clearColor].CGColor;
    self.outLayer.path = circlePath.CGPath;
    [self.layer addSublayer:self.outLayer];
    
    self.progressLayer = [CAShapeLayer layer];
//    self.progressLayer.strokeColor = self.progressTintColor.CGColor ? : [UIColor colorWithRed:0 / 255.0 green:108 / 255.0 blue:255 / 255.0 alpha:1].CGColor;
    self.progressLayer.strokeColor = [UIColor clearColor].CGColor;
    self.progressLayer.lineWidth = self.lineWidth ? : 5;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.path = circlePath.CGPath;
    [self.layer addSublayer:self.progressLayer];
    
//
//    self.gradientImageView = [[UIImageView alloc] init];
//    self.gradientImageView.image = [UIImage imageNamed:@"ritongji_jianbian"];
//    self.gradientImageView.frame = self.bounds;
//    [self addSubview:self.gradientImageView];
//    self.gradientImageView.layer.mask = self.progressLayer;
//
    
    if (self.type == ZYCircleProgressViewTypeGradual) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        self.gradientLayer.startPoint = CGPointMake(0.68, 0.4);
        self.gradientLayer.endPoint = CGPointMake(0.12, 0);
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:108 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:0 / 255.0 green:192 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor];
        self.gradientLayer.locations = @[@(0), @(1.0f)];
        [self.layer addSublayer:self.gradientLayer];
        self.gradientLayer.mask = self.progressLayer;
    }
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    self.progressLayer.strokeEnd =  progress;
    self.progressLayer.strokeColor = [UIColor colorWithProgress:progress * 100].CGColor;
    [CATransaction commit];
}

- (void)setProgress:(CGFloat)progress duration:(NSTimeInterval)duration {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:duration];
    self.progressLayer.strokeEnd =  progress;
    [CATransaction commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawProgress];
}



@end
