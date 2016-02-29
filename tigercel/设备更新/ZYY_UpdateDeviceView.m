//
//  ZYY_UpdateDeviceView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  升级界面

#import "ZYY_UpdateDeviceView.h"
#import "ZYY_User.h"
#import "ZYY_LED.h"
#import "ZYY_GetInfoFromInternet.h"

@interface ZYY_UpdateDeviceView ()<UITableViewDataSource>
{
    NSArray *_LEDArr;
    UITableView *_tableView;
}
@end

@implementation ZYY_UpdateDeviceView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设备更新"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    //从网络获取设备数组数据
    [[ZYY_GetInfoFromInternet instancedObj]getEquipmentListWithSessionID:[[ZYY_User instancedObj]sessionId] andUserToken:[[ZYY_User instancedObj]userToken] callBackBlock:^(NSArray *lArr) {
        //若在云端有设备列表 则赋值给LEDArr
        _LEDArr=[NSMutableArray arrayWithArray:lArr];
    }];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREE_WIDTH, SCREE_HEIGHT) style:UITableViewStylePlain];
    [_tableView setScrollEnabled:NO];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _LEDArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    ZYY_LED *led=_LEDArr[indexPath.row];
    [cell.textLabel setText:led.deviceName];
    [cell.detailTextLabel setText:led.deviceModel];
    //NSString *softStr=led.softWareNumber;
    //
    //
    //版本功能未做
    //
    //
    return cell;
}
@end
