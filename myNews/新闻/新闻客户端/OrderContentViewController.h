//
//  OrderContentViewController.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderContentViewController : UIViewController
@property(nonatomic,strong)UIScrollView *scrollview;
//接收所有标题
@property(nonatomic,strong)NSMutableArray *titles;
@property(nonatomic,strong)NSNumber *idid;
//接收传过来的标题
@property(nonatomic,strong)NSString *receiveTitle;
//接收传过来的时间
@property(nonatomic,strong)NSString *receiveTime;
//接收传过来的作者
@property(nonatomic,strong)NSString *receiveAuthor;
//接收传过来的具体新闻内容
@property(nonatomic,strong)NSString *receiveContent;
@property(nonatomic,strong)UITextView *textview;
@property(nonatomic,strong)UILabel *label;
@end
