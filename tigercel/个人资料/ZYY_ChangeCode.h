//
//  ZYY_ChangeCode.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/12.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYY_ChangeCode : UIViewController
//旧密码
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordText;
//新密码
@property (weak, nonatomic) IBOutlet UITextField * Password;
//确认新密码
@property (weak, nonatomic) IBOutlet UITextField *checkNewPassword;
- (IBAction)changeCode;

@end
