//
//  ZYY_GetInfoFromInternet.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/20.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_GetInfoFromInternet.h"
#import "AFHTTPSessionManager.h"
#import "ZYY_User.h"
#import "ZYY_LED.h"

static NSString *urlPathStr=@"http://115.159.94.136:8080/";//基础url
static NSString *userReglationStr=@"hufu/app/protocol/protocolDetail.do?";//使用条例-版本说明-注册协议
static NSString *versionStr=@"hufu/app/andriod/getAndroidVersion.do?";//版本更新 此处是安卓版本url
static NSString *feedBackStr=@"hufu/app/feedback/addFeedBack.do?";//反馈发送请求
static NSString *loginStr=@"hufu/app/member/login.do?";//登陆请求
static NSString *logoutStr=@"hufu/app/member/logout.do?";//注销登录
static NSString *getListStr=@"hufu/app/userdevice/searchUserDevice.do?";//获取设备列表
static NSString *deleteStr=@"hufu/app/userdevice/deleteUserDevice.do?";//删除设备
static NSString *sendYZMStr=@"hufu/app/common/getAuthCode.do?";//发送验证码
static NSString *registStr=@"hufu/app/member/regist.do?";//注册接口
static NSString *commitUserInfo=@"hufu/app/member/updateUserInfo.do?";//修改信息接口
static NSString *addDeviceStr=@"hufu/app/userdevice/addUserDevice.do?";//添加设备
static NSString *shareDeviceStr=@"hufu/app/share/addShare.do?";//分享

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
#pragma mark注册协议
-(void)registProrocolView:(void (^)(id))block{
    __block NSString *comment=nil;
    NSString *urlStr=[urlPathStr stringByAppendingString:userReglationStr];
    NSDictionary *requestDict=@{@"type":@1} ;
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //解析data
         NSDictionary *dict=responseObject[@"data"];
         comment=dict[@"comment"];
         NSLog(@"%@",dict[@"comment"]);
         block(comment);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self showError];
     }];
}
#pragma mark 分享设备
-(void)shareDeviceWithSharePhone:(NSString *)sharePhone andSessionId:(NSString *)sessionId andDeviceToken:(NSString *)deviceToken andDeviceId:(NSString *)deviceId andUserId:(NSString *)userId and:(void (^)(id))block{
    NSString *urlStr=[urlPathStr stringByAppendingString:shareDeviceStr];
    NSDictionary *requestDict=@{@"sharePhone":sharePhone,@"sessionId":sessionId,@"deviceToken":deviceToken,@"deviceId":deviceId,@"userId":userId};
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"0"])
        {
            NSLog(@"分享出现错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];

}

#pragma mark 添加设备
-(void)addEquipmentWithDeviceModel:(NSString *)deviceModel andSoftWareNumber:(NSString *)softWareNumber andDeviceName:(NSString *)deviceName andSessionId:(NSString *)sessionId andDeviceType:(NSString *)deviceType andDeviceId:(NSString *)deviceId andUserId:(NSString *)userId{
    NSString *urlStr=[urlPathStr stringByAppendingString:addDeviceStr];
    NSDictionary*requestDct=@{@"deviceModel":deviceModel,@"softWareNumber":softWareNumber,@"deviceName":deviceName,@"sessionId":sessionId,@"deviceType":deviceType,@"deviceId":deviceId,@"userId":userId};
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDct progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"])
        {
            NSLog(@"设备添加成功");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
}

#pragma mark 修改个人信息
-(void)commitUserInformationWithBirthdate:(NSString *)birthdate andSex:(NSString *)sex andSessionId:(NSString *)sessionId andAddress:(NSString *)address andUserToken:(NSString *)userToken{
    NSString *urlStr=[urlPathStr stringByAppendingString:commitUserInfo];
    NSDictionary *requestDict=@{@"birthdate":birthdate,@"sex":sex,@"sessionId":sessionId,@"address":address,@"userToken":userToken};
    NSLog(@"%@--%@",birthdate,address);
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"])
        {
            NSDictionary *dict=responseObject[@"data"];
          ZYY_User *user=[[ZYY_User alloc]initWithDictionary:dict];
            NSLog(@"%@",user);
            NSLog(@"信息修改成功");
        }
        else{
            NSLog(@"shibai");
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }];

}

#pragma mark注册账号
-(void)registAccountWithEmailAddress1:(NSString *)email andPassword:(NSString *)password andUserName:(NSString *)userName andMobileNumber:(NSString *)mobileNumber andAuthCode:(NSString *)authCode and:(void (^)(id))block{
    NSString *urlStr=[urlPathStr stringByAppendingString:registStr];
    NSDictionary *requsetDict=@{@"emailAddress1":email,@"password":password,@"userName":userName,@"mobileNumber":mobileNumber,@"authCode":authCode};
[[AFHTTPSessionManager manager]GET:urlStr parameters:requsetDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"%@",responseObject);
        block(responseObject[@"status"]);
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    [self showError];
}];
}

