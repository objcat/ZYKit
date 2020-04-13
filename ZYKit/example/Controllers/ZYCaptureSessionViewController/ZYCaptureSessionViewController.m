//
//  ZYCaptureSessionViewController.m
//  ZYKit
//
//  Created by 张祎 on 16/5/4.
//  Copyright © 2016年 张祎. All rights reserved.
//

#import "ZYCaptureSessionViewController.h"
#import "ZYCaptureSessionView.h"

@interface ZYCaptureSessionViewController () <UIAlertViewDelegate>
@property(nonatomic, strong) ZYCaptureSessionView *sessionView;
@end

@implementation ZYCaptureSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat span = 100;
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect rect = CGRectMake((screenWidth - (screenWidth - span)) / 2, (screenHeight - (screenWidth - span)) / 2, screenWidth - span, screenWidth - span);
    
    self.sessionView = [ZYCaptureSessionView sessionWithRect:rect];
    
    [self.view addSubview:self.sessionView];
    
    __weak typeof(self) weakSelf = self;
    
    //扫描完成回调
    [self.sessionView setScanFinishBlock:^(NSString *str) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.sessionView.session startRunning];
    }
}

@end
