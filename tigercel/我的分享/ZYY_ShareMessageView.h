//
//  ZYY_ShareMessageView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYY_LED.h"

@interface ZYY_ShareMessageView : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *contentText;
//LED
@property (strong,nonatomic) ZYY_LED *LED;


- (IBAction)nextStepBtn;
//选择分享的方式
@property(nonatomic,assign)NSInteger shareWay;

@property(nonatomic,copy)NSString *placeHolderText;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPlaceText:(NSString* ) string andWay:(NSInteger )num;
@end
