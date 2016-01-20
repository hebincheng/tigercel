//
//  ZYY_GetInfoFromInternet.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/20.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_GetInfoFromInternet.h"
#import "AFHTTPRequestOperationManager.h"

static NSString *urlPathStr=@"http://115.159.94.136:8080/";//基础url
static NSString *userReglationStr=@"hufu/app/protocol/protocolDetail.do?";//使用条例-版本说明
static NSString *versionStr=@"hufu/app/andriod/getAndroidVersion.do?";//版本更新 此处是安卓版本url
static NSString *feedBackStr=@"hufu/app/feedback/addFeedBack.do?";//反馈发送请求
static NSString *loginStr=@"hufu/app/member/login.do?";//登陆请求
static ZYY_GetInfoFromInternet *_instancedObj;

@implementation ZYY_GetInfoFromInternet
#pragma mark 单例
+(id)instancedObj
{
    static dispatch_once_t oneTime;
    _dispatch_once(&oneTime, ^{
        _instancedObj=[[self alloc]init];
    });
    return _instancedObj;
}
//通过 alloc init来初始化的也是单例
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t oneTime;
    dispatch_once(&oneTime, ^{
        _instancedObj=[super allocWithZone:zone];
    });
    return _instancedObj;
}

#pragma mark 网络出错  提示用户
-(void)showError
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [av show];
}
#pragma mark 登陆
-(void)loginWithTelNum:(NSString *)telNum andPassWord:(NSString *)password and:(void (^)(void))block
{
    NSString *urlStr=[urlPathStr stringByAppendingString:loginStr];
    NSDictionary *requeseDict=@{@"mobileNumber":telNum,@"password":password};
    [[AFHTTPRequestOperationManager manager]GET:urlStr parameters:requeseDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
    {
        [self showError];
    }];
}

#pragma mark 发送反馈
-(void)feddBackWithComment:(NSString *)commentStr andTitle:(NSString *)titleStr andUserID:(NSString *)userID and:(void (^)(void))block
{
    NSString *urlStr=[urlPathStr stringByAppendingString:feedBackStr];
    [[AFHTTPRequestOperationManager manager]GET:urlStr parameters:@{@"feedBackComment":commentStr,@"feedBackTitle":titleStr,@"userId":userID} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject!=nil)
        {
            block();
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self showError];
    }];
}


#pragma mark 获取版本
-(void)getVersionExplain:(void (^)(id))block{
    __block NSString *comment=nil;
    NSString *urlStr=[urlPathStr stringByAppendingString:userReglationStr];
    NSLog(@"%@",urlStr);
    [[AFHTTPRequestOperationManager manager]GET:urlStr parameters:@{@"type":@2} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //解析data
        NSDictionary *dict=responseObject[@"data"];
        comment=dict[@"comment"];
        NSLog(@"%@",dict[@"comment"]);
        block(comment);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self showError];
    }];
}
#pragma mark 获取使用条例
-(void)getUserReglation:(void (^)(id))block
{
    __block NSString *comment=nil;
    NSString *urlStr=[urlPathStr stringByAppendingString:userReglationStr];
    NSLog(@"%@",urlStr);
    [[AFHTTPRequestOperationManager manager]GET:urlStr parameters:@{@"type":@3} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict=responseObject[@"data"];
        comment=dict[@"comment"];
        NSLog(@"%@",dict[@"comment"]);
        block(comment);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self showError];
    }];
}
#pragma mark 获取版本更新
-(void)getVersionUpdate:(void (^)(id))block{
    __block NSString *versionNum=nil;
    NSString *urlStr=[urlPathStr stringByAppendingString:versionStr];
    NSLog(@"%@",urlStr);
    [[AFHTTPRequestOperationManager manager]GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //解析data  iOS版本
        //NSDictionary *dict=responseObject[@"data"];
        //
        //
        //
        //
        //
        block(versionNum);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self showError];
    }];
}

@end
