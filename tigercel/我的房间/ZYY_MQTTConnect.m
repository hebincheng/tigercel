//
//  ZYY_MQTTConnect.m
//  tigercel
//
//  Created by 虎符通信 on 16/2/18.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_User.h"
#import "ZYY_MQTTConnect.h"
#import "iot_mod_lwm2m.h"
#import "iot_mod_lwm2m_json.h"

static ZYY_MQTTConnect *_instancedObj;

@implementation ZYY_MQTTConnect

#pragma mark-
#pragma mark单例
+(id)instancedObj{
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        _instancedObj=[[ZYY_MQTTConnect alloc]init];
    });
    return _instancedObj;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instancedObj=[super allocWithZone:zone];
    });
    return _instancedObj;
}
#pragma mark-
#pragma mark登陆的时候连接到mqttserver
-(void)connectToMQTTServerBlock:(void (^)(void))block{
    struct Options
    {
        char* connection;         /**< connection to system under test. */
        char** haconnections;
        int hacount;
        int verbose;
        int test_no;
        int MQTTVersion;
        int iterations;
    } options =
    {
        //"tcp://m2m.eclipse.org:1883",
        "tcp://192.168.3.49:1243",
        //"tcp://192.168.12.157:1243",
        NULL,
        0,
        0,
        0,
        MQTTVERSION_DEFAULT,
        1,
    };
    
    MQTTClient_connectOptions opts = MQTTClient_connectOptions_initializer;
    MQTTClient_willOptions wopts = MQTTClient_willOptions_initializer;
    int subsqos = 2;
    int rc = 0;
    char* test_topic = "/control_response/user/uuuuuuuuuussssssssssrrrrrr000213/device/appliance/lamp/";
    // int failures = 0;
    
    
    opts.keepAliveInterval = 20;
    opts.cleansession = 1;
    opts.username = "uuuuuuuuuussssssssssrrrrrr000213";
    opts.password = "papapapa";
    opts.MQTTVersion = options.MQTTVersion;
    if (options.haconnections != NULL)
    {
        opts.serverURIs = options.haconnections;
        opts.serverURIcount = options.hacount;
    }
    
    opts.will = &wopts;
    opts.will->message = "will message";
    opts.will->qos = 1;
    opts.will->retained = 0;
    opts.will->topicName = "will topic";
    opts.will = NULL;
    //1  创建MQTTClient
    rc = MQTTClient_create(&_MQTTClint, options.connection, "single_threaded_test",
                           MQTTCLIENT_PERSISTENCE_DEFAULT, NULL);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        printf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&_MQTTClint);
    }
    
    printf("@@@@@@@@@@@@@@@@@Connecting start\n");
    printf("connection : %s\n", options.connection);
    rc = MQTTClient_connect(_MQTTClint, &opts);
    printf("@@@@@@@@@@@@@@@@@Connecting finish and start subscribe\n\n\n");
    rc = MQTTClient_subscribe(_MQTTClint, test_topic, subsqos);
    printf("@@@@@@@@@@@@@@@@@subscribe finish\n\n\n");
    NSLog(@"登陆成功后的mqtt的地址%p",_MQTTClint);
    block();
}
#pragma mark-
#pragma mark发现新设备时候获取设备详情
-(void)connectToNewDeviceWithIp:(NSString *)ip andPort:(int)port block:(void (^)(id data))block {
    struct Options
    {
        char* connection;         /**< connection to system under test. */
        char** haconnections;
        int hacount;
        int verbose;
        int test_no;
        int MQTTVersion;
        int iterations;
    } options =
    {
        "tcp://192.168.12.182:1883",
        NULL,
        0,
        0,
        0,
        MQTTVERSION_DEFAULT,
        1,
    };
    //    NSString *connectStr=[NSString stringWithFormat:@"tcp://%@:%d",ip,port];
    //    options.connection=(char *)[connectStr UTF8String];
    MQTTClient c;
    MQTTClient_connectOptions opts = MQTTClient_connectOptions_initializer;
    MQTTClient_willOptions wopts = MQTTClient_willOptions_initializer;
    //  int subsqos = 2;
    int rc = 0;
    char* test_topic ="lwm2mProtocol";//用于连接设备
    // int failures = 0;
    
    
    opts.keepAliveInterval = 20;
    opts.cleansession = 1;
    opts.username = "guest";        //连到设备的账户名 密码
    opts.password = "guest";
    opts.MQTTVersion = options.MQTTVersion;
    if (options.haconnections != NULL)
    {
        opts.serverURIs = options.haconnections;
        opts.serverURIcount = options.hacount;
    }
    
    opts.will = &wopts;
    opts.will->message = "will message";
    opts.will->qos = 1;
    opts.will->retained = 0;
    opts.will->topicName = "will topic";
    opts.will = NULL;
    
    rc = MQTTClient_create(&c, options.connection, "single_threaded_test",
                           MQTTCLIENT_PERSISTENCE_DEFAULT, NULL);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        printf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&c);
    }
    printf("----------------------Connecting start\n");
    printf("connection : %s\n", options.connection);
    rc = MQTTClient_connect(c, &opts);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        printf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&c);
    }
    printf("----------------------Connecting finish and start subscribe\n\n\n");
    MQTTClient_deliveryToken dt;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_message* m = NULL;
    char* topicName = NULL;
    int topicLen;
    int i = 0;
    int iterations = 50;
    //------------------------------------------待解析的数据
    char sendContent[] = "{"
    "\"operation\":\"readREQ\","
    "\"sequence\":12345,"
    "\"object\":{"
    "\"objId\":\"device\","
    "\"objInstances\":["
    "{"
    "\"objInstanceId\":\"single\","
    "\"resources\":["
    "{\"resId\":\"MAC\"},"
    "{\"resId\":\"manufacturer\"},"
    "{\"resId\":\"deviceType\"},"
    "{\"resId\":\"moduleNumber\"},"
    "{\"resId\":\"serialNumber\"},"
    "{\"resId\":\"hardwareVersion\"},"
    //    "{\"resId\":\"firmwareVersion\"},"//无法反馈对应数据
    "{\"resId\":\"softwareVersion\"},"
    "{\"resId\":\"rebindFlag\"}"
    "]"
    "}"
    "]"
    "}"
    "}";
    int len;
    iot_mod_json_lwm2m_header_t send_header, receive_header,header_test;
    
    memset(&send_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&receive_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&header_test, 0, sizeof(iot_mod_json_lwm2m_header_t));
    
    len = iot_mod_json_to_lwm2m(sendContent, &send_header);//将json格式转化成m2m格式
    unsigned char myPayload[2048];
    
    memcpy(myPayload, &send_header.operation, 2);
    memcpy(myPayload+2, &send_header.sequence, 2);
    memcpy(myPayload+4, &send_header.objId, 2);
    memcpy(myPayload+6, &send_header.retCode, 2);
    memcpy(myPayload+8, send_header.body, len);
    
    for (int i=0; i<len+8; i++) {
        NSLog(@"%02x",*(myPayload+i));
    }
    
    //
    //    NSLog(@"测试解析后的数据是否能够正确还原-------开始------------");
    //
    //    header_text.retCode=0;
    //    header_text.objId=3;
    //    header_text.operation=2;
    //    int len_text;
    //    len_text = iot_mod_lwm2m_to_json((char *)(myPayload+8), len, &header_text);
    //    printf("len=%d\n", len_text);
    //    printf("json:\n%s\n", header_text.body);
    
    
    //    MyLog(LOGA_DEBUG, "%d messages at QoS %d", iterations, qos);
