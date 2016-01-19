//
//  ZYY_ProtocolView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  用于显示用户协议的界面

#import <UIKit/UIKit.h>

//定义协议 用于用户阅读完协议后界面仍会保存验证码
@protocol ZYY_ProtocolViewDelegate<NSObject>

-(void)setUserInformation;

@end;

@interface ZYY_ProtocolView : UIViewController
//代理属性
@property(nonatomic,weak)id<ZYY_ProtocolViewDelegate>delegate;

//用于显示的webView
@property (weak, nonatomic) IBOutlet UIWebView *protocolWebView;

@end
