//
//  ZYY_ChangeNameView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  改变设备名字界面

#import "ZYY_ChangeNameView.h"

@interface ZYY_ChangeNameView ()

@end

@implementation ZYY_ChangeNameView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"修改名称"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
}
#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeBtn
{
    if (_equipmentName.text.length>=4&&_equipmentName.text.length<=16)
    {
        [_delegate resetProjectNameWithName:_equipmentName.text];
        //[userDeafults setObject:_equipmentName.text forKey:@"projectName"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"名称不符合要求，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }
    //返回上级页面
}
@end
