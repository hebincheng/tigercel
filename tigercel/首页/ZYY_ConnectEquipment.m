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

@interface ZYY_ConnectEquipment ()

@end

@implementation ZYY_ConnectEquipment

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"连接设备"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    NSString *str=[self searchWiFiName];
    if (str!=nil)
    {
        [_wifiNameButton setTitle: str forState:UIControlStateNormal];
    }
    else
    {
        [_wifiNameButton setTitle: @"WIFI名" forState:UIControlStateNormal];
    }
}

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

- (IBAction)connectBtn {
//    const char *ssid = [_wifiNameButton.titleLabel.text cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *s_authmode = [@"123" cStringUsingEncoding:NSASCIIStringEncoding];
//    int authmode = atoi(s_authmode);
//    const char *password = [_passwordText.text cStringUsingEncoding:NSASCIIStringEncoding];
//    NSLog(@"OnStart: ssid = %s, authmode = %d, password = %s", ssid, authmode, password);
//    InitSmartConnection();
//    StartSmartConnection(ssid, password, "", authmode);
    ZYY_EquipmentDetailVie *equipmentView=[[ZYY_EquipmentDetailVie alloc]initWithNibName:@"ZYY_EquipmentDetailVie" bundle:nil];
    [self.navigationController pushViewController:equipmentView animated:YES];
}
@end
