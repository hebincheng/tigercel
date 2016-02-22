//
//  ZYY_LeftViewController.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_LeftViewController.h"
#import "ZYY_HomeViewController.h"
#import "ZYY_MyInformationView.h"
#import "ZYY_AboutView.h"
#import "ZYY_ReBackView.h"
#import "ZYY_RoomView.h"
#import "ZYY_UpdateDeviceView.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "ZYY_DeviceList.h"
#import "ZYY_User.h"
#import "UIButton+WebCache.h"

@interface ZYY_LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_menuTitleArr;
    NSArray *_menuImageArr;

    //用户名Label
    UILabel *_nameLabe;
    //手机号Label
    UILabel *_telNumberLabe;
    //控制器数组
    NSArray *_controllers;
}
@end

static NSString *cellID=@"tableViewCellID";

@implementation ZYY_LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self loadData];
}
#pragma mark-
#pragma mark 加载UI
-(void)loadUI
{
    //设置view的背景视图
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [bgImageView setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:bgImageView];
    //设置tableView属性
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    //设置无分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设置不可滚动
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
}
#pragma mark-
#pragma mark 加载数据
-(void)loadData
{
    _menuTitleArr=@[@"我的房间",@"设备更新",@"设备分享",@"我的反馈",@"关于"];
    
    UIImage *image1=[UIImage imageNamed:@"fangjian"];
    UIImage *image2=[UIImage imageNamed:@"icon_sbgx"];
    UIImage *image3=[UIImage imageNamed:@"icon_gy"];
    UIImage *image4=[UIImage imageNamed:@"icon_wdfk"];
    UIImage *image5=[UIImage imageNamed:@"icon_gy"];
    _menuImageArr=@[image1,image2,image3,image4,image5];
    ZYY_AboutView *aboutView=[[ZYY_AboutView alloc]initWithNibName:@"ZYY_AboutView" bundle:nil];
    ZYY_ReBackView *reback=[[ZYY_ReBackView alloc]initWithNibName:@"ZYY_ReBackView" bundle:nil];
    ZYY_DeviceList *deviceList=[[ZYY_DeviceList alloc]initWithNibName:@"ZYY_DeviceList" bundle:nil];
    ZYY_UpdateDeviceView *upDateView=[[ZYY_UpdateDeviceView alloc]initWithNibName:@"ZYY_UpdateDeviceView" bundle:nil];
    ZYY_RoomView *roomView=[[ZYY_RoomView alloc]initWithNibName:@"ZYY_RoomView" bundle:nil];
    _controllers=@[roomView,upDateView,deviceList,reback,aboutView];
    
}
#pragma mark-
#pragma mark 点击响应事件
-(void)tapImageBtn{
    ZYY_MyInformationView *myInformationView=[[ZYY_MyInformationView alloc]initWithNibName:@"ZYY_MyInformationView" bundle:nil];
    AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC closeLeftView];
    [app.homeNavigationController pushViewController:myInformationView animated:YES];
    [app.LeftSlideVC setPanEnabled:NO];
}

#pragma mark-
#pragma mark tableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuTitleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //设置cell单元格样式
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //设置cell点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //设置cell.textLabel的内容
    [cell.textLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setText:_menuTitleArr[indexPath.row]];
    [cell.imageView setImage:_menuImageArr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 250;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    //设置头像自动布局
    _imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ZYY_User *user=[ZYY_User instancedObj];
    [_imageBtn setBackgroundImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    if (![user.titleMultiUrl isEqualToString:@""])
    {
           [_imageBtn sd_setImageWithURL:[NSURL URLWithString:user.titleMultiUrl] forState:UIControlStateNormal];
    }
   

    //设置btn点击样式
    [_imageBtn setShowsTouchWhenHighlighted:YES];
    [_imageBtn addTarget:self action:@selector(tapImageBtn) forControlEvents:UIControlEventTouchUpInside];
    //UIImageView *imageView=[[UIImageView alloc]init];
    [_imageBtn.layer setCornerRadius:50];
    [_imageBtn.layer setMasksToBounds:YES];
    [_imageBtn setBackgroundColor:[UIColor redColor]];
    [view addSubview:_imageBtn];
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.top.equalTo(view.mas_top).offset(50);
        make.leading.equalTo(view.mas_leading).offset(35);
    }];
    //设置用户名自动布局
    _nameLabe=[[UILabel alloc]init];
    [_nameLabe setText:user.userName];
    [_nameLabe setFont:[UIFont systemFontOfSize:14]];
    [_nameLabe setTextColor:[UIColor whiteColor]];
    [_nameLabe setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:_nameLabe];
    [_nameLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.top.equalTo(_imageBtn.mas_bottom).offset(10);
        make.centerX.equalTo(_imageBtn.mas_centerX);
    }];
    //设置电话自动布局
    _telNumberLabe=[[UILabel alloc]init];
    [_telNumberLabe setText:user.mobileNumber];
    [_telNumberLabe setFont:[UIFont systemFontOfSize:14]];
    [_telNumberLabe setTextColor:[UIColor whiteColor]];
    [_telNumberLabe setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:_telNumberLabe];
    [_telNumberLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.top.equalTo(_nameLabe.mas_bottom);
        make.centerX.equalTo(_imageBtn.mas_centerX);
    }];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",_menuTitleArr[indexPath.row]);
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.LeftSlideVC closeLeftView];

    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]init];
    [barBtn setTitle:@"返回"];
    appDelegate.homeNavigationController.navigationItem.backBarButtonItem=barBtn;
    [appDelegate.homeNavigationController pushViewController:_controllers[indexPath.row] animated:YES];
        [appDelegate.LeftSlideVC setPanEnabled:NO];
}
@end
