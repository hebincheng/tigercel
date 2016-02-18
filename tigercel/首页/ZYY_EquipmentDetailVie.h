//
//  ZYY_EquipmentDetailVie.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/12.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  设备操作界面

#import <UIKit/UIKit.h>
#import "ZYY_LED.h" 
@protocol ZYY_EquipmentDetailVieDelegate <NSObject>

-(void)reLoadTableView;

@end

@interface ZYY_EquipmentDetailVie : UIViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLEDInformation:(ZYY_LED *)led andNumber:(NSInteger )number;

@property(nonatomic,weak)id<ZYY_EquipmentDetailVieDelegate> delegate;

@end
