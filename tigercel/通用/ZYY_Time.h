//
//  ZYY_Time.h
//  tigercel
//
//  Created by 虎符通信 on 16/3/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZYY_DeviceScenario;

@interface ZYY_Time : NSObject
//闹钟ID
@property(nonatomic,assign)NSInteger timerId;
//闹钟起始时间
@property(nonatomic,copy)NSString *startTime;
//闹钟结束时间
@property(nonatomic,copy)NSString *endTime;
//工作日
@property(nonatomic,copy)NSString *workday;
//设备场景
@property(nonatomic,strong)ZYY_DeviceScenario *deviceScenario;

-(NSArray *)getTimerArrFromDict:(NSArray *)timerArr;

@end
