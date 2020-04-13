//
//  ZYRegularTestControllerViewController.m
//  ZYKit
//
//  Created by 张祎 on 2018/4/18.
//  Copyright © 2018年 objcat. All rights reserved.
//

#import "ZYRegularTestViewController.h"
#import "NSString+ZYExtension.h"

@interface ZYRegularTestViewController ()

@end

@implementation ZYRegularTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *text = @"123skdjfAKJJLDKJ你好..+--+-";
    
    if (text.zy_isMobile) {
        NSLog(@"是手机号");
    } else {
        NSLog(@"不是手机号");
    }
    
    
    
    
    
    
    
    
    
    
    
}

@end
