//
//  CollectTableViewController.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *saveData;
@property(nonatomic,strong)NSMutableArray *datas;
- (IBAction)clean:(id)sender;
@end
