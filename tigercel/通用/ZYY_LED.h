//
//  ZYY_LED.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  LED 设备信息

#import <Foundation/Foundation.h>

@interface ZYY_LED : NSObject<NSCoding>


//---------------------本地存储的内容--------------------//
//拥有者名字
@property(nonatomic,copy)NSString *ownerName;
//当前应用场景
@property(nonatomic,copy)NSString *currentSceneName;
//照明模式应用场景
@property(nonatomic,strong)NSArray *zhaoMingArr;
//氛围模式应用场景
@property(nonatomic,strong)NSArray *fenWeiArr;
//定时数组
@property(nonatomic,strong)NSArray *timeArr;

//---------------------从网络获取的--------------------//
//设备ID
@property (nonatomic, copy) NSString *deviceId;
//用户ID
@property (nonatomic, copy) NSString *userId;
//设备名字
@property (nonatomic, copy) NSString *deviceName;
//软件版本编号
@property (nonatomic, copy) NSString *softWareNumber;
//设备类型
@property (nonatomic, copy) NSString *deviceType;
//设备象征
@property (nonatomic, copy) NSString *deviceToken;
//设备模式
@property (nonatomic, copy) NSString *deviceModel;

+(NSArray *)getEquipmentListWithArr:(NSArray *)arr;


@end
