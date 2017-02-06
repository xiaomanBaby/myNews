//
//  OrderTableViewCell.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderTableViewController.h"
@implementation OrderTableViewCell
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
+(instancetype)sharedOrderTableViewCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:nil options:nil]lastObject];
}
- (void)awakeFromNib {
    self.buttonShare.layer.cornerRadius=5;
    self.buttonShare.clipsToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)share:(id)sender {
     OrderTableViewController *order=[OrderTableViewController sharedOrderTableViewController];
    //显示分享框
    [UMSocialSnsService presentSnsIconSheetView:order appKey:@"57b6c94de0f55a83d000188f" shareText:@"你要分享的文字" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToRenren,UMShareToWechatSession,UMShareToDouban,nil] delegate:nil];
}

- (IBAction)weChat:(id)sender {
    OrderTableViewController *order=[OrderTableViewController sharedOrderTableViewController];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"我把你灌醉" image:nil location:nil urlResource:nil presentedController:order completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

- (IBAction)sina:(id)sender {
    SLComposeViewController *sl=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    OrderTableViewController *order=[OrderTableViewController sharedOrderTableViewController];
    [order presentViewController:sl animated:YES completion:nil];
}
@end
