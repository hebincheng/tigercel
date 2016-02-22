//
//  ZYY_HomeViewController.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  主界面-设备列表界面

#import "ZYY_HomeViewController.h"
#import "AppDelegate.h"
#import "ZYY_HomeTableViewCell.h"
#import "ZYY_LeftViewController.h"
#import "ZYY_ConnectEquipment.h"
#import "ZYY_EquipmentDetailVie.h"
#import "ZYY_LED.h"
#import "ZYY_User.h"
#import "ZYY_GetInfoFromInternet.h"
#import "FeThreeDotGlow.h"
#import "ZYY_MQTTConnect.h"


@interface ZYY_HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //appDelegate代理
    AppDelegate *_homeAD;
    //灯光数组
    NSMutableArray *_LEDArr;
    NSString *_filePath;
    //程序运行时钟
    CADisplayLink *_runTime;
    //步数
    NSInteger _step;
}
@end

static NSString *cellID=@"cellID";

@implementation ZYY_HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    if (_LEDArr==nil)
    {
        _LEDArr=[NSMutableArray array];
    }
    [[ZYY_GetInfoFromInternet instancedObj]getEquipmentListWithSessionID:[[ZYY_User instancedObj]sessionId] andUserToken:[[ZYY_User instancedObj]userToken] and:^(NSArray *lArr) {
        //若在云端有设备列表 则赋值给LEDArr
        _LEDArr=[NSMutableArray arrayWithArray:lArr];
        [_tableView reloadData];
    }];
    //_filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"led.data"];
    //已添加的led设备数组
    //_LEDArr=[NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.LeftSlideVC setPanEnabled:YES];
    [_tableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    //调用单例 页面消失后 禁止滑动
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.LeftSlideVC setPanEnabled:NO];
}
-(void)step{
    _step++;
//    MQTTClient mqtt=[[ZYY_MQTTConnect instancedObj]MQTTClint];
//    if (_step%(20*60)==0)
//    {
//        MQTTClient_retry();
//        NSLog(@"11111");
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化全局appdelegate
    _homeAD=(AppDelegate *)[[UIApplication sharedApplication] delegate];
#pragma mark 由于之前设备做的本地库保存  现在是从网络获取并刷新 所以暂时有待解决本地与网络之间的冲突
    _step=0;
    _runTime=[CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    [_runTime addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self loadUI];
    [self buildSceneUserDefault];
    //订阅设备
    for (ZYY_LED *led in _LEDArr)
    {
        [[ZYY_MQTTConnect instancedObj]subscribeDeviceWithDeviceToken:led.deviceToken];
    }
}
#pragma mark-
#pragma mark如果设备第一次登陆登陆 则将默认的照明模式数组 和氛围模式数据存储
-(void)buildSceneUserDefault{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"first"]==nil)
    {
        [userDefault setObject:@"1" forKey:@"first"];
        //存储默认的照明模式设置arr @[@80,@20,@30] 第一个亮度 第二个色温 第三个呼吸速度
        NSArray *zhaoMingSetArr=@[@[@80,@20,@30],@[@70,@20,@60],@[@50,@50,@30],@[@56,@60,@10],@[@87,@20,@38]];
        NSArray *zhaoMingtitleArr=@[@"休闲",@"读书",@"节奏",@"柔和",@"动感"];
        //存储默认的氛围模式的设置arr @[@[@200,@150,@100],@20,@83] 第一个代表灯光颜色 R G B三元素 第二个代表色温  第三个呼吸速度
        NSArray *fenWeiSetArr=@[@[@[@200,@150,@100],@20,@83],@[@[@100,@50,@100],@20,@35],@[@[@200,@170,@140],@90,@80],@[@[@20,@60,@240],@20,@37],@[@[@200,@100,@130],@20,@36]];
        NSArray *fenWeiTitleArr=@[@"舞动",@"低调",@"狂欢",@"安静",@"音乐"];
        [userDefault setObject:zhaoMingSetArr forKey:@"zhaoMingSetArr"];
        
        [userDefault setObject:zhaoMingtitleArr forKey:@"zhaoMingtitleArr"];
        
        [userDefault setObject:fenWeiSetArr forKey:@"fenWeiSetArr"];
        
        [userDefault setObject:fenWeiTitleArr forKey:@"fenWeiTitleArr"];
    }
}


