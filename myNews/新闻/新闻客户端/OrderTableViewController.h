//
//  OrderTableViewController.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/26.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewController : UITableViewController
//保存数据
@property(nonatomic,strong)NSMutableArray *Orderdatas;
@property(nonatomic,strong)NSMutableArray *saveDatas;
+(instancetype)allocWithZone:(struct _NSZone *)zone;
+(instancetype)sharedOrderTableViewController;
@end
