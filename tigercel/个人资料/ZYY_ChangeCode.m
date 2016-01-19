//
//  ZYY_ChangeCode.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/12.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ChangeCode.h"
#import "ZYY_RetrievePasswordView.h"

@interface ZYY_ChangeCode ()
{
    NSUserDefaults *_userDefaulet;
}
@end

@implementation ZYY_ChangeCode

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"修改密码"];
    _userDefaulet=[NSUserDefaults standardUserDefaults];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
   // UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(tapRightBtn)];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 80 , 20)];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [rightBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(tapRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
-(void)tapRightBtn
{
    ZYY_RetrievePasswordView *retrieve=[[ZYY_RetrievePasswordView alloc]initWithNibName:@"ZYY_RetrievePasswordView" bundle:nil];
    [self.navigationController pushViewController:retrieve animated:YES];
}


- (IBAction)changeCode {
    NSString *str=[_userDefaulet objectForKey:@"passWordText"];
    //NSLog(@"%@",str);
    if (![str isEqualToString: _oldPasswordText.text])
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不对，请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
    }
    else
    {
        if (_Password.text.length<6||_Password.text.length>20)
        {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"新密码不符合要求，请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
        }
        else if (![_Password.text isEqualToString:_checkNewPassword.text])
        {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不一致，请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
        }
        else
        {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
            [_userDefaulet setObject:_Password.text forKey:@"passWordText"];
        }
    }
}
@end
