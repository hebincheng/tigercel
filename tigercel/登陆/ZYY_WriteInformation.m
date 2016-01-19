//
//  ZYY_WriteInformation.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_WriteInformation.h"
#import "ZYY_LoginControl.h"

@interface ZYY_WriteInformation ()<UITextFieldDelegate>

@end

@implementation ZYY_WriteInformation

- (void)viewDidLoad {
    [super viewDidLoad];
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
#pragma mark 注册接口
    NSLog(@"如果注册成功就返回登陆界面");
    ZYY_LoginControl *loginView=[[ZYY_LoginControl alloc]initWithNibName:@"ZYY_LoginControl" bundle:nil];
    UINavigationController *navControl=[[UINavigationController alloc]initWithRootViewController:loginView];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:167.0/255 green:220.0/255 blue:242.0/255 alpha:1.0] ];
    [self presentViewController:navControl animated:YES completion:nil];
}
@end
