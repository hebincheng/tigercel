//
//  ZYY_User.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/20.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYY_User : NSObject
//单例
+(id)instancedObj;
//用户手机号
@property(nonatomic,copy)NSString *telNumber;
//用户密码
@property(nonatomic,copy)NSString *passWord;
//用户昵称
@property(nonatomic,copy)NSString *userName;
//用户ID
@property(nonatomic,copy)NSString *userID;
//sessionID
@property(nonatomic,copy)NSString *sessionID;
//性别
@property(nonatomic,copy)NSString *sex;
//出生日期
@property(nonatomic,copy)NSString *birthday;
//家庭住址
@property(nonatomic,copy)NSString *location;
//最近登录事件
@property(nonatomic,copy)NSString *recentlyTime;
//设备数量
@property(nonatomic,copy)NSString *equipmentNum;
//邮箱
@property(nonatomic,copy)NSString *email;

-(id)initWithNumber:(NSString *)telNumber andPassword:(NSString *)passWord andUserName:(NSString *)userName andUserID:(NSString *)userID andSessionID:(NSString *)sessionID andSex:(NSString *)sex andBirthday:(NSString *)birthday andLocation:(NSString *)location andRecentlyTime:(NSString *)recentlyTime andEquipNum:(NSString *)equipmentNum andEmail:(NSString *)email;

@end
