//
//  NewsTableViewController.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/23.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewsTableViewController : UITableViewController
//避免被释放
@property(nonatomic,strong)Reachability *reach;
//接收从headerview内传过来的已保存的本地数据
@property(nonatomic,weak)NSMutableArray *receiveLocalDatas;
//将所有标题传到内容页
@property(nonatomic,strong)NSMutableArray *pushTitles;
+(instancetype)allocWithZone:(struct _NSZone *)zone;
+(instancetype)sharedNewsTableViewController;
@end
