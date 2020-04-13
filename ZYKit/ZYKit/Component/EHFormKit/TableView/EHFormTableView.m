//
//  EHFormTableView.m
//  DABAN
//
//  Created by 张祎 on 2018/9/12.
//  Copyright © 2018年 objcat. All rights reserved.
//

#import "EHFormTableView.h"
#import "EHFormTableViewCell.h"
#import "EHWhiteRowTableViewCell.h"
#import "EHButtonTableViewCell.h"
#import "EHSwitchTableViewCell.h"
#import "UIView+ZYView.h"

@interface EHFormTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
/** 数据源 */
@property (strong, nonatomic) NSMutableArray *sourceArr;
/** 字典索引 */
@property (strong, nonatomic) NSMutableDictionary *indexDic;

/** 线的颜色 */
@property (strong, nonatomic) UIColor *sColor;
/** 线的偏移量 */
@property (assign, nonatomic) CGFloat sOffset;

/** 键盘弹出tableView高度参考 */
@property (assign, nonatomic) CGFloat upHeight;
/** 键盘收起tableView高度参考 */
@property (assign, nonatomic) CGFloat downHeight;

/** 处于编辑的行 */
@property (assign, nonatomic) NSInteger editRow;

@end

@implementation EHFormTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.sColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
        self.sOffset = 15;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        //使用NSNotificationCenter 键盘隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShown:(NSNotification *)notification {
    if (self.removeKeyBoardObserver) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"%@", NSStringFromCGSize(keyboardSize));
    [UIView animateWithDuration:duration animations:^{
        self.height = self.upHeight - keyboardSize.height;
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.editRow inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    if (self.removeKeyBoardObserver) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.height = self.downHeight;
    }];
}

- (EHFormModel *)modelWithIndex:(NSInteger)index {
    return self.indexArray[index];
}

- (EHFormModel *)modelWithTitle:(NSString *)title {
    return self.indexDic[title];
}

- (UIViewController *)getSuperViewController:(UIView *)view {
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

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
                       callBack:(void (^) (EHFormModel *model))callBack {
    
    
    @try {
        if ([name isEqualToString:@""] || name == nil || ![name isKindOfClass:[NSString class]]) {
            NSException *exception = [NSException exceptionWithName:@"EHFormKit - name字段必须有值并且必须为字符串" reason:[NSString stringWithFormat:@"错误位置:%@", [self getSuperViewController:self]] userInfo:nil];
            [exception raise];
        }
    } @catch (NSException *exception) {
        [exception raise];
    }
    
    EHFormModel *model = [[EHFormModel alloc] init];
    model.name = name;
    model.value = value ? : @"";
    model.type = type;
    model.useXib = useXib;
    model.canSelected = canSelected;
    model.canTap = canTap;
    model.callBack = callBack;
    model.rowHeight = rowHeight;
    model.separatorHeight = separatorHeight;
    model.separatorColor = separatorColor;
    model.separatorOffset = separatorOffset;
    model.userInteractionEnabled = YES;
    
    [self.sourceArr addObject:model];
    
    @try {
        if (self.indexDic[name]) {
            NSException *exception = [NSException exceptionWithName:@"EHFormKit - name字段不能重复" reason:[NSString stringWithFormat:@"错误位置:%@ 字段:%@", [self getSuperViewController:self], name] userInfo:nil];
            [exception raise];
        } else {
            [self.indexDic setObject:model forKey:name];
        }
    }
    
    @catch(NSException *exception) {
        [exception raise];
    }
    
    return model;
}

- (EHFormModel *)addNormalRowWithName:(NSString *)name
                              value:(NSString *)value
                               type:(EHFormType)type
                          rowHeight:(CGFloat)rowHeight
                           callBack:(void (^)(EHFormModel *model))callBack {
    return [self addRowWithName:name value:value type:type useXib:YES canTap:YES canSelected:YES rowHeight:rowHeight separatorHeight:0.5 separatorColor:self.sColor separatorOffset:self.sOffset callBack:callBack];
}

- (EHFormModel *)addUnableTapRowWithName:(NSString *)name
                                value:(NSString *)value
                                 type:(EHFormType)type
                            rowHeight:(CGFloat)rowHeight
                             callBack:(void (^)(EHFormModel *model))callBack {
    return [self addRowWithName:name value:value type:type useXib:YES canTap:NO canSelected:NO rowHeight:rowHeight separatorHeight:0.5 separatorColor:self.sColor separatorOffset:self.sOffset callBack:callBack];
}

- (EHFormModel *)addWhiteRowWithBackgroundColor:(UIColor *)backgroundColor
                                      rowHeight:(CGFloat)rowHeight
                                separatorHeight:(CGFloat)separatorHeight
                                 separatorColor:(UIColor *)separatorColor
                                separatorOffset:(CGFloat)separatorOffset {
    
    EHFormModel *whiteRow = [[EHFormModel alloc] init];
    whiteRow.rowHeight = rowHeight;
    whiteRow.type = EHWhiteRowTableViewCellType;
    whiteRow.separatorHeight = separatorHeight;
    whiteRow.separatorColor = separatorColor;
    whiteRow.separatorOffset = separatorOffset;
    whiteRow.backgroundColor = backgroundColor;
    [self.sourceArr addObject:whiteRow];
    return whiteRow;
}

- (NSMutableArray *)sourceArr {
    if (!_sourceArr) {
        _sourceArr = [NSMutableArray array];
    }
    return _sourceArr;
}

- (NSMutableArray *)indexArray {
    NSMutableArray *arr = [NSMutableArray array];
    for (EHFormModel *model in self.sourceArr) {
        if (model.type != EHWhiteRowTableViewCellType) {
            [arr addObject:model];
        }
    }
    return arr;
}

- (NSMutableDictionary *)indexDic {
    if (!_indexDic) {
        _indexDic = [NSMutableDictionary dictionary];
    }
    return _indexDic;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHFormModel *model = self.sourceArr[indexPath.row];
    
    if (model.useXib) {
        [self registerNib:[UINib nibWithNibName:model.type bundle:nil] forCellReuseIdentifier:model.type];
    } else {
        [self registerClass:NSClassFromString(model.type) forCellReuseIdentifier:model.type];
    }
    
    __weak typeof(self) weakSelf = self;
    EHFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.type];
    cell.model = model;
    cell.callBack = model.callBack;
    cell.beginEditingBlock = ^(EHFormModel *formModel){
        weakSelf.editRow = [weakSelf.sourceArr indexOfObject:formModel];
    };
    if (model.canSelected) cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    else cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.userInteractionEnabled = model.userInteractionEnabled;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHFormModel *model = self.sourceArr[indexPath.row];
    return model.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EHFormModel *model = self.sourceArr[indexPath.row];
    if (model.callBack && model.canTap) {
        model.callBack(model);
    }
    [self endEditing:YES];
}

