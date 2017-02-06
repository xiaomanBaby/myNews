//
//  SearchViewController.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchContentViewController.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISearchBar *seach;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSMutableArray *saveButtonCounts;
@property(nonatomic,strong)NSMutableArray *history;
@property(nonatomic,strong)UIButton *historyButton;
@property(nonatomic,strong)UIView *buttonBackView;
@end
static NSString *ID=@"search";
@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles=[NSMutableArray array];
    self.saveTitles=[NSMutableArray array];
    self.history=[NSMutableArray array];
    self.saveButtonCounts=[NSMutableArray array];
    //为历史按钮添加背景view
    self.buttonBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.buttonBackView];
    [self setSearchBar];
    [self setTable];
    [self seachHistoyr];
    [self createHistory];
     [[NSRunLoop currentRunLoop] addTimer:[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES] forMode:NSRunLoopCommonModes];
}
-(void)change{
    float x=arc4random_uniform(ScreenWidth);
    float y=arc4random_uniform(ScreenHeight);
    [UIView animateWithDuration:5 animations:^{
        self.button.layer.position=CGPointMake(x, y);    }];
}
#pragma mark searchBar基础设置
-(void)setSearchBar{
    self.seach=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.seach.delegate=self;
    self.seach.autocapitalizationType=UITextAutocorrectionTypeNo;
    self.navigationItem.titleView=self.seach;
}
#pragma mark tableview基础设置
-(void)setTable{
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(10,64, self.view.frame.size.width-2*10, 250)];
    self.table.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
    self.table.hidden=YES;
    [self.view addSubview:self.table];
    self.table.delegate=self;
    self.table.dataSource=self;
}
#pragma mark 查询---数据库中都是汉字,还只能通过汉字查询
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    if (status==ReachableViaWiFi || status==ReachableViaWWAN) {
        //剔除字符串
        self.seach.text=[self.seach.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([self.seach.text isEqualToString:@""]) {
            self.table.hidden=YES;
        }else{
            self.table.hidden=NO;
            [self.view bringSubviewToFront:self.table];
            [self.titles removeAllObjects];
            AppDelegate *delegate=[UIApplication sharedApplication].delegate;
            FMDatabase *db=delegate.orderData;
            //模糊查询---前三后两个百分号
            FMResultSet *set=[db executeQuery:[NSString stringWithFormat:@"select * from t_order where title like '%%%@%%'",self.seach.text]];
            while ([set next]) {
                NewsModel *model=[[NewsModel alloc]init];
                model.title=[set stringForColumn:@"title"];
                model.time=[set stringForColumn:@"time"];
                model.author=[set stringForColumn:@"author"];
                model.content=[set stringForColumn:@"content"];
                [self.titles addObject:model];
            }
            self.saveTitles=self.titles;
            [self.table reloadData];
        }
    }else{
        [MBProgressHUD showError:@"网络连接已断开"];
    }
}
#pragma mark 搜索历史栏以及清空历史栏设置
-(void)seachHistoyr{
    //1.搜索历史标签
    self.label=[UILabel creatLabelWithFrame:CGRectMake(20, 100, 100, 30) NumOfLines:1 FontSize:15 Text:@"搜索历史:" TextColor:nil IsCornerRadius:YES CornerRadius:5 backgroundColor:[UIColor lightGrayColor]];
    self.label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.label];
    //2.清空键
    UIButton *button=[UIButton createButton:CGRectMake(CGRectGetMaxX(self.label.frame)+80,self.label.frame.origin.y, self.label.frame.size.width, self.label.frame.size.height) Title:@"清空历史记录" TitleFont:15 TitleColor:[UIColor blackColor] BackgroundColor:[UIColor lightGrayColor] cornerRadius:5 BackgroundImage:nil];
   button.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    button.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clean{
    //清空所有历史记录
    [self.buttonBackView removeFromSuperview];
    //将所有记录从plist文件中移除---一个空数组将原来的覆盖掉
    NSString *path=NSHomeDirectory();
    path=[path stringByAppendingPathComponent:@"button.plist"];
    NSArray *array=[NSArray array];
    [array writeToFile:path atomically:YES];
    NSLog(@"%@",path);
}
#pragma mark 点击搜索确定后生成一个搜索记录
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.seach resignFirstResponder];
    self.button=[UIButton createButton:CGRectMake(20, 138, 50, 50) Title:self.seach.text TitleFont:10 TitleColor:nil BackgroundColor:nil cornerRadius:10 BackgroundImage:[UIImage imageNamed:@"qipao.jpg"]];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    //保存相关信息
    NSString *path=NSHomeDirectory();
    path=[path stringByAppendingPathComponent:@"button.plist"];
    NSDictionary *dic=[NSDictionary dictionaryWithObject:self.seach.text forKey:@"name"];
    [self.saveButtonCounts addObject:dic];
    [self.saveButtonCounts writeToFile:path atomically:YES];
}
-(void)change:(UIButton *)sender{
    self.seach.text=sender.titleLabel.text;
}
#pragma mark 生成所有历史记录
-(void)createHistory{
    NSString *path=NSHomeDirectory();
    path=[path stringByAppendingPathComponent:@"button.plist"];
    NSArray *array=[NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrM=[NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSString *string=dic[@"name"];
        [arrM addObject:string];
    }
    self.history=arrM;
    CGFloat width=85;
    CGFloat height=40;
    for (int i=0; i<self.history.count; i++) {
        self.historyButton=[UIButton createButton:CGRectMake(self.label.frame.origin.x+i%3*(10+width), CGRectGetMaxY(self.label.frame)+10+i/3*(10+height), width, height) Title:self.history[i] TitleFont:13 TitleColor:nil BackgroundColor:nil cornerRadius:10 BackgroundImage:[UIImage imageNamed:@"qipao.jpg"]];
        self.historyButton.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self.buttonBackView addSubview:self.historyButton];
        [self.historyButton addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark 单击界面辞退键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.seach resignFirstResponder];
    self.table.hidden=YES;
}
-(void)touch:(UIButton *)sender{
    self.seach.text=sender.titleLabel.text;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveTitles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model=self.saveTitles[indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text=model.title;
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchContentViewController *content=[[SearchContentViewController alloc]init];
    NSIndexPath *indexpath=[self.table indexPathForSelectedRow];
    NewsModel *model=self.saveTitles[indexpath.row];
    content.receiveTitle=model.title;
    content.receiveTime=model.time;
    content.receiveAuthor=model.author;
    content.receiveContent=model.content;
    content.titles=[NSMutableArray array];
    content.titles=self.saveTitles;
    [self.navigationController pushViewController:content animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
