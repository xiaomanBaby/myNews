//
//  UILabel+Create.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "UILabel+Create.h"

@implementation UILabel (Create)
#pragma mark 建label
+(UILabel *)creatLabelWithFrame:(CGRect)frame NumOfLines:(NSInteger)lines FontSize:(CGFloat)size Text:(NSString *)text TextColor:(UIColor *)color IsCornerRadius:(BOOL)YN CornerRadius:(CGFloat)CRadius backgroundColor:(UIColor *)BColor{
   UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:size];
    label.numberOfLines=lines;
    label.text=text;
    label.textColor=color;
    label.layer.cornerRadius=CRadius;
    label.clipsToBounds=YN;
    label.backgroundColor=BColor;
    return label;
}
@end