- (void)setUpHeight:(CGFloat)upHeight downHeight:(CGFloat)downHeight {
    self.upHeight = upHeight;
    self.downHeight = downHeight;
}

- (void)setUpHeight:(CGFloat)upHeight {
    if (_upHeight == 0) {
        _upHeight = upHeight;
    }
}

- (void)setDownHeight:(CGFloat)downHeight {
    if (_downHeight == 0) {
        _downHeight = downHeight;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // X 414 896
    UIViewController *vc = [self viewController];
    CGFloat bottomHeight = 0;
    if (@available(iOS 11.0, *)) {
        bottomHeight = vc.view.safeAreaInsets.bottom;
    }
    self.upHeight = self.frame.size.height + bottomHeight;
    self.downHeight = self.frame.size.height;
    NSLog(@"aaaaa ----  %lf", self.frame.size.height);
}

- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.formDelegate && [self.formDelegate respondsToSelector:@selector(eh_scrollViewDidScroll:)]) {
        [self.formDelegate eh_scrollViewDidScroll:scrollView];
    }
}

- (void)removeRowWithTitle:(NSString *)title reloadData:(BOOL)reloadData {
    EHFormModel *model = self.indexDic[title];
    NSInteger index = [self.sourceArr indexOfObject:model];
    [self.indexDic removeObjectForKey:title];
    [self.sourceArr removeObject:model];
    [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:0];
}

- (void)removeRowWithIndexFromIndexArray:(NSInteger)index reloadData:(BOOL)reloadData {
    EHFormModel *model = self.indexArray[index];
    NSInteger realIndex = [self.sourceArr indexOfObject:model];
    [self.indexDic removeObjectForKey:model.name ? : @""];
    [self.sourceArr removeObject:model];
    [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:realIndex inSection:0]] withRowAnimation:0];
}

- (void)removeRowWithIndexFromSourceArray:(NSInteger)index reloadData:(BOOL)reloadData {
    EHFormModel *model = self.sourceArr[index];
    [self.indexDic removeObjectForKey:model.name ? : @""];
    [self.sourceArr removeObject:model];
    [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:0];
}

- (void)dealloc {
    NSLog(@"表单释放");
}

- (NSMutableDictionary *)dumpSubmitDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (EHFormModel *model in self.indexArray) {
        if (model.submitName && ![model.submitName isEqualToString:@""]) {
            dic[model.submitName] = model.submitValue ? : @"";
        }
    }
    return dic;
}

- (BOOL)checkEmpty {
    BOOL pass = YES;
    for (EHFormModel *model in self.indexArray) {
        if (!model.submitValue || [model.submitValue isEqualToString:@""]) {
//            [[UIApplication sharedApplication].keyWindow makeToast:[NSString stringWithFormat:@"%@不能为空", model.name]];
            pass = NO;
            return pass;
        }
    }
    return pass;
}

- (BOOL)checkAlterEmpty {
    BOOL pass = YES;
    for (EHFormModel *model in self.indexArray) {
        if (!model.submitValue || [model.submitValue isEqualToString:@""]) {
            if (model.isChanged) {
//                [[UIApplication sharedApplication].keyWindow makeToast:[NSString stringWithFormat:@"%@不能为空", model.name]];
                pass = NO;
            }
            return pass;
        }
    }
    return pass;
}



@end
