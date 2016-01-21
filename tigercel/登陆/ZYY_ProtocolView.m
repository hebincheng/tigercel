//
//  ZYY_ProtocolView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ProtocolView.h"
#import "ZYY_GetInfoFromInternet.h"

@interface ZYY_ProtocolView ()
{
    NSString *_comment;
}
@end

@implementation ZYY_ProtocolView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"XXX注册协议"];
    
}
-(void)viewWillAppear:(BOOL)animated{
[[ZYY_GetInfoFromInternet instancedObj]registProrocolView:^(id data) {
    _comment=data;
    [self loadUI];
}];

}

-(void)loadUI
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    label.text=_comment;
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:18.0f]];
    [self.view addSubview:label];
}
@end
