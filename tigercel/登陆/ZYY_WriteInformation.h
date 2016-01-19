//
//  ZYY_WriteInformation.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  完善信息界面

#import <UIKit/UIKit.h>

@interface ZYY_WriteInformation : UIViewController
//用户名
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
//注册的密码
@property (weak, nonatomic) IBOutlet UITextField *firstCode;
//再次确认的密码
@property (weak, nonatomic) IBOutlet UITextField *secondCode;
//邮箱文本
@property (weak, nonatomic) IBOutlet UITextField *mailText;
//注册触摸事件
- (IBAction)registBtn;

@end
