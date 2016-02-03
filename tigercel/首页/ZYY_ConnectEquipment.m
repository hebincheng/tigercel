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
//用于获取ip的两个头文件
#import <ifaddrs.h>
#import <arpa/inet.h>
//用于将data转化成
#import "iot_mod_lwm2m.h"
#import "iot_mod_lwm2m_json.h"

#import "MQTTClient.h"
#import "MQTTClientPersistence.h"

@interface ZYY_ConnectEquipment ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,GCDAsyncUdpSocketDelegate>
{
    //模式数组
    NSArray *_authModeArr;
    //选择器视图
    UIAlertController *_alert;
    //选择的模式
    NSString *_modeStr;
    //加载动画
    FeThreeDotGlow *_threeDot;
    //UDP连接
    GCDAsyncUdpSocket *_udpSocket;
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
}
@end

@implementation ZYY_ConnectEquipment

- (void)viewDidLoad {
    // [self text];
    [super viewDidLoad];
    [self loadUI];
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [_runTime invalidate];
    _runTime=nil;
    
}
#pragma mark -
#pragma mark 发送设备连接消息
-(void)sendConnectMessage
{
    const char *ssid = [@"Tiger_user" cStringUsingEncoding:NSASCIIStringEncoding];
    const char *s_authmode = [[self getMode:_authModeButton.titleLabel.text] cStringUsingEncoding:NSASCIIStringEncoding];
    //        const char *ssid = [_wifiNameButton.titleLabel.text cStringUsingEncoding:NSASCIIStringEncoding];
    //        const char *s_authmode = [[self getMode:_authModeButton.titleLabel.text] cStringUsingEncoding:NSASCIIStringEncoding];
    int authmode = atoi(s_authmode);
    //        const char *password = [_passwordText.text cStringUsingEncoding:NSASCIIStringEncoding];
    const char *password = [@"64180507" cStringUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"OnStart: ssid = %s, authmode = %d, password = %s", ssid, authmode, password);
    InitSmartConnection();
    StartSmartConnection(ssid, password, "", 9);
}
#pragma mark  一阶段广播包发送的json数据
-(NSData *)discoveryQuerydata{
    //获取发送的一个时间戳
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *dateStr=[dateFormat stringFromDate:date];
    //NSLog(@"%@",dateStr);
    
    //获取手机的ip
    NSString *ipStr=[self getIPAddress];
    
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
#pragma mark  二阶段发送的数据
-(NSData *)getEquipmentInfoData
{
    //  char hh2[17]={0x08, 0x00, 0xE, 0xC0, 0x16, 0xC0, 0x00, 0xC0, 0x11, 0xC0, 0x01, 0xC0, 0x02, 0xC0, 0x12, 0xC0, 0x13};
    char hh[] = "{"
    "\"operation\":\"readREQ\","
    "\"sequence\":12345,"
    "\"object\":{"
    "\"objId\":\"device\","
    "\"objInstances\":["
    "{"
    "\"objInstanceId\":\"single\","
    "\"resources\":["
    "{\"resId\":\"MAC\"},"
    "{\"resId\":\"manufacturer\"},"
    "{\"resId\":\"deviceType\"},"
    "{\"resId\":\"moduleNumber\"},"
    "{\"resId\":\"serialNumber\"},"
    "{\"resId\":\"hardwareVersion\"},"
    "{\"resId\":\"firmwareVersion\"},"
    "{\"resId\":\"softwareVersion\"},"
    "{\"resId\":\"rebindFlag\"}"
    "]"
    "}"
    "]"
    "}"
    "}";
    int len;
    iot_mod_json_lwm2m_header_t header, header2;
    memset(&header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&header2, 0, sizeof(iot_mod_json_lwm2m_header_t));
    
    len = iot_mod_json_to_lwm2m(hh, &header);
    
    printf("he\n");
    printf("len=%d\n", len);
    
    for(int i=0; i<len; i++)
    {
        printf("%02x\t",header.body[i]);
    }
    
    char aa[300];
    memcpy(aa, &header, sizeof(header));
    
    for (int i=0; i<sizeof(header); i++)
    {
        NSLog(@"%d",aa[i]);
    }
    
    
    
    //    header2.retCode=0;
    //    header2.objId=3;
    //    header2.operation=2;
    
    //    len = iot_mod_lwm2m_to_json(hh2, sizeof(hh2), &header2);
    //    printf("len=%d\n", len);
    //    printf("json:\n%s\n", header2.body);
    
    //    iot_mod_json_lwm2m_header_t header;
    //
    //    memset(&header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    //
    //    int len = iot_mod_json_to_lwm2m(hh, &header);
    //    printf("----------%0.2x %0.2x\n", header.body[4], header.body[5]);
    //    NSLog(@"%d",header.objId);
    //   char *dataChar=(char *)&header;
    NSData *data = [NSData dataWithBytes: &header length:len];
    return data;
}

-(void)text{
    NSData*data=[self getEquipmentInfoData];
    char *a=(char*)[data bytes];
    NSLog(@"%s",a);
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
    //UDP异步广播包
    _udpSocket=[[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error=nil;
    [_udpSocket enableBroadcast:YES error:&error];//允许广播 必须 否则后面无法发送组播和广播
    [_udpSocket beginReceiving:nil];//会一直接收设备相应的数据
    //   [_udpSocket receiveOnce:nil];
    NSLog(@"开始发送广播包");
}
#pragma mark TCP连接
-(void)connectToEquipmentWithIP:(NSString *)ip andPort:(int)port
{
    
}

#pragma mark GCDAsyncUdpSocket代理方法
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSLog(@"成功接收到设备反馈的消息");
    int ret=(int)data.length;//接收到数据的长度
    char *receiveData=(char *)[data bytes];
    char *tmp_js;//用于接收解析后的数据
    discovery_tlv_parse(receiveData, ret, &tmp_js);//将受到的数据转成char*类型后进行解析
    
    NSData *jsonData=[NSData dataWithBytes:tmp_js length:strlen(tmp_js)];
    NSDictionary *receiveDict=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];//把解析出来char*转成jsonData 然后转到字典中;
    
#pragma mark根据接收到数据  解析出来数据
    NSDictionary *dict=receiveDict[@"discoveryQuery"];
    NSString *sourceIP=dict[@"sourceIP"];
    NSString *sourcePort=dict[@"sourcePort"];
    NSString *timestamp=dict[@"timestamp"];
    NSLog(@"%@-%@-%@",sourceIP,sourcePort,timestamp);
    
    [self connectToMQTTWithIp:sourceIP andPort:[sourcePort intValue]];
    
    
    //收到数据后暂停发送广播
    [_runTime invalidate];
    _runTime=nil;
    //把加载动画移除
    [_threeDot removeFromSuperview];
    
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"未发送数据%@",error.description);
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"广播包发送中........................");
}
#pragma mark  连接到mqttServer
-(void)connectToMQTTWithIp:(NSString *)ip andPort:(int)port;
{
    
    struct Options
    {
        char* connection;         /**< connection to system under test. */
        char** haconnections;
        int hacount;
        int verbose;
        int test_no;
        int MQTTVersion;
        int iterations;
    } options =
    {
        "tcp://192.168.12.182:1883",
        NULL,
        0,
        0,
        0,
        MQTTVERSION_DEFAULT,
        1,
    };
    //    NSString *connectStr=[NSString stringWithFormat:@"tcp://%@:%d",ip,port];
    //    options.connection=(char *)[connectStr UTF8String];
    MQTTClient c;
    MQTTClient_connectOptions opts = MQTTClient_connectOptions_initializer;
    MQTTClient_willOptions wopts = MQTTClient_willOptions_initializer;
    int subsqos = 2;
    int rc = 0;
    char* test_topic = "lwm2mProtocol";//用于连接设备
    // int failures = 0;
    
    
    opts.keepAliveInterval = 20;
    opts.cleansession = 1;
    opts.username = "guest";        //连到设备的账户名 密码
    opts.password = "guest";
    opts.MQTTVersion = options.MQTTVersion;
    if (options.haconnections != NULL)
    {
        opts.serverURIs = options.haconnections;
        opts.serverURIcount = options.hacount;
    }
    
    opts.will = &wopts;
    opts.will->message = "will message";
    opts.will->qos = 1;
    opts.will->retained = 0;
    opts.will->topicName = "will topic";
    opts.will = NULL;
    
    rc = MQTTClient_create(&c, options.connection, "single_threaded_test",
                           MQTTCLIENT_PERSISTENCE_DEFAULT, NULL);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        printf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&c);
    }
    
    printf("----------------------Connecting start\n");
    printf("connection : %s\n", options.connection);
    rc = MQTTClient_connect(c, &opts);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        printf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&c);
    }
    printf("----------------------Connecting finish and start subscribe\n\n\n");
    rc = MQTTClient_subscribe(c, test_topic, subsqos);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        printf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&c);
    }
    else
    {
        printf("----------------------subscribe finish!rc(%d)\n\n\n",rc);
        //[self connectToEquipmentWithIP:ip andPort:port];
    }
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
    if ([_passwordText.text isEqualToString:@""])
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入WiFi密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [av show];
    }
    else if(_modeStr==nil)
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择WiFi加密模式" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [av show];
    }
    else
    {
        
#pragma mark发送udp广播包
        
        [self sendUDPData];
        //添加时钟循环
        _runTime=[CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
        [_runTime addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
#pragma mark 添加加载动画
        _threeDot=[[FeThreeDotGlow alloc]initWithView:self.view blur:NO];
        [self.view addSubview:_threeDot];
        [_threeDot show];
        
        // 加载设备控制视图
        //        ZYY_EquipmentDetailVie *equipmentView=[[ZYY_EquipmentDetailVie alloc]initWithNibName:@"ZYY_EquipmentDetailVie" bundle:nil];
        //        [self.navigationController pushViewController:equipmentView animated:YES];
    }
}
#pragma mark-
#pragma mark 程序运行时钟
-(void)step
{
    _step++;//帧数++  1秒60次
    if (_step==1||_step%180==0)
    {
        [self sendConnectMessage];
#pragma mark 发送UDP广播
        [_udpSocket sendData:[self discoveryQuerydata] toHost:@"255.255.255.255" port:6666 withTimeout:_timeout tag:1];
    }
    if (_step%120==0)
    {
        
    }
    if(_step==60*60)
    {
        _step=0;
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
