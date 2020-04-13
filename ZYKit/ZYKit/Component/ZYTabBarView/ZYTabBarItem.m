//
//  ZYTabBarItem.m
//  二级页面tabbar测试
//
//  Created by 张祎 on 2019/7/8.
//  Copyright © 2019 张祎. All rights reserved.
//

#import "ZYTabBarItem.h"
#import "UIColor+Extension.h"

@interface ZYTabBarItem ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ZYTabBarItem

+ (instancetype)tabBarWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    ZYTabBarItem *item = [[NSBundle mainBundle] loadNibNamed:@"ZYTabBarItem" owner:nil options:nil][0];
    item.frame = frame;
    item.image = image;
    item.selectedImage = selectedImage;
    item.titleLabel.text = title;
    return item;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageView.image = self.selectedImage;
        self.titleLabel.textColor = [UIColor mainColor];
    } else {
        self.imageView.image = self.image;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    }
}
@end
