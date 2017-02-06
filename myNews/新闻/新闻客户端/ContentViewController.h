//
//  ContentViewController.h
//  新闻客户端
//
//  Created by 李荣跃 on 16/8/24.
//  Copyright © 2016年 weikunchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController
@property(nonatomic,strong)UIScrollView *scrollview;
//接收数据
@property(nonatomic,strong)NewsModel *model;
@property(nonatomic,strong)NSMutableArray *titles;
@property(nonatomic,strong)UITextView *textview;
@property(nonatomic,strong)UILabel *label;
@end
