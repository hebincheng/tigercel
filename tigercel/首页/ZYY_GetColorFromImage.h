//
//  ZYY_GetColorFromImage.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ZYY_GetColor.h"
//设置代理 设置设备控制界面的颜色
@protocol ZYY_GetColorFromImageDelegate<NSObject>

-(void)setLedColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha;

@end

@interface ZYY_GetColorFromImage : UIViewController
//代理
@property(weak,nonatomic)id<ZYY_GetColorFromImageDelegate>delegate;

//图片板
@property (strong, nonatomic)UIImageView *imageBoard;
//颜色板
@property (weak, nonatomic) IBOutlet UIImageView *colorBoard;
//保存按钮
- (IBAction)saveBtn;


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andImage:(UIImage *)image;
@end
