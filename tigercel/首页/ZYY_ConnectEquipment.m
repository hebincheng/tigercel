//
//  ZYY_ConnectEquipment.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/13.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ConnectEquipment.h"
#import "ZYY_EquipmentDetailVie.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "smtiot.h"
#import "Masonry.h"
#import "FeThreeDotGlow.h"
#import "AsyncUdpSocket.h"
//用于获取ip的两个头文件
#import <ifaddrs.h>
#import <arpa/inet.h>
//用于将data转化成
#import "iot_mod_lwm2m.h"
#import "iot_mod_lwm2m_json.h"

@interface ZYY_ConnectEquipment ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,AsyncUdpSocketDelegate>
{
    //模式数组
    NSArray *_authModeArr;
    //选择器视图
    UIAlertController *_alert;
    //选择的模式
    NSString *_modeStr;
    //加载动画
    FeThreeDotGlow *_threeDot;
    //UDP异步广播包
    AsyncUdpSocket *_socket;
}
@end

@implementation ZYY_ConnectEquipment

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self sendUDPData];
}

#pragma mark -
#pragma mark  广播包发送的json数据
-(NSData *)discoveryQuerydata{
    //获取发送的一个时间戳
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *dateStr=[dateFormat stringFromDate:date];
    NSLog(@"%@",dateStr);

    //获取手机的ip
    NSString *ipStr=[self getIPAddress];
    NSLog(@"%@",ipStr);
    
//    //获取手机的端口
//    
//    NSDictionary *commentDict=@{@"sourceIP":ipStr, @"sourcePort":@12345, @"timestamp":dateStr};
//    NSDictionary *json=@{@"discoveryQuery":commentDict};
//    //把json格式字典转化成data发送出去
//    NSData *data=[NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
//
    char *hh3 = "{"
    "\"discoveryQuery\": {"
    "\"sourceIP\": \"129.12.12.12\","
    "\"sourcePort\": \"1234\","
    "\"timestamp\": \"1234567890\""
    "}"
    "}";
    
    char *tmp_tlv;
    int ret;
    
    printf("start:\n");
    ret = discovery_json_parse(hh3, &tmp_tlv);
    printf("ret=%d\n", ret);
    
//    ret = discovery_tlv_parse(tmp_tlv, ret, &tmp_js);
//    printf("json:\n""%x\n", &tmp_tlv);
//    printf("ret=%d\n", ret);
//
//    NSString *dateStr2 =[NSString stringWithFormat:@"%x",&tmp_tlv];
    NSString *dateStr2=[[NSString alloc]initWithCString:tmp_tlv encoding:NSASCIIStringEncoding];

    NSLog(@"--------------%@",dateStr2);
    NSData *data=[dateStr2 dataUsingEncoding:NSUTF8StringEncoding];
    return data;
//    NSString *dataStr= [NSString stringWithCString:(char*)header.body encoding:NSUTF8StringEncoding];
//    NSLog(@"--------%@",dataStr);
//    return [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//    return data;
}
#pragma mark 获取手机当前ip
-(NSString *)getIPAddress {
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
    _socket=[[AsyncUdpSocket alloc]initWithDelegate:self];

    [_socket localPort];
    NSData *data=[self discoveryQuerydata];
    NSLog(@"%@",data);
    NSError *error=nil;
    [_socket enableBroadcast:YES error:&error];
    [_socket sendData :data toHost:@"255.255.255.255" port:9527 withTimeout:60 tag:1];
    [_socket receiveWithTimeout:-1 tag:0];
    NSLog(@"begin scan");
}

#pragma mark AsyncSocket代理方法
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSString* result;
    
    result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@",result);
    
    NSLog(@"received");
    return YES;
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"not received");
    
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"%@",error);
    
    NSLog(@"not send");
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    NSLog(@"send");
    
}

-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
    NSLog(@"closed");
    
}
#pragma mark -
#pragma mark 加载UI
-(void)loadUI{
    [self setTitle:@"连接设备"];
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

#pragma mark -
#pragma mark 模式选择器的4个代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
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
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
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
#pragma mark 发送连接消息
        const char *ssid = [_wifiNameButton.titleLabel.text cStringUsingEncoding:NSASCIIStringEncoding];
        const char *s_authmode = [[self getMode:_authModeButton.titleLabel.text] cStringUsingEncoding:NSASCIIStringEncoding];
        NSLog(@"%s",s_authmode);
        int authmode = atoi(s_authmode);
        const char *password = [_passwordText.text cStringUsingEncoding:NSASCIIStringEncoding];
        NSLog(@"OnStart: ssid = %s, authmode = %d, password = %s", ssid, authmode, password);
       // InitSmartConnection();
       // StartSmartConnection(ssid, password, "", authmode);
#pragma mark发送udp广播包
        [self sendUDPData];
#pragma mark 添加加载动画
        _threeDot=[[FeThreeDotGlow alloc]initWithView:self.view blur:NO];
        [self.view addSubview:_threeDot];

        //设置最长发送udp广播时间以及模块连接信息时间
        [_threeDot showWhileExecutingBlock:^{
            [NSThread sleepForTimeInterval:30.0f];
        } completion:^{
            [_threeDot removeFromSuperview];
       //若执行此段 则说明30秒未检测到设备
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"未所搜索到设备，请检查参数配置以及设备状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }];
       // 加载设备控制视图
        ZYY_EquipmentDetailVie *equipmentView=[[ZYY_EquipmentDetailVie alloc]initWithNibName:@"ZYY_EquipmentDetailVie" bundle:nil];
        [self.navigationController pushViewController:equipmentView animated:YES];
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
