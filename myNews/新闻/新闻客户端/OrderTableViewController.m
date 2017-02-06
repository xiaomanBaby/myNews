//
//  OrderTableViewController.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/26.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "OrderTableViewController.h"
#import "OrderTableViewCell.h"
#import "OrderContentViewController.h"
@interface OrderTableViewController ()

@end
static NSString *OrderCell=@"cell";
@implementation OrderTableViewController
static id instance=nil;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self) {
        if (!instance) {
            instance=[super allocWithZone:zone];
        }
        return instance;
    }
    
}
+(instancetype)sharedOrderTableViewController{
    return [[self alloc]init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Orderdatas=[NSMutableArray array];
    self.saveDatas=[NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OrderCell];
   [self passValueResultedInternet];
    [self refresh];
}
#pragma mark 根据网络转台加载排行榜网页
-(void)passValueResultedInternet{
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    if (status==ReachableViaWiFi || status==ReachableViaWWAN) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"加载中...";
        [hud hide:YES afterDelay:2];
        [self requestData];//联网状态---保存数据
    }else if (status==NotReachable)//断网状态---本地加载
    {
        [MBProgressHUD showMessage:@"网络状况差"];
        [self localLoad];
    }
    
}
#pragma mark 请求数据
-(void)requestData{
    [self.Orderdatas removeAllObjects];
    //获取数据库
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    FMDatabase *db=delegate.orderData;
    //每次网络请求,清空之前的数据---确保每次数据最新,并且不重复
    BOOL isDelete=[db executeUpdate:@"delete from t_order"];
    if (!isDelete) {
        NSLog(@"删除遗留数据失败");
    }
    NSURL *url=[NSURL URLWithString:@"http://115.159.1.248:56666/xinwen/getorders.php"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:@"http://115.159.1.248:56666/xinwen/getorders.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        for (NSDictionary *dic in array) {
            NewsModel *model=[NewsModel sharedNewsModel:dic];
#pragma mark 本地保存
            //图片转换成二进制数据---进行保存
            NSString *string=[NSString stringWithFormat:@"http://115.159.1.248:56666/xinwen/images/%@",model.picture];
            NSURL *url=[NSURL URLWithString:string];
            NSData *data=[NSData dataWithContentsOfURL:url];
            model.pic=[UIImage imageWithData:data];
            BOOL isInsert=[db executeUpdate:@"insert into t_order(idid,title,subtitle,picture,author,time,content,flid,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",model.idid,model.title,model.subtitle,model.picture,model.author,model.time,model.content,model.flid,model.clicks,model.pic];
            if (!isInsert) {
                NSLog(@"数据保存失败");
            }
            [self.Orderdatas addObject:model];
        }
        self.saveDatas=self.Orderdatas;
        //及时刷新
        [self.tableView reloadData];
        NSLog(@"%ld",self.saveDatas.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark 本地加载
-(void)localLoad{
    //每次加载本地最新数据---保持更新状态
    [self.Orderdatas removeAllObjects];
    //获取数据库
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    FMDatabase *db=delegate.orderData;
    FMResultSet *set=[db executeQuery:@"select * from t_order"];
    while ([set next]) {
        NewsModel *model=[[NewsModel alloc]init];
        model.idid=[NSNumber numberWithInt:[set intForColumn:@"idid"]];
        model.title=[set stringForColumn:@"title"];
        model.subtitle=[set stringForColumn:@"subtitle"];
        model.picture=[set stringForColumn:@"picture"];
        model.author=[set stringForColumn:@"author"];
        model.time=[set stringForColumn:@"time"];
        model.content=[set stringForColumn:@"content"];
        model.flid=[NSNumber numberWithInt:[set intForColumn:@"flid"]];
        model.clicks=[NSNumber numberWithInt:[set intForColumn:@"clicks"]];
        NSData *data=[set dataForColumn:@"pic"];
        model.pic=[UIImage imageWithData:data];
        [self.Orderdatas addObject:model];
    }
    self.saveDatas=self.Orderdatas;
    //及时刷新
     [self.tableView reloadData];
}
#pragma mark 上下啦刷新---根据网络状况
-(void)refresh{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.Orderdatas removeAllObjects];
        [self.saveDatas removeAllObjects];
        [self passValueResultedInternet];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.Orderdatas removeAllObjects];
        [self.saveDatas removeAllObjects];
        [self passValueResultedInternet];
        [self.tableView.mj_footer endRefreshing];
           }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.saveDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model=self.saveDatas[indexPath.row];
    OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:OrderCell];
    cell.model=model;
    return cell;
}
#pragma mark 自定义右侧滑键
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *top=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //更改数据
        [self.saveDatas exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        //更改界面
        //获得目标first
        NSIndexPath *first=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:first];
    }];
    return @[top];
}
#pragma mark 跳转到内容页面---加传值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderContentViewController *content=[[OrderContentViewController alloc]init];
    NSIndexPath *indexpath=[self.tableView indexPathForSelectedRow];
    NewsModel *model=self.saveDatas[indexpath.row];
    content.receiveTitle=model.title;
    content.receiveTime=model.time;
    content.receiveAuthor=model.author;
    content.receiveContent=model.content;
    content.idid=model.idid;
    content.titles=[NSMutableArray array];
    content.titles=self.saveDatas;
    [self.navigationController pushViewController:content animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
