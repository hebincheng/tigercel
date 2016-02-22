//
//  ZYY_UserListView.m
//  tigercel
//
//  Created by 虎符通信 on 16/2/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_UserListView.h"
#import "ZYY_DeviceListCell.h"
#import "ZYY_User.h"

@interface ZYY_UserListView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //用户数组
    NSArray *_userArr;
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
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
}
-(id)initWithUserArr:(NSArray *)userArr{
    self=[super init];
    if (self!=nil)
    {
        //将用户数组传过来
        _userArr=[NSArray arrayWithArray:userArr];
    }
    return self;
}

#pragma mark 添加分享用户按钮事件
-(void)tapRightBtn
{
    NSLog(@"添加");
}

#pragma mark  tabelViewd代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYY_DeviceListCell *cell=[tableView dequeueReusableCellWithIdentifier:userListCellID];
    ZYY_User *user=_userArr[indexPath.row];
    //此处由于布局与设备列表布局一样，因此不再另外创建自定义cell
    [cell.deviceModeLabel setText:user.userId];
    [cell.deviceNameLabel setText:user.userName];
    return cell;
}
@end
