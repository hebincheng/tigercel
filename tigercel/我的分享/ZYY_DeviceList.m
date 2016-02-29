//
//  ZYY_DeviceList.m
//  tigercel
//
//  Created by 虎符通信 on 16/2/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  设备列表界面

#import "ZYY_DeviceList.h"
#import "ZYY_GetInfoFromInternet.h"
#import "ZYY_User.h"
#import "ZYY_LED.h"
#import "ZYY_DeviceListCell.h"
#import "ZYY_UserListView.h"

@interface ZYY_DeviceList ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //设备列表数组
    NSArray *_LEDArr;
}
@end

static NSString *deviceListCellID=@"deviceListCellID";

@implementation ZYY_DeviceList

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ZYY_GetInfoFromInternet instancedObj]getEquipmentListWithSessionID:[[ZYY_User instancedObj]sessionId] andUserToken:[[ZYY_User instancedObj]userToken] callBackBlock:^(NSArray *lArr) {
        //若在云端有设备列表 则赋值给LEDArr
        _LEDArr=[NSMutableArray arrayWithArray:lArr];
        [_tableView reloadData];
    }];
    
    [self loadUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadUI{
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [self setTitle:@"设备分享列表"];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREE_WIDTH,SCREE_HEIGHT)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //设置不可滚动
    [_tableView setScrollEnabled:NO];
    //在有NavationBar的情况下设置自动尺寸 此时y的0  即为父视图的64
    [_tableView setAutoresizesSubviews:YES];
    [_tableView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:@"ZYY_DeviceListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:deviceListCellID];
    [self.view addSubview:_tableView];
    
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
}
#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-
#pragma marktableView协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _LEDArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYY_DeviceListCell *cell=[tableView dequeueReusableCellWithIdentifier:deviceListCellID];
    //设置点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //显示设备名字和设备模式
    ZYY_LED *led=_LEDArr[indexPath.row];

    [cell.deviceNameLabel setText:led.deviceName];
    [cell.deviceModeLabel setText:led.deviceModel];
    
    //自定义分割线
    UIView *speView=[[UIView alloc]initWithFrame:CGRectMake(0, 68, [UIScreen mainScreen].bounds.size.width, 1)];
    [speView setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:speView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYY_LED *led=_LEDArr[indexPath.row];
    ZYY_User *user=[ZYY_User instancedObj];
    [[ZYY_GetInfoFromInternet instancedObj]getUserListWithSessionId:user.sessionId andUserToken:user.userToken andDeviceToken:led.deviceToken block:^(id data) {
        MYLog(@"%@",data);
        //根据获得的分享用户 来初始化界面
        NSArray *listArr=[[ZYY_User alloc] getUserArrWithArr:data];
        ZYY_UserListView *sharedUserView=[[ZYY_UserListView alloc]initWithUserArr:listArr andLED:led];
        MYLog(@"%@---%p",[self class],led);
        [self.navigationController pushViewController:sharedUserView animated:YES];
    }];
}

@end
