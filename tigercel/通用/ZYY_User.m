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
-(void)initWithDictionary:(NSDictionary *)dict
{
    ZYY_User *user=[[ZYY_User alloc]init];
    if (user!=nil)
    {
        [user setValuesForKeysWithDictionary:dict];
    }
}

@end
