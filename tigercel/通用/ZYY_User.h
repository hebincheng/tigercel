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
////用户手机号
//@property(nonatomic,copy)NSString *telNumber;
////用户密码
//@property(nonatomic,copy)NSString *passWord;
////用户昵称
//@property(nonatomic,copy)NSString *userName;
////用户ID
//@property(nonatomic,copy)NSString *userID;
////sessionID
//@property(nonatomic,copy)NSString *sessionID;
////性别
//@property(nonatomic,copy)NSString *sex;
////出生日期
//@property(nonatomic,copy)NSString *birthday;
////家庭住址
//@property(nonatomic,copy)NSString *location;
////最近登录事件
//@property(nonatomic,copy)NSString *recentlyTime;
////设备数量
//@property(nonatomic,copy)NSString *equipmentNum;
////邮箱
//@property(nonatomic,copy)NSString *email;


//手表id
@property (nonatomic, copy) NSString *wechatId;
//电话
@property (nonatomic, copy) NSString *mobileNumber;
//地址
@property (nonatomic, copy) NSString *address1;
//？？
@property (nonatomic, copy) NSString *realName;
//性别
@property (nonatomic, copy) NSString *sex;
//最后一次登录时间
@property (nonatomic, copy) NSString *lastLoginDate;
//生日
@property (nonatomic, copy) NSString *birthdate;
//用户id
@property (nonatomic, copy) NSString *userId;
//用户昵称
@property (nonatomic, copy) NSString *userName;
//用户等级
@property (nonatomic, copy) NSString *userLevel;
//头像地址
@property (nonatomic, copy) NSString *image;
//email
@property (nonatomic, copy) NSString *emailAddress1;
//??
@property (nonatomic, copy) NSString *userToken;
//sessionID
@property (nonatomic, copy) NSString *sessionId;
//标题链接？？
@property (nonatomic, copy) NSString *titleMultiUrl;
//登录牌
@property (nonatomic, copy) NSString *loginFlag;

-(void)initWithDictionary:(NSDictionary *)dict;

//-(id)initWithNumber:(NSString *)telNumber andPassword:(NSString *)passWord andUserName:(NSString *)userName andUserID:(NSString *)userID andSessionID:(NSString *)sessionID andSex:(NSString *)sex andBirthday:(NSString *)birthday andLocation:(NSString *)location andRecentlyTime:(NSString *)recentlyTime andEquipNum:(NSString *)equipmentNum andEmail:(NSString *)email;

@end
