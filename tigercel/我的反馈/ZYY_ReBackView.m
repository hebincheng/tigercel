//
//  ZYY_ReBackView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ReBackView.h"
#import "ZYY_GetInfoFromInternet.h"
#import "ZYY_User.h"
@interface ZYY_ReBackView ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation ZYY_ReBackView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0]];
    [_contentTextView setDelegate:self];
    [_contentTextView setText:@"请输入您问题的详细描述"];
    [_contentTextView setTextColor:[UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1.0]];
    [_titleOfContentText setDelegate:self];
    [_titleOfContentText setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"我的反馈"];
}
#pragma mark -
#pragma mark代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您问题的详细描述"])
    {
        [textView setTextColor:[UIColor blackColor]];
        textView.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length>=200)
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入两百字以内的内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        return NO;
    }
    else
        return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length<=200)
    {
        [_numberOfCharacterLabel setText:[NSString stringWithFormat:@"(%ld/200)",(unsigned long)textView.text.length]];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length<1)
    {
        [textView setTextColor:[UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1.0]];
        [textView setText:@"请输入您问题的详细描述"];
    }
}

-(void)clossView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtn
{
    //发送反馈
    [[ZYY_GetInfoFromInternet instancedObj]feddBackWithComment:_contentTextView.text andTitle:_titleOfContentText.text andUserID:[[ZYY_User instancedObj] sessionId] and:^{
        NSLog(@"反馈发送成功");
        [self clossView];
    }];
}

@end
