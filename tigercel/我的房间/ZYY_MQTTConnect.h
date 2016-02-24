//
//  ZYY_MQTTConnect.h
//  tigercel
//
//  Created by 虎符通信 on 16/2/18.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MQTTClient.h"
#import "MQTTClientPersistence.h"

@interface ZYY_MQTTConnect : NSObject

+(id)instancedObj;

@property (nonatomic,assign)MQTTClient MQTTClint;
//登陆的时候连接至MQTTSever
-(void)connectToMQTTServerBlock:(void(^)(void))block;

//获取完设备列表后订阅设备
-(void)subscribeDeviceWithDeviceToken:(NSString *)deviceToken;

//获取新设备详情
-(void)connectToNewDeviceWithIp:(NSString *)ip andPort:(int)port block:(void(^)(id data))block;

//获取设备状态基本信息
-(void)getDeviceInfoAndConnectToMQTTWithDeviceToken:(NSString *)deviceToken block:(void(^)(id data))block;

//发送请求的消息并且返回内容
-(void)sendRequsetMessageWithContent:(char *)requestContent andTopicString:(char *)topic  andReceiveDataBlock:(void(^)(id data))block;

//订阅的topic
-(char * )getGenerateTopicWithDeviceToken:(NSString *)deviceToken;
//1.调节设备亮度
-(void)changeDeviceBrightnessWithDeviceToken:(NSString *)deviceToken andValue:(int)value block:(void (^)(id data))block;
//2.调节设备色温
-(void)changeDeviceColorWarmWithDeviceToken:(NSString *)deviceToken andValue:(int)value block:(void (^)(id data))block;
//3.设置设备呼吸速度的接口
-(void)changeRespiratoryRateWithDeviceToken:(NSString *)deviceToken andValue:(int)value block:(void (^)(id data))block;
//4.设备颜色
-(void)changeDeviceColorWithDeviceToken:(NSString *)deviceToken andRed:(int)redValue andGreen:(int)greenValue andBlue:(int)blueValue block:(void (^)(id data))block;
//5.设置省电模式
-(void)changeDeviceSavingPowerWithDeviceToken:(NSString *)deviceToken trueOrfalse:(char *)trueOrfalse block:(void (^)(id data))block;
//6.设置设备开关状态的接口
-(void)changeDeviceIsOnWithDeviceToken:(NSString *)deviceToken trueOrfalse:(char *)trueOrfalse block:(void (^)(id data))block;
//7.设置设备当前应用的场景的接口
-(void)changeDeviceCurrentSceneWithDeviceToken:(NSString *)deviceToken andValue:(int)value block:(void (^)(id data))block;
//8.设置设备当前工作模式的接口
-(void)changeDeviceCurrentModeWithDeviceToken:(NSString *)deviceToken andModeString:(char *)modeStr block:(void (^)(id data))block;
//9.为设备添加定时任务
-(void)addDeviceTimeWithDeviceToken:(NSString *)deviceToken startTime:(char *)startTime endTime:(char *)endTime lightScenario:(int)lightScenario workday:(char *)workday block:(void (^)(id data))block;
//10.删除设备的定时任务
//11.开启设备的定时任务
//12.关闭设备的定时任务
//13.获取设备的定时任务列表
//14.更新设备的定时任务信息
//15.添加设备场景
//16.删除设备场景
//17.更新设备场景
//18.获取设备场景列表
//19.获取设备的单个定时任务详细信息
//20.获取设备单个场景的详细信息
//21.获取设备当前的版本号
//22.设备升级命令
//23.取消设备升级
//24.获取升级结果
@end
