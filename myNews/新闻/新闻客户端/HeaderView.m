//
//  HeaderView.m
//  新闻客户端
//
//  Created by 李荣跃 on 16/8/23.
//  Copyright © 2016年 weikunchao. All rights reserved.
//

#import "HeaderView.h"
static NSString *ID=@"cell1";
@implementation HeaderView
-(void)awakeFromNib{
    //注册cell
    [self.collection registerNib:[UINib nibWithNibName:@"HeaderViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ID];
    self.collection.delegate=self;
    self.collection.dataSource=self;
     self.titles=@[@"新闻",@"国内",@"国际",@"社会",@"公益"];
    self.datas=[NSMutableArray array];
    [self passValueResultedInternet];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    self.cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [self.cell.label setText:self.titles[indexPath.row]];
    return self.cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    if (status==ReachableViaWiFi || status==ReachableViaWWAN) {
        NewsTableViewController *news=[NewsTableViewController sharedNewsTableViewController];
       MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:news.view animated:YES];
        hud.labelText=@"加载中...";
        [hud hide:YES afterDelay:1.5];
        [self requestDataWithId:(int)(indexPath.row+1)];//联网状态---保存数据
    }else if (status==NotReachable)//断网状态---本地加载
    {
        [MBProgressHUD showError:@"网络连接已断开"];
        [self localLoad];
    }
}
#pragma mark 默认初始加载新闻网页
-(void)passValueResultedInternet{
    //有网的情况才删,如果没有网就不删,不然会把之前数据都清空
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    if (status==ReachableViaWiFi || status==ReachableViaWWAN) {
#pragma mark 创建一个子线程来用于请求数据会显示The FMDatabase is currently in use,原因是FMDB是基于GCD的没有线性安全,只支持同步操作,不能异步进行
        [self requestDataWithId:1];//联网状态---保存数据
    }else if (status==NotReachable)//断网状态---本地加载
    {
        [self localLoad];
    }
    
}
#pragma mark 请求数据
-(void)requestDataWithId:(int)flid{
    [self.datas removeAllObjects];
    //获取数据库
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    FMDatabase *db=delegate.data;
    //每次网络请求,清空之前的数据---确保每次数据最新,并且不重复
        BOOL isDelete=[db executeUpdate:@"delete from news"];
        if (!isDelete) {
            NSLog(@"删除遗留数据失败");
        }
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://115.159.1.248:56666/xinwen/getnews.php?id=%d",flid]];
    NSData *data=[NSData dataWithContentsOfURL:url];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:@"http://115.159.1.248:56666/xinwen/getnews.php?id=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        for (NSDictionary *dic in array) {
            NewsModel *model=[NewsModel sharedNewsModel:dic];
#pragma mark 本地保存
            //图片转换成二进制数据---进行保存
            NSString *string=[NSString stringWithFormat:@"http://115.159.1.248:56666/xinwen/images/%@",model.picture];
            NSURL *url=[NSURL URLWithString:string];
            NSData *data=[NSData dataWithContentsOfURL:url];
            model.pic=[UIImage imageWithData:data];
            BOOL isInsert=[db executeUpdate:@"insert into news(idid,title,subtitle,picture,author,time,content,flid,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",model.idid,model.title,model.subtitle,model.picture,model.author,model.time,model.content,model.flid,model.clicks,model.pic];
            if (!isInsert) {
                NSLog(@"数据保存失败");
            }
            [self.datas addObject:model];
        }
        self.saveDatas=[NSMutableArray array];
        self.saveDatas=self.datas;
        //传值到控制器界面
        self.block(self.saveDatas);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark 本地加载-----如果都是用本地加载,初次运行时表为空,显示会无数据。需app完成后要试运行一次,将数据加载进来
-(void)localLoad{
    //每次加载本地最新数据---保持更新状态
    [self.datas removeAllObjects];
    //获取数据库
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    FMDatabase *db=delegate.data;
    FMResultSet *set=[db executeQuery:@"select * from news"];
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
        [self.datas addObject:model];
    }
}
@end
