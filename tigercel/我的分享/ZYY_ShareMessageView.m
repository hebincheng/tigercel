//
//  ZYY_ShareMessageView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  填写分享的信息

#import "ZYY_ShareMessageView.h"
#import "ZYY_GetInfoFromInternet.h"
#import "ZYY_User.h"
#import "ZYY_DeviceList.h"

@interface ZYY_ShareMessageView ()<UIAlertViewDelegate>

@end

@implementation ZYY_ShareMessageView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设备分享"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [_contentText setPlaceholder:_placeHolderText];
    MYLog(@"%@---%p",[self class],_LED);
    
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    // Do any additional setup after loading the view from its nib.
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPlaceText:(NSString *)string andWay:(NSInteger)num{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _placeHolderText =string;
        _shareWay=num;
    }
    return self;
}

#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextStepBtn
{
    ZYY_User *user=[ZYY_User instancedObj];
    switch (_shareWay)
    {
        case 0:
        {
            //用户ID
            [[ZYY_GetInfoFromInternet instancedObj]shareDeviceWithShareUserId:_contentText.text andSessionId:user.sessionId andDeviceToken:_LED.deviceToken andDeviceId:_LED.deviceId  andUserToken:user.userToken and:^(id data) {
                MYLog(@"%@",data);
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:data[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }];
            break;
        }
        case 1:
        {
            //用户名
            [[ZYY_GetInfoFromInternet instancedObj]shareDeviceWithShareUserName:_contentText.text andSessionId:user.sessionId andDeviceToken:_LED.deviceToken andDeviceId:_LED.deviceId  andUserToken:user.userToken and:^(id data) {
                MYLog(@"%@",data);
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:data[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }];
            break;
        }
        case 2:
        {
            //手机
            [[ZYY_GetInfoFromInternet instancedObj]shareDeviceWithSharePhone:_contentText.text andSessionId:user.sessionId andDeviceToken:_LED.deviceToken andDeviceId:_LED.deviceId  andUserToken:user.userToken and:^(id data) {
                MYLog(@"%@",data);
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:data[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }];
            break;
        }
        case 3:
        {
            //邮箱
            [[ZYY_GetInfoFromInternet instancedObj]shareDeviceWithShareEmail:_contentText.text andSessionId:user.sessionId andDeviceToken:_LED.deviceToken andDeviceId:_LED.deviceId  andUserToken:user.userToken and:^(id data) {
                MYLog(@"%@",data);
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:data[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark UIAlertView代理 
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    MYLog(@"%@123456",alertView.message);
    if ([alertView.message isEqualToString:@"处理成功"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
