//
//  ZYY_RoomView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYY_LED;

@protocol ZYY_RoomViewDelegate <NSObject>

-(void)addDeviceWithBeDeletedDevice:(NSString *)str andBeDeletedDeviceNum:(NSInteger)num;

@end

@interface ZYY_RoomView : UIViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andShowWidth:(CGFloat)width andShowHeigh:(CGFloat)height roomName:(NSString *)roomName andLEDArr:(NSArray *)ledArr;
//房间名的Label
@property (strong, nonatomic) UILabel *roomName;
//代理
@property (nonatomic,weak)id<ZYY_RoomViewDelegate> delegate;

//新加设备
-(void)reloadDataWithNewDevice:(NSString *)led;
//删除设备
-(void)reloadDataWithDeleteDevice:(NSInteger )deviceNum;
@end
