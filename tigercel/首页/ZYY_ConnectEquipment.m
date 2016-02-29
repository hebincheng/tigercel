//
//  ZYY_ConnectEquipment.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/13.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  连接设备界面

#import "ZYY_ConnectEquipment.h"
#import "ZYY_EquipmentDetailVie.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "smtiot.h"
#import "Masonry.h"
#import "FeThreeDotGlow.h"
#import "GCDAsyncUdpSocket.h"
#import "AsyncUdpSocket.h"
//用于获取ip的两个头文件
#import <ifaddrs.h>
#import <arpa/inet.h>
//用于将data转化成
#import "iot_mod_lwm2m.h"
#import "iot_mod_lwm2m_json.h"

#import "ZYY_GetInfoFromInternet.h"
#import "ZYY_User.h"

#import "ZYY_MQTTConnect.h"

@interface ZYY_ConnectEquipment ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,GCDAsyncUdpSocketDelegate,AsyncUdpSocketDelegate,UIAlertViewDelegate>
{
    //模式数组
    NSArray *_authModeArr;
    //选择器视图
    UIAlertController *_alert;
    //选择的模式
    NSString *_modeStr;
    //加载动画
    FeThreeDotGlow *_threeDot;
    // udp连接
    AsyncUdpSocket *_socket;
    //程序时钟
    CADisplayLink *_runTime;
    //步数
    NSInteger _step;
    //发送的数据
    NSData *_udpData;
    //本地端口
    NSInteger _localPort;
    //超时
    NSTimeInterval _timeout;
    //端口号
    UInt16 _port;
    //二阶段返回的设备信息data
    NSData *_deviceData;
}
@end

@implementation ZYY_ConnectEquipment

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [_runTime invalidate];
    _runTime=nil;
    
}
#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 发送设备wifi连接消息
-(void)sendConnectMessage
{
   // const char *ssid = [@"babyLed" cStringUsingEncoding:NSASCIIStringEncoding];
   //const char *s_authmode = [[self getMode:_authModeButton.titleLabel.text] cStringUsingEncoding:NSASCIIStringEncoding];
    const char *ssid = [_wifiNameButton.titleLabel.text cStringUsingEncoding:NSASCIIStringEncoding];
    //        const char *s_authmode = [[self getMode:_authModeButton.titleLabel.text] cStringUsingEncoding:NSASCIIStringEncoding];
    //int authmode = atoi(s_authmode);
    const char *password = [_passwordText.text cStringUsingEncoding:NSASCIIStringEncoding];
   // const char *password = [@"64180507" cStringUsingEncoding:NSASCIIStringEncoding];
   // MYLog(@"OnStart: ssid = %s, authmode = %d, password = %s", ssid, authmode, password);
    InitSmartConnection();
    StartSmartConnection(ssid, password, "", 10);
}
#pragma mark  一阶段广播包发送的json数据
-(NSData *)discoveryQuerydata{
    //获取发送的一个时间戳
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *dateStr=[dateFormat stringFromDate:date];
    //MYLog(@"%@",dateStr);
    //获取手机的ip
    NSString *ipStr=[self getIPAddress];
    MYLog(@"%@",ipStr);
    // discovery消息的格式解析操作
    NSString *str=[NSString stringWithFormat:@"{\"discoveryQuery\": {\"sourceIP\": \"%@\",\"sourcePort\": \"1234\",\"timestamp\": \"%@\"}}",ipStr,dateStr];
    char *discoverData=(char*)[str UTF8String];//将NSString转化成char*格式
    
    char *tmp_tlv;    //设置用于接收字符解析出来的字符指针和字符的长度
    int ret;
    //printf("start:\n");
    ret = discovery_json_parse(discoverData, &tmp_tlv);
    //将解析出来的字符数组转成data,ret解析出的字节数
    
    NSData *data = [NSData dataWithBytes: tmp_tlv length:ret];
    return data;
}

#pragma mark 获取手机当前ip
-(NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
#pragma mark 发送广播包
-(void)sendUDPData
{
    _socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
     NSError *error=nil;
    
//    [_socket bindToPort:9001 error:&error];
    
    [_socket enableBroadcast:YES error:&error];
//    [_socket closeAfterReceiving];
    MYLog(@"开始广播>>>>>>>>>>>>>>>>>>>");
}


#pragma mark AsyncUdpSocket代理方法

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    MYLog(@"%@",error.description);
}

