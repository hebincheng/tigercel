//
//  ZYY_GetInfoFromInternet.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/20.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  获取网络数据的方法


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
-(void)feddBackWithComment:(NSString *)commentStr andTitle:(NSString *)titleStr andUserID:(NSString *)userID callBackBlock:(void(^)(void))block;
//登陆
-(void)loginWithTelNum:(NSString *)telNum andPassWord:(NSString *)password susseced:(void(^)(void))sussesedBlock orFailed:(void(^)(void))failedBlock;
//发送验证码
-(void)sendYZMWithTelNumber:(NSString *)telNumber;
//注册账号
-(void)registAccountWithEmailAddress1:(NSString *)email andPassword:(NSString *)password andUserName:(NSString *)userName andMobileNumber:(NSString *)mobileNumber andAuthCode:(NSString *)authCode callBackBlock:(void(^)(id data))block;
//注册协议
-(void)registProrocolView:(void(^)(id data))block;
//注销
-(void)logoutSessionID:(NSString *)sessionId andUserToken:(NSString *)userToken callBackBlock:(void(^)(void))block;
//获取设备列表
-(void)getEquipmentListWithSessionID:(NSString *)sessionId andUserToken:(NSString *)userToken callBackBlock:(void(^)(NSArray *lArr))block;
//添加设备
-(void)addEquipmentWithDeviceModel:(NSString *)deviceModel andSoftWareNumber:(NSString *)softWareNumber andDeviceName:(NSString *)deviceName andSessionId:(NSString *)sessionId andDeviceType:(NSString *)deviceType andDeviceId:(NSString *)deviceId andUserToken:(NSString *)userToken callBackBlock:(void(^)(void))block;
//删除设备 删除数据后刷新列表
-(void)deleteEquipmentWithSessiosID:(NSString *)sessionID andDeviceToken:(NSString *)deviceToken andUserToken:(NSString *)userToken callBackBlock:(void(^)(void))block;
//修改个人信息
-(void)commitUserInformationWithBirthdate:(NSString *)birthdate andSex:(NSString *)sex andSessionId:(NSString *)sessionId andAddress:(NSString *)address andUserToken:(NSString *)userToken;
//修改头像信息
-(void)changeUserImageWithUserId:(NSString *)userId andSessionId:(NSString *)sessionId andImageStr:(NSString *)imageStr block:(void(^)(void))block;
//获取用户信息
-(void)getUserInfoWithUserToken:(NSString *)userToken andSessionId:(NSString *)sessionId;
//修改密码
-(void)changeUserPasswordWithPassword:(NSString *)password andOldPassword:(NSString *)oldPassword andUserToken:(NSString *)userToken andSessionId:(NSString *)sessionId sussecdBlock:(void(^)(void))block;
//根据设备查找用户
-(void)getUserListWithSessionId:(NSString *)sessionId andUserToken:(NSString *)userToken andDeviceToken:(NSString *)deviceToken block:(void(^)(id data))block;
//删除分享用户
-(void)deleteSharedUserWithSessionId:(NSString *)sessionId andLoginUserToken:(NSString *)loginUserToken andSharedUserToken:(NSString *)sharedUserToken andDeviceToken:(NSString *)deviceToken block:(void(^)(id data))block;
//根据手机号分享设备
-(void)shareDeviceWithSharePhone:(NSString *)sharePhone andSessionId:(NSString *)sessionId andDeviceToken:(NSString *)deviceToken andDeviceId:(NSString *)deviceId andUserToken:(NSString *)userToken callBackBlock:(void(^)(id data))block;
//根据邮箱分享设备
-(void)shareDeviceWithShareEmail:(NSString *)shareEmail andSessionId:(NSString *)sessionId andDeviceToken:(NSString *)deviceToken andDeviceId:(NSString *)deviceId andUserToken:(NSString *)userToken callBackBlock:(void(^)(id data))block;
//根据用户ID分享设备
-(void)shareDeviceWithShareUserName:(NSString *)shareUserName andSessionId:(NSString *)sessionId andDeviceToken:(NSString *)deviceToken andDeviceId:(NSString *)deviceId andUserToken:(NSString *)userToken callBackBlock:(void(^)(id data))block;
//根据用户名分享设备
-(void)shareDeviceWithShareUserId:(NSString *)shareUserId andSessionId:(NSString *)sessionId andDeviceToken:(NSString *)deviceToken andDeviceId:(NSString *)deviceId andUserToken:(NSString *)userToken callBackBlock:(void(^)(id data))block;

@end
