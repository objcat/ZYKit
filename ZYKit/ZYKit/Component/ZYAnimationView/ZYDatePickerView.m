//
//  ZYDatePickerView.m
//  EGShellProject
//
//  Created by 张祎 on 2019/7/16.
//  Copyright © 2019 objcat. All rights reserved.
//

#import "ZYDatePickerView.h"

@interface ZYDatePickerView ()
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@end

@implementation ZYDatePickerView

+ (instancetype)datePickerWithCurrentDate:(NSDate *)date determinBlock:(void (^)(NSDate * date))determinBlock {
    ZYDatePickerView *pickerView = [[NSBundle mainBundle] loadNibNamed:@"ZYDatePickerView" owner:nil options:nil][0];
    pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240);
    [pickerView setDeterminBlock:^(NSDate *date) {
        determinBlock ? determinBlock(date) : nil;
    }];
    [pickerView changeDate:date];
    [pickerView show];
    return pickerView;
}

- (void)changeDate:(NSDate *)date {
    self.pickerView.date = date;
}

- (IBAction)cancel:(id)sender {
    [self hidden];
}

- (IBAction)determin:(id)sender {
    if ([self anySubViewScrolling:self.pickerView]) {
        return;
    }
    self.determinBlock ? self.determinBlock(self.pickerView.date) : nil;
    [self hidden];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pickerView.datePickerMode = UIDatePickerModeDate;
    [self.pickerView setValue:[UIColor grayColor] forKey:@"textColor"];
}

@end
