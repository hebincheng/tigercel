//
//  ZYY_RoomList.m
//  tigercel
//
//  Created by 虎符通信 on 16/3/1.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_RoomList.h"
#import "ZYY_RoomView.h"
#import "ZYY_LEDImageView.h"
#import "ZYY_User.h"
#import "Masonry.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#define DEVICE_VIEW_HEIGHT 100
//设备列表中设备的宽度
#define DEVICE_WIDTH 60


@interface ZYY_RoomList ()<UIAlertViewDelegate,UIScrollViewDelegate>
{
    //设备的滚动视图
    UIScrollView *_LEDScrollView;
    //房间的滚动视图
    UIScrollView *_roomScrollView;
    //设备数组
    NSMutableArray *_LEDArr;
    //设备视图数组
    NSMutableArray *_LEDViewArr;
    //房间数组————存储房间数据信息
    NSMutableArray *_roomArr;
    //房间视图控制器数组
    NSMutableArray *_roomViewControlArr;
    //房间视图数组————存储所有房间视图
    NSMutableArray *_roomViewArr;
    //捏合手势识别器
    UIPinchGestureRecognizer *_pinchGesRecognize;
    //长按手势
    UILongPressGestureRecognizer *_longGeRecognize;
    //房间
    ZYY_RoomView *_roomView;
    //房间是否是编辑模式
    BOOL _IsEdit;
    //plist中读取的字典
    NSDictionary *_dict;
    //plist文件路径
    NSString *_filePath;
    //当前在的房间
    NSInteger _curPage;
    //记录移动的是第几个LEDImageView
    NSInteger _moveNum;
    //设备图标移动前所在中心点
    CGPoint _originPoint;
    //长按手势移动的点
    CGPoint _movePoint;
    //长按选择的视图
    UIImageView *_selectedView;
    //形变效果
    CGAffineTransform _transForm;
}
@end

@implementation ZYY_RoomList

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    _roomViewControlArr=[NSMutableArray array];
    _roomViewArr=[NSMutableArray array];
    _LEDViewArr=[NSMutableArray array];
    _LEDArr=[[NSMutableArray alloc]initWithArray: @[@1,@2,@1,@1,@1,@1,@1,@1,@3,@5,@4,@7,@8,@9,@10]];
    _curPage=0;
    
    //读取plist文件中的数据
    _filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userRoomArr.plist"];
    
    _dict=[NSDictionary dictionaryWithContentsOfFile: _filePath];
    MYLog(@"%@",_dict);
    NSArray *plArr=[_dict objectForKey:USER_ID];
    //将读取到的房间数组给_roomArr
    _roomArr=[NSMutableArray arrayWithArray:plArr];
    
    _IsEdit=YES;
    //实例化手势识别器
    _pinchGesRecognize = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    _longGeRecognize=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
    //长按时间为1秒
    _longGeRecognize.minimumPressDuration=1;

    //允许15秒中运动
    _longGeRecognize.allowableMovement=15;

    //所需触摸1次
    _longGeRecognize.numberOfTouchesRequired=1;
    
    [self loadUI];
    
    // Do any additional setup after loading the view.
}
//获取视图的控制器
-(UIViewController *)viewController:(UIView *)view{
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    // If the view controller isn't found, return nil.
    return nil;
}

