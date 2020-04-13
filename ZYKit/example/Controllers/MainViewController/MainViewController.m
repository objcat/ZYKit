//
//  MainViewController.m
//  ZYKit
//
//  Created by 张祎 on 16/4/26.
//  Copyright © 2016年 张祎. All rights reserved.
//

#import "MainViewController.h"
#import "ZYRegularTestViewController.h"
#import "ZYCaptureSessionViewController.h"
#import "ZYKit.h"
#import "RowModel.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation MainViewController

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"example";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //创建数据源
    [self buildData];
}

- (void)buildData {
    [self addRowWithTitle:@"扫描二维码" class:ZYCaptureSessionViewController.class];
    [self addRowWithTitle:@"正则表达式" class:ZYRegularTestViewController.class];
}

- (void)regular {
    ZYRegularTestViewController *regular = [[ZYRegularTestViewController alloc] init];
    [self.navigationController pushViewController:regular animated:YES];
}

- (void)addRowWithTitle:(NSString *)title class:(Class)classz {
    RowModel *model = [[RowModel alloc]init];
    model.title = title;
    model.classz = classz;
    [self.array addObject:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RowModel *model = self.array[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"example"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"example"];
    }
    
    cell.textLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RowModel *model = self.array[indexPath.row];
    UIViewController *vc = [[model.classz alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
