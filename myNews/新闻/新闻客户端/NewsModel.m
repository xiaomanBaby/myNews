//
//  NewsModel.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/23.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "NewsModel.h"
@implementation NewsModel
-(instancetype)initwithDic:(NSDictionary *)dic{
    if (self==[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(instancetype)sharedNewsModel:(NSDictionary *)dic{
    return [[self alloc]initwithDic:dic];
}
@end
