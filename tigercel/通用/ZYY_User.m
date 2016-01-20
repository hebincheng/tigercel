//
//  ZYY_User.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/20.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_User.h"
static ZYY_User *_instancedObj;

@implementation ZYY_User
#pragma mark 单例
+(id)instancedObj
{
    static dispatch_once_t oneTime;
    _dispatch_once(&oneTime, ^{
        _instancedObj=[[self alloc]init];
    });
    return _instancedObj;
}
//通过 alloc init来初始化的也是单例
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t oneTime;
    dispatch_once(&oneTime, ^{
        _instancedObj=[super allocWithZone:zone];
    });
    return _instancedObj;
}
-(id)initWithNumber:(NSString *)telNumber andPassword:(NSString *)passWord andUserName:(NSString *)userName andUserID:(NSString *)userID andSessionID:(NSString *)sessionID andSex:(NSString *)sex andBirthday:(NSString *)birthday andLocation:(NSString *)location andRecentlyTime:(NSString *)recentlyTime andEquipNum:(NSString *)equipmentNum andEmail:(NSString *)email
{
    self=[super init];
    if (self!=nil)
    {
        _telNumber=telNumber;
        _passWord=passWord;
        _userID=userID;
        _userName=userName;
        _sessionID=sessionID;
        _sex=sex;
        _birthday=birthday;
        _location=location;
        _recentlyTime=recentlyTime;
        _equipmentNum=equipmentNum;
        _email=email;
    }
    return self;
}

@end
