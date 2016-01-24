//
//  ZYY_GetInfoFromInternet.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/20.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYY_GetInfoFromInternet : NSObject
//单例
+(id)instancedObj;
//使用条例
-(void)getUserReglation:(void(^)(id data))block;
//版本申明
-(void)getVersionExplain:(void(^)(id data))block;
//版本更新未做
-(void)getVersionUpdate:(void (^)(id))block;
//反馈发送请求
-(void)feddBackWithComment:(NSString *)commentStr andTitle:(NSString *)titleStr andUserID:(NSString *)userID and:(void(^)(void))block;
//登陆
-(void)loginWithTelNum:(NSString *)telNum andPassWord:(NSString *)password and:(void(^)(void))block;
//发送验证码
-(void)sendYZMWithTelNumber:(NSString *)telNumber;
//注册账号
-(void)registAccountWithEmailAddress1:(NSString *)email andPassword:(NSString *)password andUserName:(NSString *)userName andMobileNumber:(NSString *)mobileNumber andAuthCode:(NSString *)authCode and:(void(^)(id data))block;
//注册协议
-(void)registProrocolView:(void(^)(id data))block;
//注销
-(void)logoutSessionID:(NSString *)sessionId andUserToken:(NSString *)userToken and:(void(^)(void))block;
//获取设备列表
-(void)getEquipmentListWithSessionID:(NSString *)sessionId andUserID:(NSString *)userID and:(void(^)(NSArray *lArr))block;
//添加设备
-(void)addEquipmentWithDeviceModel:(NSString *)deviceModel andSoftWareNumber:(NSString *)softWareNumber andDeviceName:(NSString *)deviceName andSessionId:(NSString *)sessionId andDeviceType:(NSString *)deviceType andDeviceId:(NSString *)deviceId andUserId:(NSString *)userId;
//删除设备 删除数据后刷新列表
-(void)deleteEquipmentWithSessiosID:(NSString *)sessionID andDeviceToken:(NSString *)deviceToken andUserId:(NSString *)userId ;
//分享设备
-(void)shareDeviceWithSharePhone:(NSString *)sharePhone andSessionId:(NSString *)sessionId andDeviceToken:(NSString *)deviceToken andDeviceId:(NSString *)deviceId andUserId:(NSString *)userId and:(void(^)(id data))block;
//修改个人信息
-(void)commitUserInformationWithBirthdate:(NSString *)birthdate andSex:(NSString *)sex andSessionId:(NSString *)sessionId andAddress:(NSString *)address andUserToken:(NSString *)userToken;
@end
