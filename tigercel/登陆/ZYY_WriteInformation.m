//
//  ZYY_WriteInformation.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  完善信息界面

#import "ZYY_WriteInformation.h"
#import "ZYY_LoginControl.h"
#import "ZYY_GetInfoFromInternet.h"

@interface ZYY_WriteInformation ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation ZYY_WriteInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    MYLog(@"%@",_authCode);
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"完善信息"];
   
//    [self.navigationItem.leftBarButtonItem setTitleTextAttributes :[ NSDictionary dictionaryWithObjectsAndKeys :[ UIFont fontWithName : @"返回" size : 17.0 ], NSFontAttributeName , [ UIColor greenColor ], NSForegroundColorAttributeName ,nil ] forState : UIControlStateNormal ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark 注册按钮触摸事件
- (IBAction)registBtn
{
    
    
    if (_firstCode.text.length<5||_firstCode.text.length>16)
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的密码不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
    else if (![_firstCode.text isEqualToString:_secondCode.text])
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
    else{
#pragma mark 注册接口
        //把可能含中文的编码成utf8格式
        NSString *nameStr=[_userNameText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[ZYY_GetInfoFromInternet instancedObj]registAccountWithEmailAddress1:_mailText.text andPassword:_firstCode.text andUserName:nameStr andMobileNumber:_telNumber andAuthCode:_authCode and:^(id data)
        {
           //注册成功才会执行块函数 返回登陆界面
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message: data delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }];
    }
}
#pragma mark alertView的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ZYY_LoginControl *loginView=[[ZYY_LoginControl alloc]initWithNibName:@"ZYY_LoginControl" bundle:nil];
    UINavigationController *navControl=[[UINavigationController alloc]initWithRootViewController:loginView];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:167.0/255 green:220.0/255 blue:242.0/255 alpha:1.0] ];
    [self presentViewController:navControl animated:YES completion:nil];
}

@end
