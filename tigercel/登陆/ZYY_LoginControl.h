//
//  ViewController.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/9.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  登陆界面

#import <UIKit/UIKit.h>

@interface ZYY_LoginControl : UIViewController

//注册
- (IBAction)zhuCeBtn;

//忘记密码
- (IBAction)fogetPassWord;

//密码保存选择开关
- (IBAction)loadCode:(UISwitch *)sender;

//登陆按钮
- (IBAction)loginBtn;
//微信登陆
- (IBAction)weChatLoginBtn;

//密码保存选择
@property (weak, nonatomic) IBOutlet UISwitch *loadCodeSwitch;

//账号输入框
@property (weak, nonatomic) IBOutlet UITextField *accountTextFiled;
//密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passWordTextFiled;

@end
