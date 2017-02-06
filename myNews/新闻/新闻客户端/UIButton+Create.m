//
//  UIButton+Create.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)
+(UIButton *)createButton:(CGRect)frame Title:(NSString *)title TitleFont:(CGFloat)font TitleColor:(UIColor *)Tcolor BackgroundColor:(UIColor *)Bcolor cornerRadius:(CGFloat)Cradious BackgroundImage:(UIImage *)image{
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:font];
    [button setTitleColor:Tcolor forState:UIControlStateNormal];
    [button setBackgroundColor:Bcolor];
    button.layer.cornerRadius=Cradious;
    button.layer.masksToBounds=YES;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}
@end
