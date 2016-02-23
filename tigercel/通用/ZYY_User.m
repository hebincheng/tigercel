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
////通过 alloc init来初始化的也是单例
//+(instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t oneTime;
//    dispatch_once(&oneTime, ^{
//        _instancedObj=[super allocWithZone:zone];
//    });
//    return _instancedObj;
//}
-(void)initWithDictionary:(NSDictionary *)dict
{
    //通过instancedObj初始化的均为单例，
    ZYY_User *user=[ZYY_User instancedObj];
    if (user!=nil)
    {
        [user setValuesForKeysWithDictionary:dict];
    }
}

-(NSArray *)getUserArrWithArr:(NSArray *)arr{
    NSMutableArray *mArr=[NSMutableArray array];
    for (NSDictionary *dict in arr)
    {
        //必须用alloc来初始化
        ZYY_User *user=[[ZYY_User alloc]init];
        [user setValuesForKeysWithDictionary:dict];
        [mArr addObject:user];
    }
    return mArr;
}

@end
