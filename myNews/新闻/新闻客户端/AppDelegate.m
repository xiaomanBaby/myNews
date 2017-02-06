//
//  AppDelegate.m
//  新闻客户端
//
//  Created by 李亚满 on 16/8/22.
//  Copyright © 2016年 LYM. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "TabBarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma mark 设置友盟分享
    //设置key
    [UMSocialData setAppKey:@"57b6c94de0f55a83d000188f"];
    //配置第三方APPID---微信
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //---分享到新浪
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3027886858" secret:@"862aa13cf1b5a77b0d0632d3a23d6733" RedirectURL:nil];
    [self chevkNet];
#pragma mark 在这里面建立数据库,让所有页面都能取到
    //保存数据
    //---指定数据库
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    path=[path stringByAppendingPathComponent:@"myNews.sqlite"];
      FMDatabaseQueue *queue=[FMDatabaseQueue databaseQueueWithPath:path];
    [queue inDatabase:^(FMDatabase *db) {
       BOOL isOpen=[db open];
        if (!isOpen) {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.labelText=@"数据加载失败";
            hud.detailsLabelText=@"请重新尝试";
            [hud hide:YES afterDelay:2];
        }
        //建新闻页表
        BOOL isCreateNews=[db executeUpdate:@"create table if not exists news(idid integer,title text,subtitle text,picture text,author text,time text,content text,flid integer,clicks integer,pic blob)"];
        //blob保存二进制数据---图片、声音、视频
        if (!isCreateNews) {
            NSLog(@"创建新闻表格失败");
        }
        self.data=db;
        //建排行榜表
        BOOL isCreateOrder=[db executeUpdate:@"create table if not exists t_order(idid integer,title text,subtitle text,picture text,author text,time text,content text,flid integer,clicks integer,pic blob)"];
        if (!isCreateOrder) {
            NSLog(@"创建排行表格失败");
        }
        self.orderData=db;
        //建排收藏表
        BOOL isCreateCollect=[db executeUpdate:@"create table if not exists t_collect(idid integer,title text,subtitle text,picture text,author text,time text,content text,flid integer,clicks integer,pic blob)"];
        if (!isCreateCollect) {
            NSLog(@"创建排行表格失败");
        }
        self.collectData=db;
    }];
    NSLog(@"%@",path);
    return YES;
}
#pragma mark 检测网络状态
-(void)chevkNet{
    //感知网络变化---通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:kReachabilityChangedNotification object:nil];
    //感知网络变化必须获得当前网络状态,才能再网络变化后产生对比
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status=[reach currentReachabilityStatus];
    if (status==NotReachable) {
        NSLog(@"断网");
    }else if (status==ReachableViaWiFi){
        NSLog(@"wifi");
    }else if(status==ReachableViaWWAN){
        NSLog(@"流量");
    }
    [reach startNotifier];//注意:必须启动通知
}
-(void)change:(NSNotification *)sender{
    Reachability *reach=[sender object];
    if (reach.currentReachabilityStatus==NotReachable) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText=@"网络连接已断开";
        hud.detailsLabelText=@"请稍后重新尝试";
        [hud hide:YES afterDelay:2];
    }else if (reach.currentReachabilityStatus==ReachableViaWiFi){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.labelText=@"您已成功连接至WIFI状态";
        [hud hide:YES afterDelay:2];
    }else if (reach.currentReachabilityStatus==ReachableViaWWAN){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.labelText=@"您当前网络状态为蜂窝移动网";
        hud.detailsLabelText=@"可能会产生额外的费用";
        [hud hide:YES afterDelay:2];
    }
}
#pragma mark 需实现这两个回调---不然返回的时候会崩掉
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
