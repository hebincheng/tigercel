//
//  ZYY_RoomList.m
//  tigercel
//
//  Created by 虎符通信 on 16/3/1.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_RoomList.h"
#import "ZYY_RoomView.h"

#define DEVICE_VIEW_HEIGHT 100

#define DEVICE_WIDTH 60
@interface ZYY_RoomList ()
{
    //设备的滚动视图
    UIScrollView *_LEDScrollView;
    //房间的滚动视图
    UIScrollView *_roomScrollView;
    //设备数组
    NSMutableArray *_LEDArr;
    //房间数组
    NSMutableArray *_roomArr;
}
@end

@implementation ZYY_RoomList

- (void)viewDidLoad {
    [super viewDidLoad];
    _LEDArr=[[NSMutableArray alloc]initWithArray: @[@1,@2,@3,@5,@4,@7,@8,@9,@10]];
    _roomArr=[[NSMutableArray alloc]initWithArray: @[@1,@2,@3]];
    [self loadUI];

    // Do any additional setup after loading the view.
}

-(void)loadUI{
    [self setTitle:@"我的房间"];
    _roomScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREE_WIDTH, SCREE_HEIGHT-DEVICE_VIEW_HEIGHT)];//100是_LEDScrollView的高度
    [_roomScrollView setBackgroundColor:RGB(239, 239, 239)];
    
    [_roomScrollView setScrollEnabled:YES];
    //设置分页
    [_roomScrollView setPagingEnabled:YES];
    [_roomScrollView setBackgroundColor:RGB(239, 239, 239)];
    //设置弹性效果
    [_roomScrollView setBounces:NO];
    //设置滚动条
    [_roomScrollView setShowsHorizontalScrollIndicator:YES];
    [_roomScrollView setShowsVerticalScrollIndicator:YES];
    //设置滚动区域
    [_roomScrollView setContentSize:CGSizeMake(SCREE_WIDTH*(_roomArr.count+1), SCREE_HEIGHT-64-DEVICE_VIEW_HEIGHT)];
    for (int i=0; i<=_roomArr.count; i++)
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20+i*SCREE_WIDTH, 10, SCREE_WIDTH-20*2, SCREE_HEIGHT-64-DEVICE_VIEW_HEIGHT-10*2)];
        MYLog(@"房间视图的宽度%f",SCREE_WIDTH-40);
        [view setBackgroundColor:[UIColor redColor]];
        if (i!=_roomArr.count)
        {
            
            ZYY_RoomView *roomView=[[ZYY_RoomView alloc]initWithNibName:@"ZYY_RoomView" bundle:nil andShowWidth:SCREE_WIDTH-20*2 andShowHeigh:SCREE_HEIGHT-64-100-10*2];
            
            //需添加子视图控制器
            [self addChildViewController:roomView];
            [view addSubview:roomView.view];
        }
        else{
        //添加新的房间
        }
        [_roomScrollView addSubview:view];
    }
    [self.view addSubview:_roomScrollView];
    
    
    //设置设备列表滚动的视图
    _LEDScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREE_HEIGHT-DEVICE_VIEW_HEIGHT, SCREE_WIDTH, DEVICE_VIEW_HEIGHT)];
    [_LEDScrollView setBackgroundColor:[UIColor redColor]];
    //设置分页
    [_LEDScrollView setPagingEnabled:YES];
    //设置滚动条
    [_LEDScrollView setShowsHorizontalScrollIndicator:YES];
    [_LEDScrollView setShowsVerticalScrollIndicator:YES];
    //设置弹簧效果
    [_LEDScrollView setBounces:YES];
    //设置滚动区域
    [_LEDScrollView setContentSize:CGSizeMake(DEVICE_WIDTH *_LEDArr.count, DEVICE_VIEW_HEIGHT)];
    MYLog(@"%@",_LEDScrollView);
    for (int i=0; i<_LEDArr.count; i++)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*DEVICE_WIDTH, SCREE_HEIGHT-DEVICE_VIEW_HEIGHT+10, DEVICE_WIDTH, 60)];
//        MYLog(@"设备列表，设备的x位置%d，设备的y位置%f",10+i*DEVICE_WIDTH,SCREE_HEIGHT-DEVICE_VIEW_HEIGHT+10);
        MYLog(@"%@",imageView);
        [imageView setBackgroundColor:[UIColor blueColor]];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+i*DEVICE_WIDTH, SCREE_HEIGHT-DEVICE_VIEW_HEIGHT+70, DEVICE_WIDTH, 30)];
        [nameLabel setText:@"888"];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        MYLog(@"%@",nameLabel);
        
        [_LEDScrollView addSubview:imageView];
        [_LEDScrollView addSubview:nameLabel];
    }
    [self.view addSubview:_LEDScrollView];
}

@end
