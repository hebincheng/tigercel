//
//  ZYY_RoomView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_RoomView.h"
#import "ZYY_CollectionViewCell.h"
#import "UIButton+ZYY_DeleteBtn.h"
#define angelToRandian(x) ((x)/180.0*M_PI)

#define Width(X) (X-80)/3.0f//边距为20  一行显示3个设备

@interface ZYY_RoomView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    //
    UICollectionView *_collectionView;
    //
    NSMutableArray *_equipmentArr;
    //视图的宽高，房间名
    CGFloat _width;
    CGFloat _heigh;
    //长按手势
    UILongPressGestureRecognizer *_longGes;
    //设备视图数组
    NSMutableArray *_LEDMutableArr;
    //删除按钮视图数组
    NSMutableArray *_deleteBtnArr;
    //编辑状态
    BOOL _beEdit;
}
@end

static NSString *collectionID=@"collectionID";

@implementation ZYY_RoomView

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_LEDMutableArr==nil)
    {
        _LEDMutableArr=[NSMutableArray array];
    }
    if (_deleteBtnArr==nil)
    {
        _deleteBtnArr=[NSMutableArray array];
    }
    _beEdit=NO;
    
    [self loadUI];
#pragma mark只需改变数组 即可改变状态
//    _equipmentArr=[NSMutableArray arrayWithObjects:@"0",@"1",@"0",@"1",@"2",@"1",@"0",@"1",@"0", nil];
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andShowWidth:(CGFloat)width andShowHeigh:(CGFloat)height roomName:(NSString *)roomName andLEDArr:(NSArray *)ledArr{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil) {
        _width=width;
        _heigh=height;
        _equipmentArr=[NSMutableArray arrayWithArray:ledArr];
        //初始化房间Label
        _roomName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, 40)];
        [_roomName setText:roomName];
        [_roomName setTextAlignment:NSTextAlignmentCenter];
        [_roomName setBackgroundColor:RGB(234, 89, 89)];
        [self.view addSubview:_roomName];
        
        
    }
    return self;
}

-(void)loadUI
{
    [self.view setBackgroundColor:RGB(239, 239, 239)];
    _longGes=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    
    //设置collectionView
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, _width  , _heigh-40)collectionViewLayout:[[UICollectionViewFlowLayout alloc]init ]];
    [_collectionView addGestureRecognizer:_longGes];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setScrollEnabled:YES];
    [self.view addSubview:_collectionView];
    // cell的注册必须放在添加视图之后来进行
    [_collectionView registerClass:[ZYY_CollectionViewCell  class] forCellWithReuseIdentifier:collectionID];
//   UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, _width  , _heigh-40)];
//    [imView setImage:[UIImage imageNamed:@"bjt.jpeg"]];
//    [_collectionView setBackgroundView:imView];
//    [_collectionView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
}

-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state==UIGestureRecognizerStateBegan)
    {
        //按键添加晃动动画
        CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
        anim.keyPath=@"transform.rotation";
        anim.values=@[@(angelToRandian(-4)),@(angelToRandian(4)),@(angelToRandian(-4))];
        anim.repeatCount=MAXFLOAT;
        anim.duration=0.2;
        //在非编辑状态的情况下变成编辑状态
        if (_beEdit==NO)
        {
            for (UIButton *LED in _LEDMutableArr)
            {
                [LED.layer addAnimation:anim forKey:nil];
            }
            for (UIButton *deleteBtn in _deleteBtnArr)
            {
                [deleteBtn setHidden:NO];
            }
            
            _beEdit=YES;
        }
        //在编辑状态的情况下变成非编辑状态
        else if (_beEdit==YES){
            for (UIButton *LED in _LEDMutableArr)
            {
                [LED.layer removeAllAnimations];
            }
            for (UIButton *deleteBtn in _deleteBtnArr)
            {
                [deleteBtn setHidden:YES];
            }
            _beEdit=NO;
        }
    }
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
    ZYY_CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
   // UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, coll.contentView.bounds.size.width-20.0f,coll.contentView.bounds.size.height-20.0f)];
    //设置越界不裁减，因为删除按钮而设置
    [cell.contentView setClipsToBounds:NO];
    //加载cell前  移除cell上的内容
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
     UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width,cell.contentView.bounds.size.height)];
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
    [_LEDMutableArr addObject:btn];
    
    
    //设置删除按钮
    UIButton *deledateBtn=[[UIButton alloc]initWithFrame:CGRectMake( cell.contentView.bounds.size.width-20, 0, 20, 20)];
    //设置圆角和背景
    [deledateBtn.layer setCornerRadius:3];
    [deledateBtn.layer setMasksToBounds:YES];
    [deledateBtn setBackgroundColor:[UIColor redColor]];
    
    [deledateBtn setTitle:@"×" forState:UIControlStateNormal];
    [deledateBtn setTag:(500+indexPath.row)];
    
    [deledateBtn addTarget:self action:@selector(tapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    //增加button的响应范围
    [deledateBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [_deleteBtnArr addObject:deledateBtn];
    //设置初始为隐藏
    [deledateBtn setHidden:YES];
    [btn addSubview:deledateBtn];
    
    
    [cell.contentView addSubview:btn];
    return cell;
}
//cell的个数
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
#pragma mark -
#pragma mark 以添加或者删除的方式进行刷新视图
-(void)reloadDataWithNewDevice:(NSString *)led{
    [_equipmentArr addObject:led];
    //每次刷新前移除按钮的视图数组 ，然后再重新加载
    [_deleteBtnArr removeAllObjects];
    [_LEDMutableArr removeAllObjects];
    
    [_collectionView reloadData];
}

-(void)reloadDataWithDeleteDevice:(NSInteger)deviceNum{
    [_equipmentArr removeObjectAtIndex:deviceNum];
    
    //每次刷新前移除按钮的视图数组 ，然后再重新加载
    [_deleteBtnArr removeAllObjects];
    [_LEDMutableArr removeAllObjects];
    
    //在房间视图中删除设备后，需要在设备列表中添加对应设备
    [_delegate addDeviceWithBeDeletedDevice:@"1" andBeDeletedDeviceNum:deviceNum];
    _beEdit=NO;
    [_collectionView reloadData];

}

-(void)tapDeleteBtn:(UIButton *)btn{
    NSInteger num=btn.tag-500;
    [self reloadDataWithDeleteDevice:num];
    MYLog(@"第%ld个按钮",num);
}

@end
