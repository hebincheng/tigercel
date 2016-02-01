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
#import "MQTTClient.h"
#import "MQTTClientPersistence.h"

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
        [self connectToMQTT];
    //登录成功执行的操作
    //获取用户信息（获取到的信息与登陆成功后反馈的消息是一致的 所以此处可以省略）
    //  ZYY_User *user=[ZYY_User instancedObj];
    //  [[ZYY_GetInfoFromInternet instancedObj]getUserInfoWithUserToken:user.userToken andSessionId:user.sessionId];
        //把主界面设置为根目录
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        ZYY_HomeViewController *homeVC=[[ZYY_HomeViewController alloc]init];
        appDelegate.homeNavigationController=[[UINavigationController alloc]initWithRootViewController:homeVC];
        appDelegate.leftView=[[ZYY_LeftViewController alloc]init];
        appDelegate.LeftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:appDelegate.leftView andMainView:appDelegate.homeNavigationController];
        [appDelegate.window setRootViewController:appDelegate.LeftSlideVC];
    } orFailed:^{
        [threeDot removeFromSuperview];
    }];


    

}


#pragma mark  连接到mqttServer
-(void)connectToMQTT
{
    
//    struct Options
//    {
//        char* connection;         /**< connection to system under test. */
//        char** haconnections;
//        int hacount;
//        int verbose;
//        int test_no;
//        int MQTTVersion;
//        int iterations;
//    } options =
//    {
//        //"tcp://m2m.eclipse.org:1883",
//        "tcp://192.168.3.49:1243",
//        //"tcp://192.168.12.157:1243",
//        NULL,
//        0,
//        0,
//        0,
//        MQTTVERSION_DEFAULT,
//        1,
//    };
//    
//    
//    MQTTClient c;
//    MQTTClient_connectOptions opts = MQTTClient_connectOptions_initializer;
//    MQTTClient_willOptions wopts = MQTTClient_willOptions_initializer;
//    int subsqos = 2;
//    int rc = 0;
//    char* test_topic = "/control_response/user/uuuuuuuuuussssssssssrrrrrr000213/device/appliance/lamp/";
//  // int failures = 0;
//    
//    
//    opts.keepAliveInterval = 20;
//    opts.cleansession = 1;
//    opts.username = "uuuuuuuuuussssssssssrrrrrr000213";
//    opts.password = "papapapa";
//    opts.MQTTVersion = options.MQTTVersion;
//    if (options.haconnections != NULL)
//    {
//        opts.serverURIs = options.haconnections;
//        opts.serverURIcount = options.hacount;
//    }
//    
//    opts.will = &wopts;
//    opts.will->message = "will message";
//    opts.will->qos = 1;
//    opts.will->retained = 0;
//    opts.will->topicName = "will topic";
//    opts.will = NULL;
//    
//    
//    
//    
//    
//    
//    rc = MQTTClient_create(&c, options.connection, "single_threaded_test",
//                           MQTTCLIENT_PERSISTENCE_DEFAULT, NULL);
//    if (rc != MQTTCLIENT_SUCCESS)
//    {
//        printf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
//        MQTTClient_destroy(&c);
//    }
//    
//    
//    printf("@@@@@@@@@@@@@@@@@Connecting start\n");
//    printf("connection : %s\n", options.connection);
//    rc = MQTTClient_connect(c, &opts);
//    printf("@@@@@@@@@@@@@@@@@Connecting finish and start subscribe\n\n\n");
//    rc = MQTTClient_subscribe(c, test_topic, subsqos);
//    printf("@@@@@@@@@@@@@@@@@subscribe finish\n\n\n");
//    
//
//
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
