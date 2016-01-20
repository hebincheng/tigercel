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
//注销
@end
