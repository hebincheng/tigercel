//
//  ViewController.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/9.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_LoginControl.h"
#import "ZYY_HomeViewController.h"
#import "AppDelegate.h"
#import "ZYY_RegistControl.h"
#import "ZYY_GetInfoFromInternet.h"
#import "ZYY_User.h"
#import "FeThreeDotGlow.h"
#import "ZYY_MQTTConnect.h"

@interface ZYY_LoginControl ()<UITextFieldDelegate>
{
    NSUserDefaults *_userDefault;
}
@end

static NSString * acountText=@"acountText";
static NSString *codetext=@"passWordText";

@implementation ZYY_LoginControl

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化userDefault
    _userDefault=[NSUserDefaults standardUserDefaults];
    [self loadUI];
}

#pragma mark -
#pragma mark加载UI
-(void)loadUI
{
    [self setTitle:@"登陆"];
    //设置导航标题的字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    //设置键盘的代理
    [_passWordTextFiled setDelegate:self];
    [_accountTextFiled setDelegate:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    NSString *str1=[_userDefault objectForKey:acountText];
    NSString *str2=[_userDefault objectForKey:codetext];
    if (str1!=nil&&str2!=nil)
    {
        [_accountTextFiled setText:str1];
        [_passWordTextFiled setText:str2];
    }

    //NSLog(@"%@",str1);
    
}
-(void)jianpan{
    [_accountTextFiled resignFirstResponder];
    [_passWordTextFiled resignFirstResponder];
}

#pragma mark-
#pragma mark  点击事件
- (IBAction)zhuCeBtn
{
    //收起键盘
    [self jianpan];
    ZYY_RegistControl *registControl=[[ZYY_RegistControl alloc]initWithNibName:@"ZYY_RegistControl" bundle:nil];
    [self.navigationController pushViewController:registControl animated:YES];
    [self.navigationItem.backBarButtonItem setTitle:@"登陆"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
}

- (IBAction)fogetPassWord
{
    NSLog(@"我是忘记密码");
}

- (IBAction)loadCode:(UISwitch *)sender
{
   // NSLog(@"%d",sender.isOn);
}

- (IBAction)loginBtn
{
    [self jianpan];
    if (_loadCodeSwitch.isOn==NO)
    {
        NSLog(@"我把密码清0了哦");
        NSString *str=@"";
        [_userDefault setObject:str forKey:@"passWordText"];
    }
    else if(_loadCodeSwitch.isOn)
    {
        [_userDefault setObject:_accountTextFiled.text forKey:acountText];
        [_userDefault setObject:_passWordTextFiled.text forKey:codetext];
        NSLog(@"%@-我把密码存好了",[self class]);
    }
    
    //添加登陆加载动画
    FeThreeDotGlow * threeDot=[[FeThreeDotGlow alloc]initWithView:self.view blur:NO];
    [self.view addSubview:threeDot];
    [threeDot show];
    
#pragma mark  登陆接口
    [[ZYY_GetInfoFromInternet instancedObj]loginWithTelNum:_accountTextFiled.text andPassWord:_passWordTextFiled.text susseced:^{
        NSLog(@"登陆成功");
        [threeDot removeFromSuperview];
    //登陆成功后连接到MQTT服务
    [[ZYY_MQTTConnect instancedObj]connectToMQTTServerBlock:^{
       
    }];
        
    //登录成功执行的操作
    //获取用户信息（获取到的信息与登陆成功后反馈的消息是一致的 所以此处可以省略）
    //  ZYY_User *user=[ZYY_User instancedObj];
    //  [[ZYY_GetInfoFromInternet instancedObj]getUserInfoWithUserToken:user.userToken andSessionId:user.sessionId];
        //把主界面设置为根目录
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        ZYY_HomeViewController *homeVC=[[ZYY_HomeViewController alloc]init];
        //把mqtt作为全局传到下一个页面
        appDelegate.homeNavigationController=[[UINavigationController alloc]initWithRootViewController:homeVC];
        appDelegate.leftView=[[ZYY_LeftViewController alloc]init];
        appDelegate.LeftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:appDelegate.leftView andMainView:appDelegate.homeNavigationController];
        [appDelegate.window setRootViewController:appDelegate.LeftSlideVC];
    } orFailed:^{
        [threeDot removeFromSuperview];
    }];


    

}


#pragma mark-
#pragma mark  点击事件

- (IBAction)weChatLoginBtn
{
    NSLog(@"微信登陆");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_accountTextFiled)
    {
        [_passWordTextFiled becomeFirstResponder];
    }
    if (textField==_passWordTextFiled)
    {
        [_passWordTextFiled resignFirstResponder];
    }
 ;
    return YES;
}


@end
