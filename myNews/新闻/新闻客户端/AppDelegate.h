//
//  AppDelegate.h
//  新闻客户端
//
//  Created by 李亚满 on 16/8/22.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)FMDatabase *data;
@property(nonatomic,strong)FMDatabase *orderData;
@property(nonatomic,strong)FMDatabase *collectData;
@end