-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
    MYLog(@"成功接收到设备反馈的消息");
    //收到相应则停止发送连接消息
    StopSmartConnection();
    int ret=(int)data.length;//接收到数据的长度
    char *receiveData=(char *)[data bytes];
    char *tmp_js;//用于接收解析后的数据
    discovery_tlv_parse(receiveData, ret, &tmp_js);//将受到的数据转成char*类型后进行解析
#pragma mark 解析第一阶段收到设备返回的数据
    NSData *jsonData=[NSData dataWithBytes:tmp_js length:strlen(tmp_js)];
    NSDictionary *receiveDict=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];//把解析出来char*转成jsonData 然后转到字典中;
    
    //收到数据后暂停发送广播
    [_runTime invalidate];
    _runTime=nil;
    //把加载动画移除
    [_threeDot removeFromSuperview];
    
// 根据接收到数据 解析出来数据
    NSDictionary *dict=receiveDict[@"discoveryQuery"];
    NSString *sourceIP=dict[@"sourceIP"];
    NSString *sourcePort=dict[@"sourcePort"];
    NSString *timestamp=dict[@"timestamp"];
    MYLog(@"%@-%@-%@",sourceIP,sourcePort,timestamp);
//获取新设备详情，成功后输入设备名字
    [[ZYY_MQTTConnect instancedObj]connectToNewDeviceWithIp:sourceIP andPort:[sourcePort intValue] callBackBlock:^(id data) {
        _deviceData=[NSData dataWithData:data];
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"请输入保存设备名字" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [av show];
    }];

    return YES;
}

