//
//  RowModel.h
//  ZYKit
//
//  Created by 张祎 on 17/1/17.
//  Copyright © 2017年 张祎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RowModel : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) SEL action;
@property (strong, nonatomic) Class classz;
@end
