//
//  ZYPinYinSearch.m
//  ZYPinYinSearch
//
//  Created by soufun on 15/7/27.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#import "ZYPinYinSearch.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "objc/runtime.h"
#import <UIKit/UIKit.h>
@implementation ZYPinYinSearch
+ (NSArray *)searchWithOriginalArray:(NSArray *)originalArray andSearchText:(NSString *)searchText andSearchByPropertyName:(NSString *)propertyName{
    
    NSMutableArray *dataSourceArray = [NSMutableArray array];
    NSString *type;
    
    if(originalArray.count <= 0) {
        // 如果数据源为空
        return originalArray;
    }
    
    //判断数据源是何种类型
    
    id object = originalArray[0];
    
    //字符串
    if ([object isKindOfClass:[NSString class]]) {
        type = @"string";
    }
    
    //字典
    else if ([object isKindOfClass:[NSDictionary class]]) {
        type = @"dict";
        NSDictionary *dict = originalArray[0];
        BOOL isExit = NO;
        for (NSString *key in dict.allKeys) {
            if([key isEqualToString:propertyName]){
                isExit = YES;
                break;
            }
        }
        
        if (!isExit) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"数据源中的字典没有你指定的key:%@",propertyName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return originalArray;
        }
    }
    
    //模型
    else {
        
        //这里遍历属性列表 查询是否有指定字段
        type = @"model";
        NSMutableArray *props = [NSMutableArray array];
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([object class], &outCount);
        
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            [props addObject:propertyName];
        }
        
        free(properties);
        
        BOOL isExit = NO;
        for (NSString * property in props) {
            if([property isEqualToString:propertyName]){
                isExit = YES;
                break;
            }
        }
        
        if (!isExit) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"数据源中的Model没有你指定的属性:%@",propertyName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return originalArray;
        }
    }
    
    
    
    
    if (searchText.length > 0 && ![ChineseInclude isIncludeChineseInString:searchText]) {
        
        //遍历数组所有成员
        for (int i = 0; i < originalArray.count; i++) {
            
            //因为指定的属性是 @"name"  所以个值就是数组里所有模型的名字
            NSString *tempString;
            
            if ([type isEqualToString:@"string"]) {
                tempString = originalArray[i];
            } else {
                tempString = [originalArray[i] valueForKey:propertyName];
            }
            
            //名字中是否包含汉字
            if ([ChineseInclude isIncludeChineseInString:tempString]) {
                
                //如果包含 先转化成拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:tempString];
                
                NSRange titleResult = [tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
                
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:tempString];
                
                NSRange titleHeadResult = [tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length > 0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
                
            }
            
            else {
                NSRange titleResult = [tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
                
            }
        }
    }
    
    else if (searchText.length > 0 && [ChineseInclude isIncludeChineseInString:searchText]) {
        for (id object in originalArray) {
            NSString * tempString;
            if ([type isEqualToString:@"string"]) {
                tempString = object;
            }
            else{
                tempString = [object valueForKey:propertyName];
            }
            NSRange titleResult = [tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [dataSourceArray addObject:object];
            }
        }
    }
    
    return dataSourceArray;
}

@end
