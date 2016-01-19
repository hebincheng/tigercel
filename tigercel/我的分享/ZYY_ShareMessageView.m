//
//  ZYY_ShareMessageView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ShareMessageView.h"

@interface ZYY_ShareMessageView ()

@end

@implementation ZYY_ShareMessageView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设备分享"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [_contentText setPlaceholder:_placeHolderText];
    // Do any additional setup after loading the view from its nib.
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPlaceText:(NSString *)string andWay:(NSInteger)num{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _placeHolderText =string;
        _shareWay=num;
    }
    return self;
}
- (IBAction)nextStepBtn
{
    NSLog(@"下一步");
}
@end
