//
//  ZYY_EquipmentDetailVie.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/12.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYY_LED.h" 


@interface ZYY_EquipmentDetailVie : UIViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLEDInformation:(ZYY_LED *)led andNumber:(NSInteger )number;


@end
