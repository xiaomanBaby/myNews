//
//  NewsTableViewController.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/23.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "NewsTableViewController.h"
#import "HeaderView.h"
#import "NewsTableViewCell.h"
#import "ContentViewController.h"
@interface NewsTableViewController ()<UMSocialUIDelegate>
@end
 static NSString *newsCell=@"Cell";

@implementation NewsTableViewController
#pragma mark 单例
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static id instance=nil;
    if (instance==nil) {
        instance=[super allocWithZone:zone];
    }
    return instance;
}
+(instancetype)sharedNewsTableViewController{
    return [[self alloc]init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //生成可变数组
    self.receiveLocalDatas=[NSMutableArray array];
    self.pushTitles=[NSMutableArray array];
    [self setHeader];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:newsCell];
    [self refresh];
}

#pragma mark titleview是可以任意定制的
/**
 *   UISearchBar *search=[[UISearchBar alloc]init];
    self.navigationItem.titleView=search;
 */
#pragma mark 设置滑动头
-(void)setHeader{
    HeaderView *header=[[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:nil options:nil]lastObject];
    self.navigationItem.titleView=header;
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    if (status==ReachableViaWiFi || status==ReachableViaWWAN) {
        //未加载上前提示正在加载中
      MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"加载中...";
        [hud hide:YES afterDelay:3];
        header.block=^(NSMutableArray *array){
            self.receiveLocalDatas=array;
            [self.tableView reloadData];
        };
    }else if (status==NotReachable){
        self.receiveLocalDatas=header.datas;
    }
}
#pragma mark 上下拉刷新
-(void)refresh{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.receiveLocalDatas removeAllObjects];
        [self setHeader];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.receiveLocalDatas removeAllObjects];
        [self setHeader];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark 跳转到内容页面---加传值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentViewController *content=[[ContentViewController alloc]init];
    NSIndexPath *indexpath=[self.tableView indexPathForSelectedRow];
    NewsModel *model=self.receiveLocalDatas[indexpath.row];
    content.model=[[NewsModel alloc]init];
    content.model=model;
    content.titles=[NSMutableArray array];
    content.titles=self.receiveLocalDatas;
    [self.navigationController pushViewController:content animated:YES];
}
#pragma mark 设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receiveLocalDatas.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 NewsModel *model=self.receiveLocalDatas[indexPath.row];
    NewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:newsCell forIndexPath:indexPath];
  cell.model=model;
    [cell.buttonSina addTarget:self action:@selector(goSina) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonWechat addTarget:self action:@selector(goWechat) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonShare addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#pragma mark 自定义右侧滑键
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *top=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //更改数据
        [self.receiveLocalDatas exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        //更改界面
          //获得目标first
        NSIndexPath *first=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:first];
    }];
    return @[top];
}
#pragma mark 分享到新浪微博
-(void)goSina{
    SLComposeViewController *sl=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    [self presentViewController:sl animated:YES completion:nil];
}
#pragma mark 分享到微信
-(void)goWechat{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"我把你灌醉" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];}
#pragma mark 友盟集成分享
-(void)goShare{
    //显示分享框
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57b6c94de0f55a83d000188f" shareText:@"你要分享的文字" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToRenren,UMShareToWechatSession,UMShareToDouban,nil] delegate:self];
}
//分享结束
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode==UMSResponseCodeSuccess) {
        NSLog(@"分享到了%@",[response.data allKeys][0]);
    }
}
//点击后可直接分享内容
-(BOOL)isDirectShareInIconActionSheet{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
