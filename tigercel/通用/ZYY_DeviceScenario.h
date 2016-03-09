//
//  ZYY_DeviceScenario.h
//  tigercel
//
//  Created by 虎符通信 on 16/3/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  场景

#import <Foundation/Foundation.h>

@interface ZYY_DeviceScenario : NSObject
//场景ID
@property(nonatomic,assign)NSInteger scenarioId;
//场景名字
@property(nonatomic,copy)NSString *name;
//工作模式
@property(nonatomic,copy)NSString *lightMode;
//亮度
@property(nonatomic,assign)NSInteger lightBright;
//色温
@property(nonatomic,assign)NSInteger lightColorTemp;
//呼吸速度
@property(nonatomic,assign)NSInteger lightBlinkFreq;
//设备开关
@property(nonatomic,assign)BOOL lightSwitch;
//颜色-红
@property(nonatomic,assign)NSInteger red;
//颜色-绿
@property(nonatomic,assign)NSInteger green;
//颜色-蓝
@property(nonatomic,assign)NSInteger blue;


@end
