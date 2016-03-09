//
//  ZYY_Time.m
//  tigercel
//
//  Created by 虎符通信 on 16/3/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_Time.h"

@implementation ZYY_Time

-(NSArray *)getTimerArrFromDict:(NSArray *)timerArr{
    NSMutableArray *arr=[NSMutableArray array];
    for (NSDictionary *dict in timerArr)
    {
        ZYY_Time *timer=[[ZYY_Time alloc]init];
        
        [timer setValuesForKeysWithDictionary:dict];
        
        [arr addObject:timer];
    }
    return arr;
}

@end
