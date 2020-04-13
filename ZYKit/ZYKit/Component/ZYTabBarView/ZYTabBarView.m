//
//  ZYTabBarView.m
//  二级页面tabbar测试
//
//  Created by 张祎 on 2019/7/8.
//  Copyright © 2019 张祎. All rights reserved.
//

#import "ZYTabBarView.h"
#import "ZYTabBarItem.h"
#import "UIViewController+ZYChildViewControllerExtension.h"

@interface ZYTabBarView ()
@property (strong, nonatomic) CALayer *lineLayer;
@property (strong, nonatomic) NSMutableArray *subItems;
@property (weak, nonatomic) UIViewController *superVC;
@end

@implementation ZYTabBarView

- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr superVC:(UIViewController *)superVC {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.superVC = superVC;
        self.subItems = [NSMutableArray array];
        NSInteger count = arr.count;
        int i = 0;
        for (NSDictionary *dic in arr) {
            // 添加tabBarItem
            ZYTabBarItem *item = [ZYTabBarItem tabBarWithFrame:CGRectMake(i * ([UIScreen mainScreen].bounds.size.width / count), 0, [UIScreen mainScreen].bounds.size.width / count, 49) image:[UIImage imageNamed:dic[@"image"]] selectedImage:[UIImage imageNamed:dic[@"selectedImage"]] title:dic[@"title"]];
            // 设置tag
            item.tag = i;
            
            // 设置选中
            if (item.tag == 0) {
                item.selected = YES;
            } else {
                item.selected = NO;
            }
            
            // 添加底部tabbaritem
            [self addSubview:item];
            [self.subItems addObject:item];
            
            [item addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            
            // 添加子控制器
            Class classz = NSClassFromString(dic[@"vc"]);
            UIViewController *vc = [[classz alloc] init];
            [self.superVC addChildViewController:vc];
            if (item.tag == 0) {
                [self.superVC.view addSubview:vc.view];
            }
            
            i++;
        }
        [self addLineLayer];
    }
    return self;
}

- (void)addLineLayer {
    self.lineLayer = [[CALayer alloc] init];
    self.lineLayer.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:230 / 255.0 blue:229 / 255.0 alpha:1].CGColor;
    [self.layer addSublayer:self.lineLayer];
}

- (void)click:(UIControl *)control {
    for (ZYTabBarItem *item in self.subItems) {
        item.selected = NO;
    }
    control.selected = YES;
    [self.superVC zy_transitionFromViewControllerWithIndex:control.tag];
    self.didSelected ? self.didSelected(control.tag) : nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineLayer.frame = CGRectMake(0, 0, self.frame.size.width, 1);
}

@end
