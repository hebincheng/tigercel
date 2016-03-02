//
//  ZYY_RoomView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_RoomView.h"
#import "ZYY_CollectionViewCell.h"

#define Width(X) (X-80)/3.0f//边距为20  一行显示3个设备

@interface ZYY_RoomView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_equipmentArr;
    CGFloat _width;
    CGFloat _heigh;
}
@end

static NSString *collectionID=@"collectionID";

@implementation ZYY_RoomView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
#pragma mark只需改变数组 即可改变状态
    _equipmentArr=[NSMutableArray arrayWithObjects:@"0",@"1",@"0",@"1",@"2",@"1",@"0",@"1",@"0", nil];
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andShowWidth:(CGFloat)width andShowHeigh:(CGFloat)height{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil) {
        _width=width;
        _heigh=height;
    }
    return self;
}

-(void)loadUI
{
    [self.view setBackgroundColor:RGB(239, 239, 239)];
    
    //设置
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _width  , _heigh)collectionViewLayout:[[UICollectionViewFlowLayout alloc]init ]];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setScrollEnabled:YES];
    [self.view addSubview:_collectionView];
    // cell的注册必须放在添加视图之后来进行
    [_collectionView registerClass:[ZYY_CollectionViewCell  class] forCellWithReuseIdentifier:collectionID];
//    [_collectionView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [_collectionView setBackgroundColor:[UIColor redColor]];
}
#pragma mark-
#pragma mark灯泡触发事件
-(void)tapDeng:(UIButton *)sender
{
    sender.selected=!sender.selected;
}

#pragma mark-
#pragma mark collection代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZYY_CollectionViewCell *coll=[collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
   // UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, coll.contentView.bounds.size.width-20.0f,coll.contentView.bounds.size.height-20.0f)];
     UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, coll.contentView.bounds.size.width,coll.contentView.bounds.size.height)];
    [btn addTarget:self action:@selector(tapDeng:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置好按钮的三种状态下的图片
    [btn setImage:[UIImage imageNamed:@"zaixian"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"lixian"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"bukeyong"] forState:UIControlStateDisabled];
    if ([_equipmentArr[indexPath.row] isEqualToString:@"1"])
    {
        [btn setSelected:YES];
    }
    else if([_equipmentArr[indexPath.row] isEqualToString:@"2"])
    {
        [btn setEnabled:NO];
    }
    
    [coll.contentView addSubview:btn];
    return coll;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _equipmentArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Width(_width), Width(_width));
}
//设置cell与边框的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上左下右
    return UIEdgeInsetsMake(10,20, 20, 20);
}
////最小列距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}


@end