#pragma mark 发送验证码
-(void)sendYZMWithTelNumber:(NSString *)telNumber
{
    NSString *urlStr=[urlPathStr stringByAppendingString:sendYZMStr];
    NSDictionary *requsetDict=@{@"type":@"1",@"mobileNumber":telNumber};
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requsetDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
}

#pragma mark 删除设备
-(void)deleteEquipmentWithSessiosID:(NSString *)sessionID andDeviceToken:(NSString *)deviceToken andUserId:(NSString *)userId{
    NSString *urlSr=[urlPathStr stringByAppendingString:deleteStr];
    NSDictionary *requsetDict=@{@"sessionId":sessionID,@"deviceToken":deviceToken,@"userId":userId};
    [[AFHTTPSessionManager manager]GET:urlSr parameters:requsetDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除设备--%@",responseObject[@"msg"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
}

#pragma mark 获取设备列表
-(void)getEquipmentListWithSessionID:(NSString *)sessionId andUserID:(NSString *)userID and:(void (^)(NSArray *))block{
    NSString *urlStr=[urlPathStr stringByAppendingString:getListStr];
    NSDictionary *requestDict=@{@"sessionId":sessionId,@"userId":userID};
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"] isKindOfClass:[NSNull class]])
        {
            NSLog(@"123");
        }
        else
        {
            NSArray *arr=responseObject[@"data"];
            NSArray *listArr=[ZYY_LED getEquipmentListWithArr:arr];
            block(listArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
}

#pragma mark 注销登录
-(void)logoutSessionID:(NSString *)sessionId andUserID:(NSString *)userID and:(void (^)(void))block{
    NSString *urlStr=[urlPathStr stringByAppendingString:logoutStr];
    NSDictionary *requestDict=@{@"sessionId":sessionId,@"userId":userID};
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *str=responseObject[@"status"];
            NSLog(@"%@",str);
            block();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
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
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requeseDict progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict=responseObject[@"data"];
        if (![dict isKindOfClass:[NSNull class]])
        {
            ZYY_User *user=[[ZYY_User alloc]initWithDictionary:dict];
            NSLog(@"用户邮箱%@",user.emailAddress1);
            block();
        }
        else{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号或者密码不正确，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self showError];
    }];
}

#pragma mark 发送反馈
-(void)feddBackWithComment:(NSString *)commentStr andTitle:(NSString *)titleStr andUserID:(NSString *)userID and:(void (^)(void))block
{
    NSString *urlStr=[urlPathStr stringByAppendingString:feedBackStr];
    NSDictionary *requestDict=@{@"feedBackComment":commentStr,@"feedBackTitle":titleStr,@"userId":userID};
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject!=nil)
        {
            block();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
}


#pragma mark 获取版本
-(void)getVersionExplain:(void (^)(id))block{
    __block NSString *comment=nil;
    NSString *urlStr=[urlPathStr stringByAppendingString:userReglationStr];
    NSDictionary *requestDict=@{@"type":@2} ;
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        //解析data
        NSDictionary *dict=responseObject[@"data"];
        comment=dict[@"comment"];
        NSLog(@"%@",dict[@"comment"]);
        block(comment);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
}
#pragma mark 获取使用条例
-(void)getUserReglation:(void (^)(id))block
{
    __block NSString *comment=nil;
    NSString *urlStr=[urlPathStr stringByAppendingString:userReglationStr];
    NSDictionary *requestDict=@{@"type":@3} ;
    [[AFHTTPSessionManager manager]GET:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //解析data
         NSDictionary *dict=responseObject[@"data"];
         comment=dict[@"comment"];
         NSLog(@"%@",dict[@"comment"]);
         block(comment);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self showError];
     }];
}
#pragma mark 获取版本更新
-(void)getVersionUpdate:(void (^)(id))block{
    __block NSString *versionNum=nil;
    NSString *urlStr=[urlPathStr stringByAppendingString:versionStr];
    NSLog(@"%@",urlStr);
    [[AFHTTPSessionManager manager]GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析data  iOS版本
        //NSDictionary *dict=responseObject[@"data"];
        //
        //
        //
        //
        //
        block(versionNum);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError];
    }];
}

@end
