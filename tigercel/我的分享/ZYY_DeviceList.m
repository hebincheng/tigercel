//
//  ZYY_DeviceList.m
//  tigercel
//
//  Created by 虎符通信 on 16/2/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_DeviceList.h"
#import "ZYY_GetInfoFromInternet.h"
#import "ZYY_User.h"
#import "ZYY_LED.h"
#import "ZYY_DeviceListCell.h"
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
    [[ZYY_GetInfoFromInternet instancedObj]getEquipmentListWithSessionID:[[ZYY_User instancedObj]sessionId] andUserToken:[[ZYY_User instancedObj]userToken] and:^(NSArray *lArr) {
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
    [_tableView registerNib:[UINib nibWithNibName:@"ZYY_DeviceListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:deviceListCellID];
    [self.view addSubview:_tableView];
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
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYY_LED *led=_LEDArr[indexPath.row];
    ZYY_User *user=[ZYY_User instancedObj];
    __block NSArray *userAr=[NSArray array];
    [[ZYY_GetInfoFromInternet instancedObj]getUserListWithSessionId:user.sessionId andUserToken:user.userToken andDeviceToken:led.deviceToken block:^(id data) {
        userAr=[NSArray arrayWithArray:data];
    }];
}

@end
