//
//  ZYY_UserListView.h
//  tigercel
//
//  Created by 虎符通信 on 16/2/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYY_LED;

@interface ZYY_UserListView : UIViewController

-(id)initWithUserArr:(NSArray *)userArr andLED:(ZYY_LED *)LED;

@end
