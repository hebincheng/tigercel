//
//  ZYY_UserListView.m
//  tigercel
//
//  Created by 虎符通信 on 16/2/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  用户界面

#import "ZYY_UserListView.h"
#import "ZYY_DeviceListCell.h"
#import "ZYY_User.h"
#import "ZYY_LED.h"
#import "ZYY_ChooseShareWayView.h"
#import "ZYY_GetInfoFromInternet.h"

@interface ZYY_UserListView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //用户数组
    NSMutableArray *_userArr;
    //选中的设备
    ZYY_LED *_LED;
}
@end

static NSString *userListCellID=@"userListCellID";

@implementation ZYY_UserListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}


-(void)loadUI{
    [self setTitle:@"用户列表"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    
    //tableView 的设置
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREE_WIDTH, SCREE_HEIGHT) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAutoresizesSubviews:YES];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"ZYY_DeviceListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:userListCellID];
    [self.view addSubview:_tableView];
    //添加分享用户的按钮
    UIButton *right=[UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(0, 0, 20 , 20)];
    [right addTarget:self action:@selector(tapRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [right setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem=rightBtn;
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
}
-(id)initWithUserArr:(NSArray *)userArr andLED:(ZYY_LED *)LED{
    self=[super init];
    if (self!=nil)
    {
        //将用户数组传过来
        _userArr=[NSMutableArray arrayWithArray:userArr];
        //将选中的LED传来过
        if (_LED==nil)
        {
            _LED=[[ZYY_LED alloc]init];
        }
        _LED=LED;
        MYLog(@"%@---%p",[self class],_LED);
    }
    return self;
}
#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加分享用户按钮事件
-(void)tapRightBtn
{
    ZYY_ChooseShareWayView *chooseShareView=[[ZYY_ChooseShareWayView alloc]init];
    //将LED设备传至下一个数组
    chooseShareView.LED=_LED;
    
    [self.navigationController pushViewController:chooseShareView animated:YES];
}

#pragma mark  tabelViewd代理方法
//删除的方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYY_User *user=_userArr[indexPath.row];
    //注意  此处的sessionID/loginUserToken是当前登陆用户的，shareUserToken是待删除用户的
    [[ZYY_GetInfoFromInternet instancedObj]deleteSharedUserWithSessionId: USER_SESSIONID andLoginUserToken:USER_TOKEN andSharedUserToken:user.userToken andDeviceToken:_LED.deviceToken block:^(id data){
        //网络删除成功后 ，删除本地数组并刷新
        [_userArr removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYY_DeviceListCell *cell=[tableView dequeueReusableCellWithIdentifier:userListCellID];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ZYY_User *user=_userArr[indexPath.row];
    
    //此处由于布局与设备列表布局一样，因此不再另外创建自定义cell
    [cell.deviceModeLabel setText:user.userId];
    [cell.deviceNameLabel setText:user.userName];
    //自定义分割线
    UIView *speView=[[UIView alloc]initWithFrame:CGRectMake(0, 68, SCREE_WIDTH, 1)];
    [speView setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:speView];
    return cell;
}
@end
