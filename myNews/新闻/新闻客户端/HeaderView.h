//
//  HeaderView.h
//  新闻客户端
//
//  Created by 李荣跃 on 16/8/23.
//  Copyright © 2016年 weikunchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "NewsModel.h"
typedef void (^myBlock)(NSMutableArray *);
@interface HeaderView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)CollectionViewCell *cell;
//保存数据
@property(nonatomic,strong)NSMutableArray *datas;
//保存联网数据
@property(nonatomic,strong)NSMutableArray *saveDatas;
//块传值
@property(nonatomic,strong)myBlock block;
@end