#pragma mark -
#pragma mark 加载UI
-(void)loadUI{
    [self setTitle:@"连接设备"];
    _step=0;
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [_passwordText setDelegate:self];
    
    //设置authModeButton相关属性
    [_authModeButton setTitle:@"请选择Wi-Fi加密模式" forState:UIControlStateNormal];
    [_authModeButton setAdjustsImageWhenHighlighted:NO];
    [_authModeButton setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    
    NSString *str=[self searchWiFiName];
    if (str!=nil)
    {
        [_wifiNameButton setTitle: str forState:UIControlStateNormal];
    }
    else
    {
        [_wifiNameButton setTitle: @"WIFI名" forState:UIControlStateNormal];
    }
    //设置模式数组
    _authModeArr=@[@"Open",@"WPA",@"WPAPSK ",@"WPA2",@"WPA2PSK",@"WPA1WPA2",@"WPA1PSKWPA2PSK"];
    UIPickerView *autoModePickView=[[UIPickerView alloc]init];
    [autoModePickView setDelegate:self];
    [autoModePickView setDataSource:self];
    
    //设置选择器视图相关属性
    _alert=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [_alert.view addSubview:autoModePickView];
    //通过自动布局来调整pickerview相对于alertView的位置
    [autoModePickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(_alert.view).offset(-10);
        make.leading.equalTo(_alert.view.mas_leading).offset(-20);
    }];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_authModeButton setTitle:_modeStr forState:UIControlStateNormal];
        [_authModeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [_alert addAction:ok];
    [_alert addAction:cancel];
    
    
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
}
#pragma mark UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1)
    {
        UITextField *nameText=[alertView textFieldAtIndex:0];
        
        NSString *deviceName=nameText.text;
        deviceName=[deviceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //解析得到的json类型的data
        NSDictionary *receiveDict=[NSJSONSerialization JSONObjectWithData:_deviceData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *objDict=receiveDict[@"object"];
        NSArray *insArr=objDict[@"objInstances"];
        NSDictionary *insDict=insArr[0];
        NSArray *resourceArr=insDict[@"resources"];//此层为资源层。设备反馈的消息都在此数组。
        //获取deviceType 设备类型
        NSDictionary *deviceTypeDict=resourceArr[2];
        NSArray *typeArr=deviceTypeDict[@"resInstances"];
        NSDictionary *typeDict=typeArr[0];
        NSString *deviceType=typeDict[@"value"];
        //获取softWareNumber 软件版本
        NSDictionary *softWareDict=resourceArr[6];
        NSArray *softWareArr=softWareDict[@"resInstances"];
        NSDictionary *softDict=softWareArr[0];
        NSString *softWareNumber=softDict[@"value"];
        //获取设备ID
        NSDictionary *MACDict=resourceArr[0];
        NSArray *MACArr=MACDict[@"resInstances"];
        NSDictionary *MACIdDict=MACArr[0];
        NSString *deviceId=MACIdDict[@"value"];
        
        MYLog(@"%@--%@--%@--%@",deviceType,softWareNumber,deviceId,deviceName);
        
#pragma mark 第三阶段调用方法添加新设备
        NSString * deviceModel=@"休闲";//设备型号
        deviceModel=[deviceModel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        ZYY_User *user=[ZYY_User instancedObj];
        
        [[ZYY_GetInfoFromInternet instancedObj]addEquipmentWithDeviceModel:deviceModel andSoftWareNumber: softWareNumber andDeviceName: deviceName andSessionId:user.sessionId andDeviceType:deviceType andDeviceId:deviceId andUserToken:user.userToken callBackBlock:^{
            // 添加成功后返回首页
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark 键盘的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark -
#pragma mark 模式选择器的4个代理方法
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _authModeArr[row];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _authModeArr.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _modeStr=_authModeArr[row];
}

#pragma mark -
#pragma mark 搜寻WiFi
- (IBAction)WiFiSearch:(UIButton *)sender {
    NSString *str=[self searchWiFiName];
    UIAlertView *av=nil;
    if (str!=nil)
    {
        [_wifiNameButton setTitle: str forState:UIControlStateNormal];
        av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"成功搜寻到WIFI" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }
    else
    {
        av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请连接至WIFI" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }
}
#pragma mark  获取WiFi名字
-(NSString *)searchWiFiName{
    NSString *wifiName = nil;
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
        }
    }
    return wifiName;
}
#pragma mark -
#pragma mark 判断输入字段并调用接口进行连接
- (IBAction)connectBtn {
    [_passwordText resignFirstResponder];
//    if ([_passwordText.text isEqualToString:@""])
//    {
//        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入WiFi密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [av show];
//    }
//    else if(_modeStr==nil)
//    {
//        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择WiFi加密模式" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [av show];
//    }
//    else
//    {
        //wifi连接请求
        [self sendConnectMessage];
#pragma mark发送udp广播包
        [self sendUDPData];
        //添加时钟循环
        _runTime=[CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
        [_runTime addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
#pragma mark 添加加载动画
        _threeDot=[[FeThreeDotGlow alloc]initWithView:self.view blur:NO];
        [self.view addSubview:_threeDot];
        [_threeDot show];
//    }
}
#pragma mark-
#pragma mark 程序运行时钟
-(void)step
{
    _step++;//帧数++  1秒60次
    if (_step==1||_step%120==0)
    {
       
#pragma mark 发送UDP广播
        [_socket sendData :[self discoveryQuerydata] toHost:@"255.255.255.255" port:6666 withTimeout:5000 tag:1];
        
        [_socket receiveWithTimeout:-1 tag:0];
        MYLog(@"2222222222");
//        [_udpSocket sendData:[self discoveryQuerydata] toHost:@"255.255.255.255" port:6666 withTimeout:_timeout tag:1];
    }
    if(_step==60*30)
    {
        _step=0;
        //停止发送wifi信息
        StopSmartConnection();
        //暂停时钟
        [_runTime invalidate];
        _runTime=nil;
        //若执行此段 则说明30秒未检测到设备,关闭加载视图
        [_threeDot removeFromSuperview];

        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"未所搜索到设备，请检查参数配置以及设备状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
}

-(NSString *)getMode:(NSString *)str
{
    for (int i=0; i<7; i++) {
        if ([str isEqualToString:_authModeArr[i]])
        {
            if (i==0)
            {
                return @"0";
            }
            if (i==1)
            {
                return @"3";
            }
            else if(i==2)
            {
                return @"4";
            }
            return [NSString stringWithFormat:@"%d",i+3];
        }
    }
    return @"0";
}

//获取模式
- (IBAction)authModeBtn:(UIButton *)sender {
    [_passwordText resignFirstResponder];
    if (_modeStr==nil)
    {
        _modeStr=@"Open";
    }
    [self presentViewController:_alert animated:YES completion:nil];
}
@end
