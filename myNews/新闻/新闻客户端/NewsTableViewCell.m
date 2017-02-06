//
//  NewsTableViewCell.m
//  新闻客户端
//
//  Created by 李荣跃 on 16/8/23.
//  Copyright © 2016年 weikunchao. All rights reserved.
//
#import "NewsTableViewCell.h"
@implementation NewsTableViewCell
-(void)setModel:(NewsModel *)model{
    _title.text=model.title;
    _subtitle.text=model.subtitle;
    _clicks.text=[NSString stringWithFormat:@"点击量:%@",model.clicks];
    NSString *string=[NSString stringWithFormat:@"http://115.159.1.248:56666/xinwen/images/%@",model.picture];
    NSURL *url=[NSURL URLWithString:string];
    [_imageview sd_setImageWithURL:url];
    _imageview.layer.cornerRadius=10;
    _imageview.layer.masksToBounds=YES;
    _imageview.layer.borderColor=[UIColor blueColor].CGColor;
    _imageview.layer.borderWidth=2;
}
+(instancetype)sharedNewsTableViewCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"NewsCell" owner:nil options:nil]lastObject];
}
- (void)awakeFromNib {
    self.buttonShare.layer.cornerRadius=5;
    self.buttonShare.clipsToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
