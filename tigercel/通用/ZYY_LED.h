//
//  ZYY_LED.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  LED 设备信息

#import <Foundation/Foundation.h>

@interface ZYY_LED : NSObject<NSCoding>
//设备名字
@property(nonatomic,copy)NSString *deviceName;
//当前应用场景
@property(nonatomic,copy)NSString *currentSceneName;
//照明模式应用场景
@property(nonatomic,strong)NSArray *zhaoMingArr;
//氛围模式应用场景
@property(nonatomic,strong)NSArray *fenWeiArr;
//定时数组
@property(nonatomic,strong)NSArray *timeArr;

@end
