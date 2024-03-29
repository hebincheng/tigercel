//
//  ZYY_ConnectEquipment.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/13.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  连接至设备界面

#import <UIKit/UIKit.h>

@interface ZYY_ConnectEquipment : UIViewController
//密码文本框
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
//无线加密模式触摸事件
- (IBAction)authModeBtn:(UIButton *)sender;
//无线加密模式选择框
@property (weak, nonatomic) IBOutlet UIButton *authModeButton;

//无线搜寻按钮
@property (weak, nonatomic) IBOutlet UIButton *wifiNameButton;
//无线搜寻按钮触摸事件
- (IBAction)WiFiSearch:(UIButton *)sender;
//连接按钮
- (IBAction)connectBtn;

@end
