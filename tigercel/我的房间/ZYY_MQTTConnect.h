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

static NSString *str=@"aaa";


@interface ZYY_MQTTConnect : NSObject

+(id)instancedObj;
//消息序列号  每次发送消息从0开是递增
@property(nonatomic,assign)NSInteger sequence;

@property (nonatomic,assign)MQTTClient MQTTClint;
//登陆的时候连接至MQTTSever
-(void)connectToMQTTServerCallBackBlock:(void(^)(void))block;
//退出的时候断开连接，并清空
-(void)quit;
//获取完设备列表后订阅设备
-(void)subscribeDeviceWithDeviceToken:(NSString *)deviceToken;

//获取新设备详情
-(void)connectToNewDeviceWithIp:(NSString *)ip andPort:(int)port callBackBlock:(void(^)(id data))block;

//获取设备状态基本信息
-(void)getDeviceInfoAndConnectToMQTTWithDeviceToken:(NSString *)deviceToken callBackBlock:(void(^)(id data))block;

//发送请求的消息并且返回内容
-(void)sendRequsetMessageWithContent:(char *)requestContent andTopicString:(char *)topic  andReceiveDatacallBackBlock:(void(^)(id data))block;

//订阅的topic
-(char * )getGenerateTopicWithDeviceToken:(NSString *)deviceToken;
//1.调节设备亮度
-(void)changeDeviceBrightnessWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block;	
//2.调节设备色温
-(void)changeDeviceColorWarmWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block;
//3.设置设备呼吸速度的接口
-(void)changeRespiratoryRateWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block;
//4.设备颜色
-(void)changeDeviceColorWithDeviceToken:(NSString *)deviceToken andRed:(int)redValue andGreen:(int)greenValue andBlue:(int)blueValue callBackBlock:(void (^)(id data))block;
//5.设置省电模式
-(void)changeDeviceSavingPowerWithDeviceToken:(NSString *)deviceToken trueOrfalse:(char *)trueOrfalse callBackBlock:(void (^)(id data))block;
//6.设置设备开关状态的接口
-(void)changeDeviceIsOnWithDeviceToken:(NSString *)deviceToken trueOrfalse:(char *)trueOrfalse callBackBlock:(void (^)(id data))block;
//7.设置设备当前应用的场景的接口
-(void)changeDeviceCurrentSceneWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block;
//8.设置设备当前工作模式的接口
-(void)changeDeviceCurrentModeWithDeviceToken:(NSString *)deviceToken andModeString:(char *)modeStr callBackBlock:(void (^)(id data))block;
//9.为设备添加定时任务
-(void)addDeviceTimeWithDeviceToken:(NSString *)deviceToken startTime:(char *)startTime endTime:(char *)endTime lightScenario:(int)lightScenario workday:(char *)workday callBackBlock:(void (^)(id data))block;
//10.删除设备的定时任务
-(void)deleteDeviceTimeWithDeviceToken:(NSString *)deviceToken  andTheTimeNumber:(int)value callBackBlock:(void (^)(id data))block;
//11.开启/关闭设备的定时任务
-(void)changeDeviceTimeIsOnWithDeviceToken:(NSString *)deviceToken timeNumber:(int)num trueOrfalse:(char *)trueOrfalse callBackBlock:(void (^)(id data))block;
//12.关闭设备的定时任务
//13.获取设备的定时任务列表
-(void)getDeviceTimerArrWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block;
//14.更新设备的定时任务信息
-(void)updateDeviceTimeWithDeviceToken:(NSString *)deviceToken timerNumber:(int)num startTime:(char *)startTime endTime:(char *)endTime lightScenario:(int)lightScenario workday:(char *)workday callBackBlock:(void (^)(id data))block;
//15.添加设备场景
-(void)addNewDeviceSceneWithDeviceToken:(NSString *)deviceToken name:(char *)name lightMode:(char *)lightMode lightBright:(int)lightBright lightColor_0:(int)lightColor_0  lightColor_1:(int)lightColor_1 lightColor_2:(int)lightColor_2 lightColorTemp:(int)lightColorTemp lightBlinkFreq:(int)lightBlinkFreq lightSwitch:(char *)lightSwitch callBackBlock:(void(^)(id data))block;
//16.删除设备场景
-(void)deleteDeviceSceneWithDeviceToken:(NSString *)deviceToken sceneNumber:(int)num callBackBlock:(void (^)(id data))block;
//17.更新设备场景
-(void)updateDeviceSceneWithDeviceToken:(NSString *)deviceToken sceneNumber:(int)num  sceneName:(char *)name callBackBlock:(void (^)(id data))block;
//18.获取设备场景列表
-(void)getDeviceSceneArrWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block;
//19.获取设备的单个定时任务详细信息
//把获取的数据存储到本地缓存库中。如此就可以不做此接口
//20.获取设备单个场景的详细信息
-(void)getDetailDeviceSceneInfoWithDeviceToken:(NSString *)deviceToken sceneNumber:(int)num callBackBlock:(void (^)(id data))block;
//21.获取设备当前的版本号
-(void)getCurrentSofeVersionWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block;
//22.设备升级命令
-(void)updateDeviceSoftVersionWithDeviceToken:(NSString *)deviceToken newVersion:(char *)newVersion callBackBlock:(void (^)(id data))block;
//23.取消设备升级
-(void)cancelDeviceUpdateWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block;
//24.获取升级结果
-(void)getDeviceUpdateResultWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block;
@end
