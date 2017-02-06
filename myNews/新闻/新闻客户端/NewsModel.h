//
//  NewsModel.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/23.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NewsModel : NSObject
@property(nonatomic,strong)NSNumber *idid;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *subtitle;
@property(nonatomic,strong)NSString *picture;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSNumber *flid;
@property(nonatomic,strong)NSNumber *clicks;
@property(nonatomic,strong)UIImage *pic;
-(instancetype)initwithDic:(NSDictionary *)dic;
+(instancetype)sharedNewsModel:(NSDictionary *)dic;
@end
