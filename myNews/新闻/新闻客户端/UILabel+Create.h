//
//  UILabel+Create.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Create)
+(UILabel *)creatLabelWithFrame:(CGRect)frame NumOfLines:(NSInteger)lines FontSize:(CGFloat)size Text:(NSString *)text TextColor:(UIColor *)color IsCornerRadius:(BOOL)YN CornerRadius:(CGFloat)CRadius backgroundColor:(UIColor *)BColor;
@end