#pragma mark  发出数据----------------------------------
    
    pubmsg.payload = myPayload;
    pubmsg.payloadlen = 8+len;
    pubmsg.qos = 0;
    pubmsg.retained = 0;
    
    for (i = 0; i< iterations; ++i)
    {
        if (i % 10 == 0)
            rc = MQTTClient_publish(c, test_topic, pubmsg.payloadlen, pubmsg.payload, pubmsg.qos, pubmsg.retained, &dt);
        else
            rc = MQTTClient_publishMessage(c, test_topic, &pubmsg, &dt);
        
        if(rc != MQTTCLIENT_SUCCESS)
        {
            printf("@@@@@(rc != MQTTCLIENT_SUCCESS)1\n");
        }
        
        //        if (0 > 0)
        //        {
        //            rc = MQTTClient_waitForCompletion(c, dt, 5000L);
        //            if(rc != MQTTCLIENT_SUCCESS)
        //            {
        //                printf("@@@@@(rc != MQTTCLIENT_SUCCESS)2\n");
        //            }
        //        }
        
        rc = MQTTClient_receive(c, &topicName, &topicLen, &m, 5000);
        if(rc != MQTTCLIENT_SUCCESS)
        {
            printf("@@@@@(rc != MQTTCLIENT_SUCCESS)3\n");
        }
#pragma mark读取数据--------------------------------------
        NSLog(@"/---------------------------------------/");
        
        //memcpy(receiveData, m->payload, m->payloadlen);
        NSLog(@"%d",m->payloadlen);
        for (int i=0; i<m->payloadlen; i++)
        {
            NSLog(@"%02x",*((char *)(m->payload)+i));
        }
        
        //        iot_mod_json_lwm2m_header_t *header3;
        //        header3 = (iot_mod_json_lwm2m_header_t *)m->payload;
        
        receive_header.retCode=0;
        receive_header.objId=3;
        receive_header.operation=2;
        
        len = iot_mod_lwm2m_to_json(m->payload+8, m->payloadlen-8, &receive_header);
        
        //printf("len=%d\n", len);//body的长度
        //printf("json:\n%s\n", receive_header.body);//数据内容
#pragma mark 解析第二阶段收到设备返回的数据
        NSData *data=[NSData dataWithBytes:receive_header.body length:len];
        //返回data
        block(data);
        if (topicName)
        {
            //            MyLog(LOGA_DEBUG, "Message received on topic %s is %.*s", topicName, m->payloadlen, (char*)(m->payload));
            if (pubmsg.payloadlen != m->payloadlen ||
                memcmp(m->payload, pubmsg.payload, m->payloadlen) != 0)
            {
                //                failures++;
                //                MyLog(LOGA_INFO, "Error: wrong data - received lengths %d %d", pubmsg.payloadlen, m->payloadlen);
                break;
            }
            MQTTClient_free(topicName);
            MQTTClient_freeMessage(&m);
        }
        else
            printf("No message received within timeout period\n");
    }
    
    /* receive any outstanding messages */
    MQTTClient_receive(c, &topicName, &topicLen, &m, 2000);
    while (topicName)
    {
        printf("Message received on topic %s is %.*s.\n", topicName, m->payloadlen, (char*)(m->payload));
        MQTTClient_free(topicName);
        MQTTClient_freeMessage(&m);
        MQTTClient_receive(c, &topicName, &topicLen, &m, 2000);
    }

}

