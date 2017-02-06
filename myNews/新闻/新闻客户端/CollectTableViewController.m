//
//  CollectTableViewController.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "CollectTableViewController.h"
#import "CollectContentViewController.h"
static NSString *ID=@"cell";
@interface CollectTableViewController ()

@end

@implementation CollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveData=[NSMutableArray array];
    self.datas=[NSMutableArray array];
    [self getData];
    [self refresh];
}
#pragma mark 取数据
-(void)getData{
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    FMDatabase *db=delegate.collectData;
    FMResultSet *set=[db executeQuery:@"select * from t_collect"];
    while ([set next]) {
        NewsModel *model=[[NewsModel alloc]init];
        model.title=[set stringForColumn:@"title"];
        model.time=[set stringForColumn:@"time"];
        model.author=[set stringForColumn:@"author"];
        model.content=[set stringForColumn:@"content"];
        [self.saveData addObject:model];
    }
    self.datas=self.saveData;
    [self.tableView reloadData];
}
#pragma mark 上下拉刷新
-(void)refresh{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //清空原数据
        [self.saveData removeAllObjects];
        [self.datas removeAllObjects];
        [self getData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //清空原数据
        [self.saveData removeAllObjects];
        [self.datas removeAllObjects];
        [self getData];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 清空收藏
- (IBAction)clean:(id)sender {
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    FMDatabase *db=delegate.collectData;
    BOOL isDelete=[db executeUpdate:@"delete from t_collect"];
    if (isDelete) {
        [MBProgressHUD showSuccess:@"清楚成功!"];
    }
    [self.datas removeAllObjects];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model=self.datas[indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text=model.title;
    return cell;
}
#pragma mark 自定义右侧滑键
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *delete=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    UITableViewRowAction *top=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
         top.backgroundColor=[UIColor greenColor];
        //更新数据
        [self.datas exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        //更新UI
        NSIndexPath *first=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:first];
       
    }];
    return @[delete,top];
}
#pragma mark 跳转到内容页面---加传值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectContentViewController *content=[[CollectContentViewController alloc]init];
    NSIndexPath *indexpath=[self.tableView indexPathForSelectedRow];
    NewsModel *model=self.datas[indexpath.row];
    content.receiveTitle=model.title;
    content.receiveTime=model.time;
    content.receiveAuthor=model.author;
    content.receiveContent=model.content;
    content.titles=[NSMutableArray array];
    content.titles=self.datas;
    [self.navigationController pushViewController:content animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
