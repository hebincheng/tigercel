//
//  ZYY_RegistControl.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/9.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  注册信息界面

#import <UIKit/UIKit.h>

@interface ZYY_RegistControl : UIViewController

//电话文本框
@property (weak, nonatomic) IBOutlet UITextField *telPhoneText;
//验证码文本框
@property (weak, nonatomic) IBOutlet UITextField *checkText;
//发送验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
//确认勾选按钮
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//发送验证码触摸事件
- (IBAction)sendBtn:(UIButton *)sender;
//下一步
- (IBAction)nextStepBtn;
//勾选按钮触摸事件
- (IBAction)agreeBtn:(UIButton *)sender;
//注册协议触摸事件
- (IBAction)protocolBtn;

@end
