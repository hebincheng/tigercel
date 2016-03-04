//
//  ZYY_RoomView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYY_LED;

@interface ZYY_RoomView : UIViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andShowWidth:(CGFloat)width andShowHeigh:(CGFloat)height roomName:(NSString *)roomName andLEDArr:(NSArray *)ledArr;

@property (strong, nonatomic) UILabel *roomName;


-(void)reloadDataWithNewDevice:(NSString *)led;

@end
