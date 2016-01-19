//
//  ZYY_LED.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_LED.h"

@implementation ZYY_LED

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_currentSceneName forKey:@"currentSceneName"];
    [aCoder encodeObject:_deviceName forKey:@"deviceName"];
    [aCoder encodeObject:_timeArr forKey:@"timeArr"];
    [aCoder encodeObject:_zhaoMingArr forKey:@"zhaoMingArr"];
    [aCoder encodeObject:_fenWeiArr forKey:@"fenWeiArr"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        _currentSceneName=[aDecoder decodeObjectForKey:@"currentSceneName"];
        _deviceName=[aDecoder decodeObjectForKey:@"deviceName"];
        _timeArr=[aDecoder decodeObjectForKey:@"timeArr"];
        _zhaoMingArr=[aDecoder decodeObjectForKey:@"zhaoMingArr"];
        _fenWeiArr=[aDecoder decodeObjectForKey:@"fenWeiArr"];
    }
    return self;
}
@end
