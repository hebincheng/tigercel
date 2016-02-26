//
//  ViewController.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/9.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  登陆界面

#import "ZYY_LoginControl.h"
#import "ZYY_HomeViewController.h"
#import "AppDelegate.h"
#import "ZYY_RegistControl.h"
#import "ZYY_GetInfoFromInternet.h"
#import "ZYY_User.h"
#import "ZYY_LED.h"
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

    //MYLog(@"%@",str1);
    
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
    MYLog(@"我是忘记密码");
}

- (IBAction)loadCode:(UISwitch *)sender
{
   // MYLog(@"%d",sender.isOn);
}

- (IBAction)loginBtn
{
    [self jianpan];
    if (_loadCodeSwitch.isOn==NO)
    {
        MYLog(@"我把密码清0了哦");
        NSString *str=@"";
        [_userDefault setObject:str forKey:@"passWordText"];
    }
    else if(_loadCodeSwitch.isOn)
    {
        [_userDefault setObject:_accountTextFiled.text forKey:acountText];
        [_userDefault setObject:_passWordTextFiled.text forKey:codetext];
        MYLog(@"%@-我把密码存好了",[self class]);
    }
    
    //添加登陆加载动画
    FeThreeDotGlow * threeDot=[[FeThreeDotGlow alloc]initWithView:self.view blur:NO];
    [self.view addSubview:threeDot];
    [threeDot show];
    
#pragma mark  登陆接口
    [[ZYY_GetInfoFromInternet instancedObj]loginWithTelNum:_accountTextFiled.text andPassWord:_passWordTextFiled.text susseced:^{
        MYLog(@"登陆成功");
    //登陆成功后
    //1,连接	到MQTT服务
    [[ZYY_MQTTConnect instancedObj]connectToMQTTServerBlock:^{
       
    }];
    [[ZYY_GetInfoFromInternet instancedObj]getEquipmentListWithSessionID:[[ZYY_User instancedObj]sessionId] andUserToken:[[ZYY_User instancedObj]userToken] and:^(NSArray *lArr) {
        //获取到设备数组后移除动画
        [threeDot removeFromSuperview];
        //2,把主界面设置为根目录
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        ZYY_HomeViewController *homeVC=[[ZYY_HomeViewController alloc]initWithLEDArr:lArr];
        appDelegate.homeNavigationController=[[UINavigationController alloc]initWithRootViewController:homeVC];
        appDelegate.leftView=[[ZYY_LeftViewController alloc]init];
        appDelegate.LeftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:appDelegate.leftView andMainView:appDelegate.homeNavigationController];
        [appDelegate.window setRootViewController:appDelegate.LeftSlideVC];

    }];
        
    } orFailed:^{
        [threeDot removeFromSuperview];
    }];

}


#pragma mark-
#pragma mark  点击事件

- (IBAction)weChatLoginBtn
{
    MYLog(@"微信登陆");
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
