//
//  EHFormlModel.m
//  ExpandHouseProject
//
//  Created by 张祎 on 2018/1/11.
//  Copyright © 2018年 张祎. All rights reserved.
//

#import "EHFormModel.h"

EHFormType const EHTapTableViewCellType = @"EHTapTableViewCell";
EHFormType const EHButtonTableViewCellType = @"EHButtonTableViewCell";
EHFormType const EHPhoneNumberTableViewCellType = @"EHPhoneNumberTableViewCell";
EHFormType const EHLabelTableViewCellType = @"EHLabelTableViewCell";
EHFormType const EHSwitchTableViewCellType = @"EHSwitchTableViewCell";
EHFormType const EHWhiteRowTableViewCellType = @"EHWhiteRowTableViewCell";

@interface EHFormModel ()
/** dic容器 储存更多的数据 */
@property (nonatomic, strong) NSMutableDictionary *ext;
@end

@implementation EHFormModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ext = [NSMutableDictionary dictionary];
        self.submitValue = @"";
    }
    return self;
}

+ (EHFormModel *)converEHFormModel:(id)object {
    return (EHFormModel *)object;
}

- (void)eh_attributed:(void (^)(EHFormModel *))attributed {
    attributed(self);
}

@end