#pragma mark-
#pragma mark  手势触发事件
-(void)longTap:(UILongPressGestureRecognizer *)longPre
{
    
    _movePoint =[longPre locationInView:_LEDScrollView];
   
    MYLog(@"%f---%f",_movePoint.x,_movePoint.y);
    
    if(longPre.state==UIGestureRecognizerStateBegan){
        MYLog(@"长按事件触发");
      _moveNum=(int)_movePoint.x/(10+DEVICE_WIDTH);
        _selectedView=_LEDViewArr[_moveNum];
        _originPoint=_selectedView.center;
        
        //触发长按事件后将图标的中心点设为手指的point处
        [UIView animateWithDuration:0.2 animations:^{
            _transForm=CGAffineTransformScale(_selectedView.transform, 1.5, 1.5);
            [_selectedView setTransform:_transForm];
            [_selectedView setCenter:_movePoint];
        }];
        
    }
    else if(longPre.state==UIGestureRecognizerStateChanged){
        MYLog(@"移动中");
        [_selectedView setCenter:CGPointMake(_movePoint.x, _movePoint.y)];
    }
    
    else if(longPre.state==UIGestureRecognizerStateEnded){
        
        MYLog(@"长按结束");
        //图标还没有完全移出_LEDSCrollView
        if ( CGRectGetMaxY(_selectedView.frame)>_LEDScrollView.bounds.origin.y )
        {
           [UIView animateWithDuration:0.2 animations:^{
               //还原成原来大小
               _transForm =CGAffineTransformScale(_selectedView.transform, 2.0f/3, 2.0f/3);
               [_selectedView setTransform:_transForm];
               //还原到初始位置
               [_selectedView setCenter:_originPoint];
           }];
        }
        //图标移出了_LEDScrollView
        else {
            //将图标放到_roomView位置
            ZYY_RoomView *currentRoomViewCon=_roomViewControlArr[_curPage];
            MYLog(@"%@---%@",currentRoomViewCon,currentRoomViewCon.roomName.text);
            [currentRoomViewCon reloadDataWithNewDevice:@"0"];
            //添加设备到房间数组
            NSMutableDictionary *dict=_roomArr[_curPage];
            NSArray *array=[dict objectForKey:@"ledArray"];
            NSMutableArray *mArr=[NSMutableArray arrayWithArray:array];
           
            NSString *roomName=[dict objectForKey:@"roomName"];
            [mArr addObject:@"0"];
            [dict setValue:mArr forKey:@"ledArray"];
            [dict setValue:roomName forKey:@"roomName"];
            [_roomArr replaceObjectAtIndex:_curPage withObject:dict];
            
            MYLog(@"%@",_roomArr);
            
            //移除
            [_selectedView removeFromSuperview];
            [_LEDViewArr removeObjectAtIndex:_moveNum];
            [_LEDArr removeObjectAtIndex:_moveNum];
            
            //设置滚动区域
            [_LEDScrollView setContentSize:CGSizeMake((10+DEVICE_WIDTH )*_LEDArr.count, DEVICE_VIEW_HEIGHT)];
            //使后面的设备前移
            [_LEDViewArr enumerateObjectsUsingBlock:^(ZYY_LEDImageView * ledImage, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx>=_moveNum)
                {
                    ledImage.tag=10000+idx;
                    CGPoint point=ledImage.center;
                    [ledImage setCenter:CGPointMake(point.x-10-DEVICE_WIDTH, point.y)];
                }
            }];
        }
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        if (gesture.scale>1&&_IsEdit)
        {
            MYLog(@"放大手势");
            [self enlargeScrollView];
        }
        else if(gesture.scale<1&&!_IsEdit)
        {
            MYLog(@"缩小手势");
            [self reduceScrollView];
        }
    }
}
#pragma mark-
#pragma mark  放大视图
-(void)enlargeScrollView{
    _roomView=[[ZYY_RoomView alloc]initWithNibName:@"ZYY_RoomView" bundle:nil andShowWidth:SCREE_WIDTH andShowHeigh:SCREE_HEIGHT roomName:@"客厅" andLEDArr:nil];
    [_roomView.view addGestureRecognizer:_pinchGesRecognize];
    [self presentViewController:_roomView animated:YES completion:^{
        
    }];
  [UIView animateWithDuration:1.0f animations:^{
      
//      [_roomScrollView setFrame:CGRectMake(0, 0, SCREE_WIDTH, SCREE_HEIGHT)];
//      [_LEDScrollView setAlpha:0];
  } completion:^(BOOL finished) {
      //放大后退出编辑模式
      _IsEdit=NO;
      MYLog(@"放大结束");
  }];
}

#pragma mark  缩小视图
-(void)reduceScrollView{
    [UIView animateWithDuration:1.0f animations:^{
        [_roomView dismissViewControllerAnimated:YES completion:^{
            
        }];
    } completion:^(BOOL finished) {
        //放大后退出编辑模式
        _IsEdit=YES;
        MYLog(@"缩小结束");
    }];

}

#pragma mark 加载UI
-(void)loadUI{
#pragma mark 加载房间的滚动视图
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
    //设置代理
    [_roomScrollView setDelegate:self];
    for (int i=0; i<=_roomArr.count; i++)
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20+i*SCREE_WIDTH, 10, SCREE_WIDTH-20*2, SCREE_HEIGHT-64-DEVICE_VIEW_HEIGHT-10*2)];
        [view setTag:i+1000];
        [view setBackgroundColor:[UIColor redColor]];
        [view setUserInteractionEnabled:YES];
        //给view添加手势识别
        [_roomScrollView addGestureRecognizer:_pinchGesRecognize];
        //添加到房间视图数组中
        [_roomViewArr addObject:view];
        [_roomScrollView addSubview:view];
        
        if (i!=_roomArr.count)
        {
            NSDictionary *dict=_roomArr[i];
            NSString *roomName=[dict objectForKey:@"roomName"];
            ZYY_RoomView *roomView=[[ZYY_RoomView alloc]initWithNibName:@"ZYY_RoomView" bundle:nil andShowWidth:SCREE_WIDTH-20*2 andShowHeigh:SCREE_HEIGHT-64-100-10*2 roomName:roomName andLEDArr:[dict objectForKey:@"ledArray"]];
            //添加到控制器数组中
            [_roomViewControlArr addObject:roomView];
            //需添加子视图控制器
            [self addChildViewController:roomView];
            [view addSubview:roomView.view];
        }
        //设置最后一页的添加视图
        else{
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"ad"] forState:UIControlStateNormal];
            //添加触摸事件
            [btn addTarget:self action:@selector(tapAddPage) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            //自动布局
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
                make.width.height.equalTo(@150);
            }];
        }
    }
    [self.view addSubview:_roomScrollView];