#pragma mark-
#pragma mark加载UI
-(void)loadUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [self setTitle:@"若有智能"];
    //设置标题字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    //设置左按钮
    UIButton *left=[UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 15 , 15)];
    [left setBackgroundImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftBtnResponse) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:left];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
#pragma mark 自定义右侧barbutton
    UIButton *right=[UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(0, 0, 20 , 20)];
    [right addTarget:self action:@selector(rightBtnResponse) forControlEvents:UIControlEventTouchUpInside];
    [right setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:right];
    
    UIButton *right1=[UIButton buttonWithType:UIButtonTypeCustom];
    [right1 setFrame:CGRectMake(0, 0, 20 , 20)];
    [right1 addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [right1 setBackgroundImage:[UIImage imageNamed:@"icon_jian"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn1=[[UIBarButtonItem alloc]initWithCustomView:right1];
    
    [self.navigationItem setRightBarButtonItems:@[rightBtn,rightBtn1]];
    //设置_tableView属性
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //设置不可滚动
    [_tableView setScrollEnabled:NO];
    //在有NavationBar的情况下设置自动尺寸 此时y的0  即为父视图的64
    [_tableView setAutoresizesSubviews:YES];
    [_tableView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //注册nib
    [_tableView setUserInteractionEnabled:YES];
    [_tableView registerNib:[UINib nibWithNibName:@"ZYY_HomeTableViewCell"  bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
}

#pragma mark-
#pragma mark协议方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
   //     [NSKeyedArchiver archiveRootObject:_LEDArr toFile:_filePath];
        //删除设备信息
        NSLog(@"%@",_LEDArr);
        [[ZYY_GetInfoFromInternet instancedObj]deleteEquipmentWithSessiosID:[[ZYY_User instancedObj] sessionId] andDeviceToken:[_LEDArr[indexPath.row] deviceToken] andUserToken:[[ZYY_User instancedObj] userToken]andBlock:^{
            //服务器上删除成功后 删除本地缓存数组中对应的设备
            [_LEDArr removeObjectAtIndex:indexPath.row];
            //删除成功则刷新表格
            [_tableView reloadData];
            [_tableView setEditing:NO animated:YES];
        }];
       // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _LEDArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYY_HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (_LEDArr!=nil)
    {
        ZYY_LED *ledInformation=_LEDArr[indexPath.row];
        [cell.nameLabel setText:ledInformation.deviceName];
        [cell.modeLabel setText:ledInformation.currentSceneName];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加登陆加载动画
    FeThreeDotGlow * threeDot=[[FeThreeDotGlow alloc]initWithView:self.view blur:NO];
    [self.view addSubview:threeDot];
    [threeDot show];
#pragma mark调用函数获取设备信息
    [[ZYY_MQTTConnect instancedObj]getDeviceInfoAndConnectToMQTTWithDeviceToken:[_LEDArr[indexPath.row] deviceToken] block:^(id data){
        [threeDot removeFromSuperview];
        NSLog(@"%@",data);
    }];
//    ZYY_EquipmentDetailVie *equipmentView=[[ZYY_EquipmentDetailVie alloc]initWithNibName:@"ZYY_EquipmentDetailVie" bundle:nil andLEDInformation:_LEDArr[indexPath.row] andNumber:indexPath.row+1];
//    [self.navigationController pushViewController:equipmentView animated:YES];
}
//返回删除模式
- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark-
#pragma mark触摸事件
-(void)deleteBtn:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected==YES)
    {
        [_tableView setEditing:YES animated:YES];
    }
    else{
        [_tableView setEditing:NO animated:YES];
    }
}
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
   // NSLog(@"asdasd");
    if(view==_tableView)
        return NO;
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
   // NSLog(@"11");
    return NO;
}

-(void)rightBtnResponse
{
    ZYY_ConnectEquipment *connectView=[[ZYY_ConnectEquipment alloc]initWithNibName:@"ZYY_ConnectEquipment" bundle:nil];
    [self.navigationController pushViewController:connectView animated:YES];
}
-(void)leftBtnResponse
{
    if (_homeAD.LeftSlideVC.closed==YES)
    {
        [_homeAD.LeftSlideVC openLeftView];
    }
    else if(_homeAD.LeftSlideVC.closed==NO)
    {
        [_homeAD.LeftSlideVC closeLeftView];
    }
}

@end
