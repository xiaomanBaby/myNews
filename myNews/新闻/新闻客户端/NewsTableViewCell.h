//
//  NewsTableViewCell.h
//  新闻客户端
//
//  Created by 李荣跃 on 16/8/23.
//  Copyright © 2016年 weikunchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewsTableViewCell : UITableViewCell
@property(nonatomic,strong)NewsModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *clicks;
-(void)setModel:(NewsModel *)model;
+(instancetype)sharedNewsTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonWechat;
@property (weak, nonatomic) IBOutlet UIButton *buttonSina;

@end
