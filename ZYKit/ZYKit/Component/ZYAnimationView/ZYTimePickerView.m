//
//  ZYTimePickerView.m
//  ZYAnimationView
//
//  Created by 张祎 on 2019/7/11.
//  Copyright © 2019 张祎. All rights reserved.
//

#import "ZYTimePickerView.h"

@interface ZYTimePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *arr;
@end

@implementation ZYTimePickerView

+ (instancetype)timePickerWithCurrentTime:(NSString *)CurrentTime determinBlock:(void (^)(NSString * ))determinBlock {
    ZYTimePickerView *pickerView = [[NSBundle mainBundle] loadNibNamed:@"ZYTimePickerView" owner:nil options:nil][0];
    pickerView.pickerView.delegate = pickerView;
    pickerView.pickerView.dataSource = pickerView;
    [pickerView buildData];
    pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240);
    [pickerView setDeterminBlock:^(NSString *time) {
            determinBlock ? determinBlock(time) : nil;
    }];
    [pickerView changeTime:CurrentTime];
    [pickerView show];
    return pickerView;
}

- (void)changeTime:(NSString *)time {
    NSArray *array = [time componentsSeparatedByString:@":"];
    if (array.count == 2) {
        NSString *hour = array[0];
        NSString *second = array[1];
        [self.pickerView selectRow:hour.integerValue inComponent:0 animated:YES];
        [self.pickerView selectRow:second.integerValue inComponent:1 animated:YES];
    } else {
        [self.pickerView selectRow:9 inComponent:0 animated:YES];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
}

- (IBAction)cancel:(id)sender {
    [self hidden];
}

- (IBAction)determin:(id)sender {
    if ([self anySubViewScrolling:self.pickerView]) {
        return;
    }
    NSInteger hourSelectedIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger secondSelectedIndex = [self.pickerView selectedRowInComponent:1];
    NSNumber *hour = self.arr[0][hourSelectedIndex];
    NSNumber *second = self.arr[1][secondSelectedIndex];
    self.determinBlock([NSString stringWithFormat:@"%02ld:%02ld", hour.integerValue, second.integerValue]);
    [self hidden];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)buildData {
    
    NSMutableArray *hourArr = [NSMutableArray array];
    NSMutableArray *secondArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i <= 23; i ++) {
        [hourArr addObject:@(i)];
    }
    
    for (NSInteger i = 0; i <= 59; i++) {
        [secondArr addObject:@(i)];
    }
    
    self.arr = [NSMutableArray array];
    [self.arr addObject:hourArr];
    [self.arr addObject:secondArr];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.arr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *arr = self.arr[component];
    return arr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    
    if (component == 0) {
        NSNumber *hourNum = self.arr[component][row];
        NSInteger hour = hourNum.integerValue;
        label.text = [NSString stringWithFormat:@"%02ld时", hour];
    } else {
        NSNumber *secondNum = self.arr[component][row];
        NSInteger second = secondNum.integerValue;
        label.text = [NSString stringWithFormat:@"%02ld分", second];
    }
    
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:121 / 255.0 green:124 / 255.0 blue:125 / 255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

// 这里返回的是component的宽度,即每列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

@end
