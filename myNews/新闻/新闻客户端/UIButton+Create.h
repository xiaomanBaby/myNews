//
//  UIButton+Create.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/27.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)
+(UIButton *)createButton:(CGRect)frame Title:(NSString *)title TitleFont:(CGFloat)font TitleColor:(UIColor *)Tcolor BackgroundColor:(UIColor *)Bcolor cornerRadius:(CGFloat)Cradious BackgroundImage:(UIImage *)image;
@end
