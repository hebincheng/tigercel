//
//  ZYY_ProtocolView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ProtocolView.h"

@interface ZYY_ProtocolView ()

@end

@implementation ZYY_ProtocolView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"XXX注册协议"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_delegate setUserInformation];
}

@end