#pragma mark 加载设备列表滚动的视图
    _LEDScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREE_HEIGHT-DEVICE_VIEW_HEIGHT, SCREE_WIDTH, DEVICE_VIEW_HEIGHT)];
    [_LEDScrollView setBackgroundColor:[UIColor whiteColor]];
    //设置分页
    [_LEDScrollView setPagingEnabled:YES];
    //设置滚动条
    [_LEDScrollView setShowsHorizontalScrollIndicator:YES];
    [_LEDScrollView setShowsVerticalScrollIndicator:YES];
    //设置弹簧效果
    [_LEDScrollView setBounces:YES];
    //设置滚动区域
    [_LEDScrollView setContentSize:CGSizeMake((10+DEVICE_WIDTH )*_LEDArr.count, DEVICE_VIEW_HEIGHT)];
    //当子视图越界的时候不裁减
    [_LEDScrollView setClipsToBounds:NO];
    
    [_LEDScrollView addGestureRecognizer:_longGeRecognize];
    
    [self.view addSubview:_LEDScrollView];

    for (int i=0; i<_LEDArr.count; i++)
    {
        ZYY_LEDImageView *ledImageView=[[ZYY_LEDImageView alloc]initWithFrame:CGRectMake(10+i*(10+DEVICE_WIDTH),10, DEVICE_WIDTH, 60)];
        [ledImageView setTag:10000+i];
        
        [ledImageView.nameLabel setText:[NSString stringWithFormat:@"%d",i]];

        [_LEDViewArr addObject:ledImageView];
        [_LEDScrollView addSubview:ledImageView];
        
    }
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
    //自定义删除按钮
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setFrame:CGRectMake(0, 0, 20 , 20)];
    [deleteBtn addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"icon_jian"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
}
#pragma mark  自定义导航栏按钮的触发事件
-(void)deleteBtn{
    if(_curPage<_roomArr.count)
    {
    NSString * roomName=[_roomArr[_curPage] objectForKey:@"roomName"];
    NSString *message=[NSString stringWithFormat:@"您确定要删除< %@ >这个房间吗？",roomName];
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av setTag:9000];
    [av show];
    }
}


