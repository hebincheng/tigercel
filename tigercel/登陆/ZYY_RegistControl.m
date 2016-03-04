//
//  ZYY_RegistControl.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/9.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  注册界面

#import "ZYY_RegistControl.h"
#import "ZYY_WriteInformation.h"
#import "ZYY_ProtocolView.h"
#import "ZYY_GetInfoFromInternet.h"

@interface ZYY_RegistControl ()<UITextFieldDelegate>
{
    NSDate *_date;
    NSTimer *_timeCalculator;
    NSUserDefaults *_userDefaults;
}
@end

@implementation ZYY_RegistControl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"注册"];
    [_sendButton setSelected:NO];
    
    _userDefaults=[NSUserDefaults standardUserDefaults];
    
    //设置被点击的时候无变灰效果
    [_sendButton setAdjustsImageWhenHighlighted:NO];
    [_sureButton setAdjustsImageWhenHighlighted:NO];
    
    [_telPhoneText setDelegate:self];
    [_checkText setDelegate:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    //自定义返回按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    // [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapBack) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
}

-(void)tapBack{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark-
#pragma mark 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_checkText resignFirstResponder];
    [_telPhoneText resignFirstResponder];
    return YES;
}

-(void)setUserInformation
{
    NSString *str1=[_userDefaults objectForKey:@"telPhoneText"];
    NSString *str2=[_userDefaults objectForKey:@"_checkText"];
    [_telPhoneText setText:str1];
    [_checkText setText:str2];
}

#pragma mark-
#pragma mark  触摸事件
- (IBAction)sendBtn:(UIButton *)sender
{
    if (sender.selected==NO)
    {
        if(_telPhoneText.text.length!=11){
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
        }
        else{
#pragma mark  发送验证码接口
            [[ZYY_GetInfoFromInternet instancedObj]sendYZMWithTelNumber:_telPhoneText.text];
            MYLog(@"向%@发送验证码",_telPhoneText.text);
            [sender setSelected:YES];
            [_sendButton setTitle:@"90秒" forState:UIControlStateNormal];
            _date=[NSDate date];
            _timeCalculator=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scheduledTime) userInfo:nil repeats:YES];
        }
    }
}
//时钟函数
-(void)scheduledTime
{
    NSTimeInterval t=[_timeCalculator.fireDate timeIntervalSinceDate:_date];
    int n=(int)t;
    if(n<90)
    {
         NSString *miao=[NSString stringWithFormat:@"%d秒",90-n];
        [_sendButton setTitle:miao forState:UIControlStateNormal];
    }
    else
    {
        [_sendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [_sendButton setSelected:NO];
    }
}

- (IBAction)nextStepBtn
{
    if (_sureButton.selected)
    {
        MYLog(@"已阅读协议，进入下一步");
        #pragma mark  待填写确认验证码是否正确接口
        ZYY_WriteInformation *writeViewControl=[[ZYY_WriteInformation alloc]init];
        writeViewControl.authCode=_checkText.text;
        writeViewControl.telNumber=_telPhoneText.text;
        [self.navigationController pushViewController:writeViewControl animated:YES];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
    }
    else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未同意协议" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
        [av show];
    }
}

- (IBAction)agreeBtn:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
    }
    else
    {
      [sender setImage:[UIImage imageNamed:@"login_cho_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)protocolBtn
{
    [_userDefaults setObject:_telPhoneText.text forKey:@"telPhoneText"];
    [_userDefaults setObject:_checkText.text forKey:@"_checkText"];
    ZYY_ProtocolView *protocolView=[[ZYY_ProtocolView alloc]initWithNibName:@"ZYY_ProtocolView" bundle:nil];
    [self.navigationController pushViewController:protocolView animated:YES];
}
@end
