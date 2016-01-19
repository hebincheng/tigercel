//
//  ZYY_GetColorFromImage.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ZYY_GetColor.h"

@interface ZYY_GetColorFromImage : UIViewController
//图片板
@property (strong, nonatomic)UIImageView *imageBoard;
//颜色板
@property (weak, nonatomic) IBOutlet UIImageView *colorBoard;
//保存按钮
- (IBAction)saveBtn;


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andImage:(UIImage *)image;
@end