#pragma mark-
#pragma mark mqtt publish/receive函数
-(void)sendRequsetMessageWithContent:(char *)requestContent DeviceToken:(NSString *)deviceToken andReceiveDataBlock:(void (^)(id))block{
    NSLog(@"首页的mqtt的地址%p",_MQTTClint);
    MQTTClient_deliveryToken dt;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_message* m = NULL;
    //把deviceToken转成char*
    NSString *topicStr=[NSString stringWithFormat:@"/control_request/device/appliance/lamp/%@/user/%@",deviceToken,[[ZYY_User instancedObj] userToken]];
    char *test_topic=(char*)[topicStr UTF8String];
    NSLog(@"%s",test_topic);
    //读取灯的基本信息
    
    //  NSLog(@"%s",requestContent);
    int len;
    iot_mod_json_lwm2m_header_t send_header, receive_header,header_test;
    
    memset(&send_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&receive_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&header_test, 0, sizeof(iot_mod_json_lwm2m_header_t));
    
    len = iot_mod_json_to_lwm2m(requestContent, &send_header);//将请求的内容转化成m2m格式
    NSLog(@"len:%d",len);
    unsigned char myPayload[2048];
    memcpy(myPayload, &send_header.operation, 2);
    memcpy(myPayload+2, &send_header.sequence, 2);
    memcpy(myPayload+4, &send_header.objId, 2);
    memcpy(myPayload+6, &send_header.retCode, 2);
    memcpy(myPayload+8, send_header.body, len);
    
    for (int i=0; i<len+8; i++) {
        NSLog(@"%02x",*(myPayload+i));
    }
    
    int rc;
    char* topicName = NULL;
    int topicLen;
    
    pubmsg.payload = myPayload;
    pubmsg.payloadlen = 8+len;
    pubmsg.qos = 0;
    pubmsg.retained = 0;
    
    rc = MQTTClient_publish(_MQTTClint, test_topic, pubmsg.payloadlen, pubmsg.payload, pubmsg.qos, pubmsg.retained, &dt);
    NSLog(@"publish---%d",rc);
    rc = MQTTClient_receive(_MQTTClint, &topicName, &topicLen, &m, 5000);
    NSLog(@"receive---%d",rc);
    NSLog(@"%p",m);
    //-----------------------解析接收到的数据
    if (m!=nil)
    {
        
        NSLog(@"m->payloadlen:%d",m->payloadlen);
        for (int i=0; i<m->payloadlen; i++)
        {
            NSLog(@"%02x",*((char *)(m->payload)+i));
        }
        
        //        iot_mod_json_lwm2m_header_t *header3;
        //        header3 = (iot_mod_json_lwm2m_header_t *)m->payload;
        
        receive_header.retCode=0;
        receive_header.objId=3;
        receive_header.operation=2;
        
        int bodyLen = iot_mod_lwm2m_to_json(m->payload+8, m->payloadlen-8, &receive_header);
        
        printf("len=%d\n", bodyLen);//body的长度
        printf("json:\n%s\n", receive_header.body);//数据内容
        //将数据内容转成data格式并回调
        NSData *data=[NSData dataWithBytes:receive_header.body length:bodyLen];
        //回调
        block(data);
    }
    else{
        NSLog(@"未收到返回数据");
    }
    
}


#pragma mark-
#pragma mark 控制设备的时候获取设备状态详情
-(void)getDeviceInfoAndConnectToMQTTWithDeviceToken:(NSString *)deviceToken block:(void (^)(id))block{
    char *requestContent="{"
    "\"operation\":\"readREQ\","
    "\"sequence\":12345,"
    "\"object\":{"
    "\"objId\":\"device\","
    "\"objInstances\":["
    "{"
    "\"objInstanceId\":\"single\""
    "}"
    "]"
    "}"
    "}";
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent DeviceToken:deviceToken andReceiveDataBlock:^(id data) {
        block(data);
    }];
}

@end
