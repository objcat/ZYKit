//
//  EHFormTableView.h
//  DABAN
//
//  Created by 张祎 on 2018/9/12.
//  Copyright © 2018年 objcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHFormModel.h"
#import "EHFormTableViewProtocol.h"

#define FWT(x) (EHFormModel *)x

@interface EHFormTableView : UITableView

/// 数据源
@property (strong, nonatomic, readonly) NSMutableArray *sourceArr;
/// 字典索引
@property (strong, nonatomic, readonly) NSMutableDictionary *indexDic;
/// 索引数组
@property (strong, nonatomic, readonly) NSMutableArray *indexArray;
/// 代理回调
@property (weak, nonatomic) id <EHFormTableViewProtocol> formDelegate;

@property (assign, nonatomic) BOOL removeKeyBoardObserver;

/**
 插入表单
 
 @param name 标题
 @param value 值
 @param type 类型(cell名称)
 @param useXib 是否使用Xib(区分注册方法)
 @param canTap 是否可点击(只负责tableView原生点击)
 @param canSelected 是否可选中
 @param rowHeight 行高
 @param separatorHeight 分割线高
 @param separatorColor 分割线颜色
 @param separatorOffset 分割线偏移量
 @param callBack 所有事件回调
 @return EHFormModel * (可用于增添一些参数中没有的变量)
 */
- (EHFormModel *)addRowWithName:(NSString *)name
                          value:(NSString *)value
                           type:(EHFormType)type
                         useXib:(BOOL)useXib
                         canTap:(BOOL)canTap
                    canSelected:(BOOL)canSelected
                      rowHeight:(CGFloat)rowHeight
                separatorHeight:(CGFloat)separatorHeight
                 separatorColor:(UIColor *)separatorColor
                separatorOffset:(CGFloat)separatorOffset
                       callBack:(void (^) (EHFormModel *model))callBack;

/**
 快速普通表单
 
 @param name 名称
 @param value 值
 @param dic 字典
 @param type 类型(cell名称)
 @param rowHeight 行高
 @param callBack 所有事件回调
 @return EHFormModel *
 */
- (EHFormModel *)addNormalRowWithName:(NSString *)name
                                value:(NSString *)value
                                 type:(EHFormType)type
                            rowHeight:(CGFloat)rowHeight
                             callBack:(void (^) (EHFormModel *model))callBack;

/**
 插入不能点击的表单
 
 @param name 名称
 @param value 值
 @param type 类型(cell名称)
 @param rowHeight 行高
 @param callBack 所有事件回调
 @return EHFormModel *
 */
- (EHFormModel *)addUnableTapRowWithName:(NSString *)name
                                   value:(NSString *)value
                                    type:(EHFormType)type
                               rowHeight:(CGFloat)rowHeight
                                callBack:(void (^)(EHFormModel *model))callBack;

/**
 插入空白行
 
 @param backgroundColor 分隔行颜色
 @param rowHeight 行高
 @param separatorHeight 下划线高度
 @param separatorColor 下划线颜色
 @param separatorOffset 下划线偏移量
 */
- (EHFormModel *)addWhiteRowWithBackgroundColor:(UIColor *)backgroundColor
                                      rowHeight:(CGFloat)rowHeight
                                separatorHeight:(CGFloat)separatorHeight
                                 separatorColor:(UIColor *)separatorColor
                                separatorOffset:(CGFloat)separatorOffset;

/**
 根据标题获取模型
 
 @param title 标题(name)
 @return EHFormModel *
 */
- (EHFormModel *)modelWithTitle:(NSString *)title;

/**
 根据索引获取标题
 
 @param index 索引位置
 @return EHFormModel *
 */
- (EHFormModel *)modelWithIndex:(NSInteger)index;


/**
 设置键盘弹出和键盘收起的tableView高度参考
 此方法是解决键盘弹出时遮挡表单的问题
 
 @param upHeight 键盘弹出tableView高度参考
 @param downHeight 键盘收起tableView高度参考
 */
- (void)setUpHeight:(CGFloat)upHeight downHeight:(CGFloat)downHeight;


/// 根据标题删除行
/// @param title 标题(name)
/// @param reloadData 是否刷新
- (void)removeRowWithTitle:(NSString *)title reloadData:(BOOL)reloadData;


/// 根据index删除(索引数组中)的行
/// @param index 索引
/// @param reloadData 是否刷新
- (void)removeRowWithIndexFromIndexArray:(NSInteger)index reloadData:(BOOL)reloadData;


/// 根据index删除(数据源中)的行 -> 区别是索引数组中不包含空白行 所以删除空白行需要在数据源中进行删除
/// @param index 索引
/// @param reloadData 是否刷新
- (void)removeRowWithIndexFromSourceArray:(NSInteger)index reloadData:(BOOL)reloadData;

/// 导出提交字典
- (NSMutableDictionary *)dumpSubmitDictionary;

/// 检测空值
- (BOOL)checkEmpty;

/// 检测空值(修改检测: 与上面不同的是 没改动过的字段不被认为是空值)
- (BOOL)checkAlterEmpty;

@end
