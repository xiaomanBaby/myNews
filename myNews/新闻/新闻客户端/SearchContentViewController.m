//
//  SearchContentViewController.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "SearchContentViewController.h"

@interface SearchContentViewController ()

@end

@implementation SearchContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftbarbutton];
    [self setNavigationitemView];
    [self setView];
}
#pragma mark 设置左导航栏
-(void)setLeftbarbutton{
    self.view.backgroundColor=[UIColor whiteColor];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bar_back_selected.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [item setTintColor:[UIColor blackColor]];
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]init];
    item1.enabled=NO;
    [item1 setTitle:@"正文"];
    self.navigationItem.leftBarButtonItems=@[item,item1];
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark 设置navagationTitleView
-(void)setNavigationitemView{
    //添加的一些基本设置
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(ContentTitleViewX, ContentTitleViewY, ContentTitleViewWidth,ContentLabelHeight)];
    self.navigationItem.titleView=view;
    UILabel *label=[[UILabel alloc]init];
    [self creatLabelWithName:label andFrame:CGRectMake(0, 0, ContentTitltLabelWidth, ContentLabelHeight) andNumOfLines:1 andFontSize:11 andText:@"最新播报:" andTextColor:[UIColor blueColor] andSuperView:view];
    self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(ContentTitltLabelWidth, 0, ContentTitleScrollWidth,ContentLabelHeight)];
    for (int i=0; i<self.titles.count; i++) {
        UILabel *label=[[UILabel alloc]init];
        NewsModel *m=[[NewsModel alloc]init];
        m=self.titles[i];
        [self creatLabelWithName:label andFrame:CGRectMake(i*ContentTitleScrollWidth, 0, ContentTitleScrollWidth,ContentLabelHeight) andNumOfLines:2 andFontSize:10 andText:m.title andTextColor:nil andSuperView:self.scrollview];
    }
    //关了用户交互,不让点
    self.scrollview.userInteractionEnabled=NO;
    self.scrollview.pagingEnabled=YES;
    self.scrollview.contentSize=CGSizeMake(5*ContentTitleScrollWidth, 0);
    self.scrollview.showsHorizontalScrollIndicator=NO;
    [view addSubview:self.scrollview];
    //加到一个循环回路内
    [[NSRunLoop currentRunLoop] addTimer:[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scroll) userInfo:nil repeats:YES] forMode:NSRunLoopCommonModes];
}
-(void)scroll{
    static int x=0;
    if(x<5) {
        self.scrollview.contentOffset=CGPointMake(x*ContentTitleScrollWidth, 0);
        x++;
        if (x>=5) {
            x=0;
        }
    }
    
    
}
#pragma mark 设置页面内容
-(void)setView{
    //标题
    self.label=[[UILabel alloc]init];
    self.label.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self creatLabelWithName:self.label andFrame:CGRectMake(ContentViewTitleX,ContentViewTitleY, ScreenWidth-2*ContentViewTitleX, ContentLabelHeight) andNumOfLines:1 andFontSize:13 andText:self.receiveTitle andTextColor:nil andSuperView:self.view];
    //时间栏
    UILabel *labelTime=[[UILabel alloc]init];
    labelTime.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self creatLabelWithName:labelTime andFrame:CGRectMake(ContentLabelTimeX, CGRectGetMaxY(self.label.frame),ContentLabelTimeWidth,ContentLabelHeight) andNumOfLines:2 andFontSize:10 andText:self.receiveTime andTextColor:nil andSuperView:self.view];
    //作者栏
    UILabel *labelAuthor=[[UILabel alloc]init];
    labelAuthor.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self creatLabelWithName:labelAuthor andFrame:CGRectMake(CGRectGetMaxX(labelTime.frame),CGRectGetMaxY(self.label.frame),ContentLabelAuthorWidth, ContentLabelHeight) andNumOfLines:1 andFontSize:10 andText:[NSString stringWithFormat:@"作者:%@",self.receiveAuthor] andTextColor:nil andSuperView:self.view];
    //字体缩小按钮
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelAuthor.frame), CGRectGetMaxY(self.label.frame), ContentButtonWidth, ContentLabelHeight)];
    button.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [button setBackgroundImage:[UIImage imageNamed:@"suoxiao.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    //字体放大按钮
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMaxY(self.label.frame), ContentButtonWidth, ContentLabelHeight)];
    button1.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [button1 setBackgroundImage:[UIImage imageNamed:@"fangda.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(enlarge) forControlEvents:UIControlEventTouchUpInside];
    //对应内容
    self.textview=[[UITextView alloc]initWithFrame:CGRectMake(ContentViewTitleX,CGRectGetMaxY(labelTime.frame), ScreenWidth-2*ContentViewTitleX, self.view.frame.size.height-CGRectGetMaxY(labelTime.frame))];
    self.textview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    self.textview.text=self.receiveContent;
    self.textview.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:self.textview];
    
}
#pragma mark 缩小字体
-(void)reduce{
    static int  a=14;
    self.textview.font=[UIFont systemFontOfSize:a];
    a--;
}
#pragma mark 字体放大
-(void)enlarge{
    static int b=16;
    self.textview.font=[UIFont systemFontOfSize:b];
    b++;
}
#pragma mark 建label
-(void)creatLabelWithName:(UILabel *)label andFrame:(CGRect)frame andNumOfLines:(NSInteger)lines andFontSize:(CGFloat)size andText:(NSString *)text andTextColor:(UIColor *)color andSuperView:(UIView *)superview{
    label.frame=frame;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:size];
    label.numberOfLines=lines;
    label.text=text;
    label.textColor=color;
    [superview addSubview:label];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
