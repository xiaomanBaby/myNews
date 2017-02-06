//
//  OrderTableViewCell.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property(nonatomic,strong)NewsModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *clicks;
- (IBAction)share:(id)sender;
- (IBAction)weChat:(id)sender;
- (IBAction)sina:(id)sender;
-(void)setModel:(NewsModel *)model;
+(instancetype)sharedOrderTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@end