-(void)tapBackBtn{
    //退出的时候保存房间数据到plist文件中
    [_dict setValue:_roomArr forKey:USER_ID];
    [_dict writeToFile:_filePath atomically:YES];
    
    //返回上级
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)tapAddPage{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [av setTag:8000];
    [[av textFieldAtIndex:0] setPlaceholder:@"请输入新添房间的名字"];
    [av show];
}
#pragma mark-
#pragma mark UIAlertView代理方法 完成房间视图的添加删除功能
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_roomViewArr enumerateObjectsUsingBlock:^(UIView *view , NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%ld----%ld---%@",view.tag,idx,view);
    }];
    
    
    UITextField *textFiled=[alertView textFieldAtIndex:0];
    [textFiled resignFirstResponder];
    if (alertView.tag==8000&&buttonIndex==1) {
        
        //获得最后一个添加房间的视图
        UIView *lastView=[_roomViewArr lastObject];
        NSInteger lastViewTag=lastView.tag;
        CGFloat centerX=lastView.center.x+SCREE_WIDTH;
        CGFloat centerY=lastView.center.y;
        MYLog(@"旧视图%@",lastView);
        //添加新的view
        UIView *newView=[[UIView alloc]initWithFrame:CGRectMake(20+_roomArr.count*SCREE_WIDTH, -SCREE_HEIGHT, SCREE_WIDTH-20*2, SCREE_HEIGHT-64-DEVICE_VIEW_HEIGHT-10*2)];
        [newView setTag:lastViewTag];
        
        ZYY_RoomView *roomView=[[ZYY_RoomView alloc]initWithNibName:@"ZYY_RoomView" bundle:nil andShowWidth:SCREE_WIDTH-20*2 andShowHeigh:SCREE_HEIGHT-64-100-10*2 roomName:textFiled.text andLEDArr:nil];
        //添加到控制器
        [_roomViewControlArr addObject:roomView];
        //需添加子视图控制器
        [self addChildViewController:roomView];
        //添加到视图
        [newView addSubview:roomView.view];
        [_roomScrollView addSubview:newView];
        
        
        CGFloat newViewCenterX =newView.center.x;
        //  CGFloat newViewCenterY =newView.center.y;
        
        //此处开始  _roomArr的个数才加1
        NSMutableDictionary *newDict=[NSMutableDictionary dictionary];
        //字典中存储两个内容，一个是房间名——@"roomName",另一个是设备数组——@"ledArray"
        NSMutableArray *mArr=[NSMutableArray arrayWithCapacity:1];
        [newDict setValue:mArr forKey:@"ledArray"];
        [newDict setValue:textFiled.text forKey:@"roomName"];
        
        [_roomArr addObject:newDict];
        //设置滚动区域
        [_roomScrollView setContentSize:CGSizeMake(SCREE_WIDTH*(_roomArr.count+1), SCREE_HEIGHT-64-DEVICE_VIEW_HEIGHT)];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            //让添加房间的视图完成动画
            [lastView setCenter:CGPointMake(centerX, centerY)];
            
        } completion:^(BOOL finished) {
            MYLog(@"finished---%d",finished);
            if (finished) {
                //动画完成后移除
                [lastView removeFromSuperview];
                [_roomViewArr removeLastObject];
                
                //移除完成后再次添加新的添加视图
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20+_roomArr.count*SCREE_WIDTH, 10, SCREE_WIDTH-20*2, SCREE_HEIGHT-64-DEVICE_VIEW_HEIGHT-10*2)];
                [view setTag:lastViewTag+1];
                [view setBackgroundColor:[UIColor redColor]];
              
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"ad"] forState:UIControlStateNormal];
                //添加触摸事件
                [btn addTarget:self action:@selector(tapAddPage) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
                //自动布局
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(view);
                    make.width.height.equalTo(@150);
                }];
                
                [UIView animateWithDuration:0.5f animations:^{
                    
                    [newView setCenter:CGPointMake(newViewCenterX,centerY)];
                } completion:^(BOOL finished) {
                    MYLog(@"完成添加");
                    //添加到数组 顺序 移除旧的界面后，添加新的界面，再添加最后的界面
                    [_roomViewArr addObject:newView];
                    
                    [_roomViewArr addObject:view];
                    [_roomScrollView addSubview:view];
                    
                    MYLog(@"%@-----%@",_roomArr,_roomViewArr);

                }];

            }
        }];
    }
    else if(alertView.tag ==9000 && buttonIndex==1)
    {
        MYLog(@"删除当前界面");
        //去当前视图
        UIView *currentView=_roomViewArr[_curPage];
        MYLog(@"%ld-----%@",_curPage,_roomViewArr[_curPage]);
        CGPoint currentViewPoint=currentView.center;
        [UIView animateWithDuration:0.5f animations:^{
            [currentView setCenter:CGPointMake(currentViewPoint.x, currentViewPoint.y-SCREE_HEIGHT)];
        } completion:^(BOOL finished) {
            //将视图从SCrollView上移除，数据从房间数组中删除
            [currentView removeFromSuperview];
            [_roomViewArr removeObjectAtIndex:_curPage];
            [_roomViewControlArr removeObjectAtIndex:_curPage];
            [_roomArr removeObjectAtIndex:_curPage];
            //取下个视图,由于已经从数组中移除当前视图，所以取下个界面的下表仍为_curPage
            MYLog(@"%@",_roomViewArr);
            UIView *nextView=_roomViewArr[_curPage];
            //重新更正视图的tag值
            MYLog(@"%ld---%ld---%@",_curPage+1,nextView.tag,nextView);
           
            CGPoint nextViewPoint=nextView.center;
            CGFloat pointX=nextViewPoint.x-SCREE_WIDTH;
            [UIView animateWithDuration:0.5f animations:^{
                [nextView setCenter:CGPointMake(pointX, nextViewPoint.y)];
            } completion:^(BOOL finished) {
                //形变完成后设置当前页面的tag值
                [nextView setTag:_curPage+1000];
                for (NSInteger i=(_curPage+1); i<_roomViewArr.count; i++)
                {
                    UIView *view=_roomViewArr[i];
    
                    [view setTag:(1000+i)];
                    [view setCenter:CGPointMake(pointX+(i-_curPage)*SCREE_WIDTH,nextViewPoint.y)];
                }
                [_roomScrollView setContentSize:CGSizeMake(SCREE_WIDTH*(_roomArr.count+1), SCREE_HEIGHT-64-DEVICE_VIEW_HEIGHT)];
                MYLog(@"删除完成");
                [_roomViewArr enumerateObjectsUsingBlock:^(UIView *view , NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"---%ld----%ld",view.tag,idx);
                }];
            }];
        }];
    };
}
#pragma mark  ScrollView减速完成时的代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 _curPage= scrollView.contentOffset.x / scrollView.bounds.size.width;
    MYLog(@"当前是第%ld个房间",_curPage);
}
@end
