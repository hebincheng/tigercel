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
{
    
}
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

volatile int test2_arrivedcount = 0;
int test2_deliveryCompleted = 0;
MQTTClient_message test2_pubmsg = MQTTClient_message_initializer;

void test2_deliveryComplete(void* context, MQTTClient_deliveryToken dt)
{
    ++test2_deliveryCompleted;
}

int test2_messageArrived(void* context, char* topicName, int topicLen, MQTTClient_message* m)
{
    ++test2_arrivedcount;
    myprintf("Callback: %d message received on topic %s is %.*s.",
          test2_arrivedcount, topicName, m->payloadlen, (char*)(m->payload));
    if (test2_pubmsg.payloadlen != m->payloadlen ||
        memcmp(m->payload, test2_pubmsg.payload, m->payloadlen) != 0)
    {
        //failures++;
        myprintf("Error: wrong data received lengths %d %d\n", test2_pubmsg.payloadlen, m->payloadlen);
    }
    MQTTClient_free(topicName);
    MQTTClient_freeMessage(&m);
    return 1;
}

#pragma mark登陆的时候连接到mqttserver
-(void)connectToMQTTServerCallBackBlock:(void (^)(void))block{
    
    
    struct Options
    {
        char connection[100];
        char mutual_auth_connection[100];   /**< connection to system under test. */
        char nocert_mutual_auth_connection[100];
        char server_auth_connection[100];
        char anon_connection[100];
        char** haconnections;         	/**< connection to system under test. */
        int hacount;
        char* client_key_file;
        char* client_key_pass;
        char* server_key_file;
        char* client_private_key_file;
        int verbose;
        int test_no;
        int MQTTVersion;
    } options =
    {
        "tcp://192.168.3.49:1243",
        "ssl://m2m.eclipse.org:18884",
        "ssl://m2m.eclipse.org:18887",
        "ssl://m2m.eclipse.org:18885",
        "ssl://m2m.ec	lipse.org:18886",
        NULL,
        0,
        NULL,
        NULL,
        "../../../test/ssl/test-root-ca.crt",
        NULL,
        0,
        0,
    };
    NSString *keyFilePath=[[NSBundle mainBundle]pathForResource:@"cacert" ofType:@"pem"];
    MYLog(@"%@",keyFilePath);
    NSData *data=[NSData dataWithContentsOfFile:keyFilePath];
    MYLog(@"%s",[data bytes]);

    options.server_key_file=(char *)[keyFilePath UTF8String];
    
    
    
//    struct Options
//    {
//        char* connection;         /**< connection to system under test. */
//        char** haconnections;
//        int hacount;
//        int verbose;
//        int test_no;
//        int MQTTVersion;
//        int iterations;
//    } options =
//    {
//        //"tcp://m2m.eclipse.org:1883",
//        "tcp://192.168.3.49:1243",
//        //"tcp://192.168.12.124:1243",
//        NULL,
//        0,
//        0,
//        0,
//        MQTTVERSION_DEFAULT,
//        1,
//    };
    
    MQTTClient_connectOptions opts = MQTTClient_connectOptions_initializer;
    MQTTClient_willOptions wopts = MQTTClient_willOptions_initializer;
    MQTTClient_SSLOptions sslopts = MQTTClient_SSLOptions_initializer;
    int rc = 0;

    // int failures = 0;
    ZYY_User *user=[ZYY_User instancedObj];

    opts.keepAliveInterval = 20;
    opts.cleansession = 1;
    opts.username = (char *)[user.userToken UTF8String];
    opts.password = (char *)[user.sessionId UTF8String];
    NSLog(@"username:%s---password:%s",opts.username,opts.password);
    opts.MQTTVersion = options.MQTTVersion;
    if (options.haconnections != NULL)
    {
        opts.serverURIs = options.haconnections;
        opts.serverURIcount = options.hacount;
    }
    //
    opts.ssl = &sslopts;
    
    if (options.server_key_file)
        opts.ssl->trustStore = options.server_key_file; /*file of certificates trusted by client*/
    opts.ssl->keyStore = options.client_key_file;  /*file of certificate for client to present to server*/
    if (options.client_key_pass)
        opts.ssl->privateKeyPassword = options.client_key_pass;
    if (options.client_private_key_file)
        opts.ssl->privateKey = options.client_private_key_file;
    
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
        myprintf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&_MQTTClint);
    }
    
    //rc = MQTTClient_setCallbacks(_MQTTClint, NULL, NULL, test2_messageArrived, test2_deliveryComplete);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        myprintf("(rc != MQTTCLIENT_SUCCESS)(%d) in MQTTClient_setCallbacks()\n\n\n\n\n", rc);
        MQTTClient_destroy(&_MQTTClint);
    }
    
    
    myprintf("@@@@@@@@@@@@@@@@@Connecting start\n");
    myprintf("connection : %s\n", options.connection);
    rc = MQTTClient_connect(_MQTTClint, &opts);
    myprintf("@@@@@@@@@@@@@@@@@Connecting finish and start subscribe\n\n\n");
    
    MYLog(@"登陆成功后的mqtt的地址%p",_MQTTClint);
    
    
    
    
    block();
    
    
}
#pragma mark 订阅设备
-(void)subscribeDeviceWithDeviceToken:(NSString *)deviceToken{
    char * test_topic=[self getGenerateTopicWithDeviceToken:deviceToken];
    MYLog(@"%s",test_topic);
    int rc;
    int subsqos = 0;
    rc = MQTTClient_subscribe(_MQTTClint, test_topic, subsqos);
    NSLog(@"%d",rc);
    if(rc==128)
    {
        MYLog(@"订阅设备----失败---rc=%d",rc);
    }
    else if(rc==0||rc==1||rc==2)
    {
        MYLog(@"订阅设备----成功");
    }
}
#pragma mark订阅设备的topic
-(char *)getGenerateTopicWithDeviceToken:(NSString *)deviceToken{
    NSString *topicStr=[NSString stringWithFormat:@"/control_response/user/%@/device/appliance/lamp/%@",[[ZYY_User instancedObj] userToken],deviceToken];
    char *test_topic=(char*)[topicStr UTF8String];
    MYLog(@"%s",test_topic);
    return test_topic;
}
-(void)quit{
    int rc;
    rc = MQTTClient_disconnect(_MQTTClint, 0);
    if(rc==MQTTCLIENT_SUCCESS){
        MYLog(@"Disconnect successful");
    }

    MQTTClient_destroy(&_MQTTClint);
    _MQTTClint =nil;

}
#pragma mark发现新设备时候获取设备详情
-(void)connectToNewDeviceWithIp:(NSString *)ip andPort:(int)port callBackBlock:(void (^)(id data))block {
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
        myprintf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&c);
    }
    myprintf("----------------------Connecting start\n");
    myprintf("connection : %s\n", options.connection);
    rc = MQTTClient_connect(c, &opts);
    if (rc != MQTTCLIENT_SUCCESS)
    {
        myprintf("(rc != MQTTCLIENT_SUCCESS)(%d)\n\n\n\n\n", rc);
        MQTTClient_destroy(&c);
    }
    myprintf("----------------------Connecting finish and start subscribe\n\n\n");
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
    "\"sequence\":55555,"
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
        MYLog(@"%02x",*(myPayload+i));
    }
    
    //
    //    MYLog(@"测试解析后的数据是否能够正确还原-------开始------------");
    //
    //    header_text.retCode=0;
    //    header_text.objId=3;
    //    header_text.operation=2;
    //    int len_text;
    //    len_text = iot_mod_lwm2m_to_json((char *)(myPayload+8), len, &header_text);
    //    myprintf("len=%d\n", len_text);
    //    myprintf("json:\n%s\n", header_text.body);
    
    //    MyLog(LOGA_DEBUG, "%d messages at QoS %d", iterations, qos);
#pragma mark  发出数据----------------------------------
    
    pubmsg.payload = myPayload;
    pubmsg.payloadlen = 8+len;
    pubmsg.qos = 0;
    pubmsg.retained = 0;
    
    NSData *data=[NSData data];//用于接收收到的数据
    
    for (i = 0; i< iterations; ++i)
    {
        if (i % 10 == 0)
            rc = MQTTClient_publish(c, test_topic, pubmsg.payloadlen, pubmsg.payload, pubmsg.qos, pubmsg.retained, &dt);
        else
            rc = MQTTClient_publishMessage(c, test_topic, &pubmsg, &dt);
        
        if(rc != MQTTCLIENT_SUCCESS)
        {
            myprintf("@@@@@(rc != MQTTCLIENT_SUCCESS)1\n");
        }
        
        //        if (0 > 0)
        //        {
        //            rc = MQTTClient_waitForCompletion(c, dt, 5000L);
        //            if(rc != MQTTCLIENT_SUCCESS)
        //            {
        //                myprintf("@@@@@(rc != MQTTCLIENT_SUCCESS)2\n");
        //            }
        //        }
        
        rc = MQTTClient_receive(c, &topicName, &topicLen, &m, 5000);
        if(rc != MQTTCLIENT_SUCCESS)
        {
            myprintf("@@@@@(rc != MQTTCLIENT_SUCCESS)3\n");
        }
#pragma mark读取数据--------------------------------------
        MYLog(@"/---------------------------------------/");
        
        //memcpy(receiveData, m->payload, m->payloadlen);
        MYLog(@"%d",m->payloadlen);
        for (int i=0; i<m->payloadlen; i++)
        {
            MYLog(@"%02x",*((char *)(m->payload)+i));
        }
        
        //        iot_mod_json_lwm2m_header_t *header3;
        //        header3 = (iot_mod_json_lwm2m_header_t *)m->payload;
        
        receive_header.retCode=0;
        receive_header.objId=3;
        receive_header.operation=2;
        
        len = iot_mod_lwm2m_to_json(m->payload+8, m->payloadlen-8, &receive_header);
        
        //myprintf("len=%d\n", len);//body的长度
        //myprintf("json:\n%s\n", receive_header.body);//数据内容
#pragma mark 解析第二阶段收到设备返回的数据
        myprintf("No message received within timeout period1\n");
        data=[NSData dataWithBytes:receive_header.body length:len];
     
     myprintf("No message received within timeout period2\n");
        if (topicName)
        {
            myprintf("No message received within timeout period !!!\n");
            //            MyLog(LOGA_DEBUG, "Message received on topic %s is %.*s", topicName, m->payloadlen, (char*)(m->payload));
            if (pubmsg.payloadlen != m->payloadlen ||
                memcmp(m->payload, pubmsg.payload, m->payloadlen) != 0)
            {
                block(data);
                //failures++;
                //MyLog(LOGA_INFO, "Error: wrong data - received lengths %d %d", pubmsg.payloadlen, m->payloadlen);
                MYLog(@"1111111111111111111111111");
                break;
            }
            MQTTClient_free(topicName);
            MQTTClient_freeMessage(&m);
            block(data);
        }
        else
            myprintf("No message received within timeout period\n");
        myprintf("No message received within timeout period3\n");
        //获取完data后返回data
    }
    /* receive any outstanding messages */
    MQTTClient_receive(c, &topicName, &topicLen, &m, 2000);
    while (topicName)
    {
        myprintf("Message received on topic %s is %.*s.\n", topicName, m->payloadlen, (char*)(m->payload));
        MQTTClient_free(topicName);
        MQTTClient_freeMessage(&m);
        MQTTClient_receive(c, &topicName, &topicLen, &m, 2000);
    }
    //返回data
   
}


#pragma mark mqtt publish/receive函数
-(void)sendRequsetMessageWithContent:(char *)requestContent andTopicString:(char *)topic  andReceiveDatacallBackBlock:(void (^)(id))block{
    _sequence++;
    MQTTClient_deliveryToken dt;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_message* m = NULL;

    //  MYLog(@"%s",requestContent);
    int len;
    iot_mod_json_lwm2m_header_t send_header, receive_header,header_test;
    
    memset(&send_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&receive_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&header_test, 0, sizeof(iot_mod_json_lwm2m_header_t));
    
    len = iot_mod_json_to_lwm2m(requestContent, &send_header);//将请求的内容转化成m2m格式
    MYLog(@"len:%d",len);
    unsigned char myPayload[2048];
    memcpy(myPayload, &send_header.operation, 2);
    memcpy(myPayload+2, &send_header.sequence, 2);
    memcpy(myPayload+4, &send_header.objId, 2);
    memcpy(myPayload+6, &send_header.retCode, 2);
    memcpy(myPayload+8, send_header.body, len);
    
    for (int i=0; i<len+8; i++) {
        MYLog(@"%02x",*(myPayload+i));
    }
    
    int rc;
    char* topicName = NULL;
    int topicLen;
    
    pubmsg.payload = myPayload;
    pubmsg.payloadlen = 8+len;
    pubmsg.qos = 0;
    pubmsg.retained = 0;
    
    rc = MQTTClient_publish(_MQTTClint, topic, pubmsg.payloadlen, pubmsg.payload, pubmsg.qos, pubmsg.retained, &dt);
    MYLog(@"publish---%d",rc);
    rc = MQTTClient_receive(_MQTTClint, &topicName, &topicLen, &m, 5000);
    MYLog(@"receive---%d",rc);
    MYLog(@"%p",m);
    //-----------------------解析接收到的数据
    if (m!=nil)
    {
        
        MYLog(@"m->payloadlen:%d",m->payloadlen);
        for (int i=0; i<m->payloadlen; i++)
        {
            MYLog(@"%02x",*((char *)(m->payload)+i));
        }
        
        //        iot_mod_json_lwm2m_header_t *header3;
        //        header3 = (iot_mod_json_lwm2m_header_t *)m->payload;
        
        receive_header.retCode=0;
        receive_header.objId=3;
        receive_header.operation=2;
        
        int bodyLen = iot_mod_lwm2m_to_json(m->payload+8, m->payloadlen-8, &receive_header);
        
        myprintf("len=%d\n", bodyLen);//body的长度
        myprintf("json:\n%s\n", receive_header.body);//数据内容
        //将数据内容转成data格式并回调
        NSData *data=[NSData dataWithBytes:receive_header.body length:bodyLen];
        
        MYLog(@"%@",data);
        //回调
        
        block(data);
    }
    else{
        block(nil);
    }
    
}

#pragma mark 控制设备的时候获取设备基本状态详情
-(void)getDeviceInfoAndConnectToMQTTWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id))block{
    char *requestContent="{"
    "\"operation\":\"readREQ\","
    "\"sequence\":2222,"
    "\"object\":{"
    "\"objId\":\"device\","
    "\"objInstances\":["
    "{"
    "\"objInstanceId\":\"single\""
    "}"
    "]"
    "}"
    "}";
    
    NSString *topicStr=[NSString stringWithFormat:@"/control_request/device/appliance/lamp/%@/user/%@",deviceToken,[[ZYY_User instancedObj] userToken]];
    char *test_topic=(char*)[topicStr UTF8String];
    MYLog(@"%s",test_topic);
    
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent  andTopicString:test_topic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 1.调节设备亮度
-(void)changeDeviceBrightnessWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block{

    MYLog(@"调节设备亮度");
     NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightBright\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]}]}]}}",_sequence,value];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 2.调节设备色温
-(void)changeDeviceColorWarmWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block{
    MYLog(@"调节设备色温");
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightColorTemp\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]}]}]}}",_sequence,value];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 3.调节设备色温
-(void)changeRespiratoryRateWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block{
    MYLog(@"调节设备色温");
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightBlinkFreq\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]}]}]}}",_sequence,value];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 4.设备颜色
-(void)changeDeviceColorWithDeviceToken:(NSString *)deviceToken andRed:(int)redValue andGreen:(int)greenValue andBlue:(int)blueValue callBackBlock:(void (^)(id data))block{
    MYLog(@"设备颜色");
  //      char *requestContent="{"
//            "\"operation\":\"writeREQ\","
//            "\"sequence\":12345,"
//            "\"object\":{"
//            "\"objId\":\"lamp\","
//            "\"objInstances\":["
//            "{"
//            "\"objInstanceId\":\"single\","
//            "\"resources\":["
//            "{"
//            "\"resId\":\"lightColor\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"red\","
//            "\"dataType\":\"integer\","
//            "\"value\":\"50\""
//            "},"
//            "{"
//            "\"resInstanceId\":\"green\","
//            "\"dataType\":\"integer\","
//            "\"value\":\"50\""
//            "},"
//            "{"
//            "\"resInstanceId\":\"blue\","
//            "\"dataType\":\"integer\","
//            "\"value\":\"50\""
//            "}"
//            "]"
//            "}"
//            "]"
//            "}"
//            "]"
//            "}"
//            "}";
    
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightColor\",\"resInstances\":[{\"resInstanceId\":\"red\",\"dataType\":\"integer\",\"value\":\"%d\"},{\"resInstanceId\":\"green\",\"dataType\":\"integer\",\"value\":\"%d\"},{\"resInstanceId\":\"blue\",\"dataType\":\"integer\",\"value\":\"%d\"}]}]}]}}",_sequence,redValue,greenValue,blueValue];
    
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 5.设置省电模式
-(void)changeDeviceSavingPowerWithDeviceToken:(NSString *)deviceToken trueOrfalse:(char *)trueOrfalse callBackBlock:(void (^)(id data))block{
    MYLog(@"设置省电模式");
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightPowerSaving\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"boolean\",\"value\":\"%s\"}]}]}]}}",_sequence,trueOrfalse];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 6.设置设备开关
-(void)changeDeviceIsOnWithDeviceToken:(NSString *)deviceToken trueOrfalse:(char *)trueOrfalse callBackBlock:(void (^)(id data))block{
    MYLog(@"设置设备开光");
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightSwitch\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"boolean\",\"value\":\"%s\"}]}]}]}}",_sequence,trueOrfalse];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 7.设置设备当前应用的场景的接口
-(void)changeDeviceCurrentSceneWithDeviceToken:(NSString *)deviceToken andValue:(int)value callBackBlock:(void (^)(id data))block{
    //value  是指设备的第几个场景;
    MYLog(@"设置设备当前应用的场景的接口");
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightScenario\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]}]}]}}",_sequence,value];
    char *requestContent=(char *)[requestStr UTF8String];

    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}

#pragma mark 8.设置设备当前应用的工作模式的接口
-(void)changeDeviceCurrentModeWithDeviceToken:(NSString *)deviceToken andModeString:(char *)modeStr callBackBlock:(void (^)(id data))block{
    MYLog(@"设置设备当前应用的工作模式的接口");
    //modeStr  是指设备氛围模式和照明模式 Atmosphere /Light
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"lamp\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"lightMode\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]}]}]}}",_sequence,modeStr];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
//“0101010”，0代表不工作，1代表工作。最高位代表周日，最低位代表周六
#pragma mark 9.为设备添加定时任务
-(void)addDeviceTimeWithDeviceToken:(NSString *)deviceToken startTime:(char *)startTime endTime:(char *)endTime lightScenario:(int)lightScenario workday:(char *)workday callBackBlock:(void (^)(id data))block{
//      char *requestContent="{"
//            "\"operation\":\"createREQ\","
//            "\"sequence\":12345,"
//            "\"object\":{"
//            "\"objId\":\"timer\","
//            "\"objInstances\":["
//            "{"
//            "\"objInstanceId\":0,"
//            "\"resources\":["
//            "{"
//            "\"resId\":\"startTime\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"string\","
//            "\"value\":\"14:01\""
//            "}"
//            "]"
//            "},"
//            "{"
//            "\"resId\":\"endTime\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"string\","
//            "\"value\":\"15:30\""
//            "}"
//            "]"
//            "},"
//            "{"
//            "\"resId\":\"lightScenario\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"integer\","
//            "\"value\":\"0\""
//            "}"
//            "]"
//            "},"
//            "{"
//            "\"resId\":\"weekday\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"string\","
//            "\"value\":\"0101010\""
//            "}"
//            "]"
//            "}"
//            "]"
//            "}"
//            "]"
//            "}"
//            "}";
    MYLog(@"为设备添加定时任务");
    NSString *requestStr =[NSString stringWithFormat:@"{\"operation\":\"createREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"timer\",\"objInstances\":[{\"objInstanceId\":0,\"resources\":[{\"resId\":\"startTime\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]},{\"resId\":\"endTime\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]},{\"resId\":\"lightScenario\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]},{\"resId\":\"weekday\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]}]}]}}",_sequence,startTime,endTime,lightScenario,workday];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 10.删除设备的定时任务
-(void)deleteDeviceTimeWithDeviceToken:(NSString *)deviceToken  andTheTimeNumber:(int)value callBackBlock:(void (^)(id data))block{
    
//    char *aa=
//    "{"
//    "\"operation\":\"deleteREQ\","
//    "\"sequence\":12345,"
//    "\"object\":{"
//    "\"objId\":\"timer\","
//    "\"objInstances\":["
//    "{"
//    "\"objInstanceId\":0"
//    "}"
//    "]"
//    "}"
//    "}";
    
    MYLog(@"为设备删除定时任务");
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"deleteREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"timer\",\"objInstances\":[{\"objInstanceId\":%d}]}}",_sequence,value];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}

#pragma mark 11.开启或者关闭设备的第几组的定时任务
-(void)changeDeviceTimeIsOnWithDeviceToken:(NSString *)deviceToken timeNumber:(int)num trueOrfalse:(char *)trueOrfalse callBackBlock:(void (^)(id data))block{
    MYLog(@"开启或者关闭设备的第几组的定时任务");
//    char *aa=
//    "{"
//    "\"operation\":\"writeREQ\","
//    "\"sequence\":12345,"
//    "\"object\":{"
//    "\"objId\":\"timer\","
//    "\"objInstances\":["
//    "{"
//    "\"objInstanceId\":0,"
//    "\"resources\":["
//    "{"
//    "\"resId\":\"state\","
//    "\"resInstances\":["
//    "{"
//    "\"resInstanceId\":\"single\","
//    "\"dataType\":\"boolean\","
//    "\"value\":\"false\""
//    "}"
//    "]"
//    "}"
//    "]"
//    "}"
//    "]"
//    "}"
//    "}";
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"timer\",\"objInstances\":[{\"objInstanceId\":%d,\"resources\":[{\"resId\":\"state\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"boolean\",\"value\":\"%s\"}]}]}]}}",_sequence,num,trueOrfalse];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 13.获取设备的定时任务列表
-(void)getDeviceTimerArrWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block{
    char *aa=
    "{"
    "\"operation\":\"readREQ\","
    "\"sequence\":33333,"
    "\"object\":{"
    "\"objId\":\"timer\""
    "}"
    "}";
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:aa andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 14.更新设备的定时任务信息
-(void)updateDeviceTimeWithDeviceToken:(NSString *)deviceToken timerNumber:(int)num startTime:(char *)startTime endTime:(char *)endTime lightScenario:(int)lightScenario workday:(char *)workday callBackBlock:(void (^)(id data))block{
//      char *requestContent="{"
//            "\"operation\":\"writeREQ\","
//            "\"sequence\":12345,"
//            "\"object\":{"
//            "\"objId\":\"timer\","
//            "\"objInstances\":["
//            "{"
//            "\"objInstanceId\":0,"
//            "\"resources\":["
//            "{"
//            "\"resId\":\"startTime\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"string\","
//            "\"value\":\"14:01\""
//            "}"
//            "]"
//            "},"
//            "{"
//            "\"resId\":\"endTime\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"string\","
//            "\"value\":\"15:30\""
//            "}"
//            "]"
//            "},"
//            "{"
//            "\"resId\":\"lightScenario\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"integer\","
//            "\"value\":\"0\""
//            "}"
//            "]"
//            "},"
//            "{"
//            "\"resId\":\"weekday\","
//            "\"resInstances\":["
//            "{"
//            "\"resInstanceId\":\"single\","
//            "\"dataType\":\"string\","
//            "\"value\":\"0101010\""
//            "}"
//            "]"
//            "}"
//            "]"
//            "}"
//            "]"
//            "}"
//            "}";
    MYLog(@"为更新设备的定时任务");
    NSString *requestStr =[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"timer\",\"objInstances\":[{\"objInstanceId\":%d,\"resources\":[{\"resId\":\"startTime\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]},{\"resId\":\"endTime\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]},{\"resId\":\"lightScenario\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]},{\"resId\":\"weekday\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]}]}]}}",_sequence,num,startTime,endTime,lightScenario,workday];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];

}
#pragma mark 15.添加设备场景
-(void)addNewDeviceSceneWithDeviceToken:(NSString *)deviceToken name:(char *)name lightMode:(char *)lightMode lightBright:(int)lightBright lightColor_0:(int)lightColor_0 lightColor_1:(int)lightColor_1 lightColor_2:(int)lightColor_2 lightColorTemp:(int)lightColorTemp lightBlinkFreq:(int)lightBlinkFreq lightSwitch:(char *)lightSwitch callBackBlock:(void (^)(id))block{
//    char *aa=
//    "{"
//       "\"operation\":\"createREQ\","
//       "\"sequence\":12345,"
//        "\"object\":{"
//        "\"objId\":\"scenario\","
//        "\"objInstances\":["
//        "{"
//            "\"objInstanceId\":0,"
//            "\"resources\":["
//            "{"
//                "\"resId\":\"name\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":\"single\","
//                    "\"dataType\":\"string\","
//                    "\"value\":\"夕阳\""
//                "}"
//                "]"
//            "},"
//            "{"
//                "\"resId\":\"lightMode\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":\"single\","
//                    "\"dataType\":\"string\","
//                    "\"value\":\"atmosphere\""
//                "}"
//                "]"
//            "},"
//            "{"
//                "\"resId\":\"lightBright\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":\"single\","
//                    "\"dataType\":\"integer\","
//                    "\"value\":\"100\""
//                "}"
//                "]"
//            "},"
//            "{"
//                "\"resId\":\"lightColor\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":0,"
//                    "\"dataType\":\"integer\","
//                    "\"value\":\"100\""
//                "},"
//                "{"
//                    "\"resInstanceId\":1,"
//                    "\"dataType\":\"integer\","
//                    "\"value\":\"100\""
//                "},"
//                "{"
//                    "\"resInstanceId\":2,"
//                    "\"dataType\":\"integer\","
//                    "\"value\":\"100\""
//                "}"
//                "]"
//            "},"
//            "{"
//                "\"resId\":\"lightColorTemp\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":\"single\","
//                    "\"dataType\":\"integer\","
//                    "\"value\":\"100\""
//                "}"
//                "]"
//            "},"
//            "{"
//                "\"resId\":\"lightBlinkFreq\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":\"single\","
//                    "\"dataType\":\"integer\","
//                    "\"value\":\"1\""
//                "}"
//                "]"
//            "},"
//            "{"
//                "\"resId\":\"lightSwitch\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":\"single\","
//                    "\"dataType\":\"boolean\","
//                    "\"value\":\"true\""
//                "}"
//                "]"
//            "}"
//            "]"
//        "}"
//        "]"
//    "}"
//"}";
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"createREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"scenario\",\"objInstances\":[{\"objInstanceId\":0,\"resources\":[{\"resId\":\"name\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]},{\"resId\":\"lightMode\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]},{\"resId\":\"lightBright\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]},{\"resId\":\"lightColor\",\"resInstances\":[{\"resInstanceId\":0,\"dataType\":\"integer\",\"value\":\"%d\"},{\"resInstanceId\":1,\"dataType\":\"integer\",\"value\":\"%d\"},{\"resInstanceId\":2,\"dataType\":\"integer\",\"value\":\"%d\"}]},{\"resId\":\"lightColorTemp\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]},{\"resId\":\"lightBlinkFreq\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"integer\",\"value\":\"%d\"}]},{\"resId\":\"lightSwitch\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"boolean\",\"value\":\"%s\"}]}]}]}}",_sequence,name,lightMode,lightBright,lightColor_0,lightColor_1,lightColor_2,lightColorTemp,lightBlinkFreq,lightSwitch];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 16.删除设备场景
-(void)deleteDeviceSceneWithDeviceToken:(NSString *)deviceToken sceneNumber:(int)num callBackBlock:(void (^)(id data))block{
//    char *aa=
//    "{"
//        "\"operation\":\"deleteREQ\","
//        "\"sequence\":12345,"
//        "\"object\":{"
//        "\"objId\":\"scenario\","
//        "\"objInstances\":["
//        "{"
//            "\"objInstanceId\":0"
//        "}"
//        "]"
//    "}"
//"}"
//"}";
//
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"deleteREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"scenario\",\"objInstances\":[{\"objInstanceId\":%d}]}}}",_sequence,num];
    char *requestContent=(char *)[requestStr UTF8String];
        
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];

}
#pragma mark 17.更新设备场景
-(void)updateDeviceSceneWithDeviceToken:(NSString *)deviceToken sceneNumber:(int)num  sceneName:(char *)name callBackBlock:(void (^)(id data))block
{
//    char *aaaaa=
//        "{"
//        "\"operation\":\"createREQ\","
//        "\"sequence\":12345,"
//        "\"object\":{"
//        "\"objId\":\"scenario\","
//        "\"objInstances\":["
//        "{"
//        "\"objInstanceId\":0,"
//        "\"resources\":["
//        "{"
//        "\"resId\":\"name\","
//        "\"resInstances\":["
//        "{"
//        "\"resInstanceId\":\"single\","
//        "\"dataType\":\"string\","
//        "\"value\":\"zzzzzzz\""
//        "}"
//        "]"
//        "}"
//        "]"
//        "}"
//        "]"
//        "}"
//        "}";
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"createREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"scenario\",\"objInstances\":[{\"objInstanceId\":%d,\"resources\":[{\"resId\":\"name\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]}]}]}}",_sequence,num,name];
    
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}

#pragma mark 18.获取设备场景列表
-(void)getDeviceSceneArrWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block{
    char *aa=
    "{"
    "\"operation\":\"readREQ\","
    "\"sequence\":4444,"
    "\"object\":{"
    "\"objId\":\"scenario\""
    "}"
    "}";
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:aa andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 20.获取设备的单个场景的详细信息
-(void)getDetailDeviceSceneInfoWithDeviceToken:(NSString *)deviceToken sceneNumber:(int)num callBackBlock:(void (^)(id data))block{
//    char *aa=
//        "{"
//        "\"operation\":\"readREQ\","
//        "\"sequence\":12345,"
//        "\"object\":{"
//        "\"objId\":\"scenario\","
//        "\"objInstances\":["
//        "{"
//        "\"objInstanceId\":0"
//        "}"
//        "]"
//        "}"
//        "}";
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"readREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"scenario\",\"objInstances\":[{\"objInstanceId\":%d}]}}",_sequence,num];
    
    char *requestContent=(char *)[requestStr UTF8String];
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 21.获取设备当前的版本号
-(void)getCurrentSofeVersionWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block{
    char *aa=
    "{"
    "\"operation\":\"readREQ\","
    "\"sequence\":12345,"
    "\"object\":{"
    "\"objId\":\"device\","
    "\"objInstances\":["
    "{"
    "\"objInstanceId\":\"single\","
    "\"resources\":["
    "{"
    "\"resId\":\"softwareVersion\""
    "}"
    "]"
    "}"
    "]"
    "}"
    "}";
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:aa andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 22.设备升级命令
-(void)updateDeviceSoftVersionWithDeviceToken:(NSString *)deviceToken  newVersion:(char *)newVersion callBackBlock:(void (^)(id data))block{
//    char *aa=
//    "{"
//        "\"operation\":\"writeREQ\","
//        "\"sequence\":12345,"
//        "\"object\":{"
//        "\"objId\":\"device\","
//        "\"objInstances\":["
//        "{"
//            "\"objInstanceId\":\"single\","
//            "\"resources\":["
//            "{"
//            "\"resId\":\"softwareVersion\","
//                "\"resInstances\":["
//                "{"
//                    "\"resInstanceId\":\"single\","
//                    "\"dataType\":\"string\","
//                    "\"value\":\"newVersion\""
//                "}"
//                "]"
//                "}"
//                "]"
//            "}"
//            "]"
//        "}"
//    "}";
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"writeREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"device\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"softwareVersion\",\"resInstances\":[{\"resInstanceId\":\"single\",\"dataType\":\"string\",\"value\":\"%s\"}]}]}]}}",_sequence,newVersion];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}
#pragma mark 23.取消设备升级
-(void)cancelDeviceUpdateWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block{
    char *aa=
    "{"
    "\"operation\":\"updateCancel\","
    "\"sequence\":12345,"
    "\"devToken\":\"zzzzzzzzzzzzzz\""
    "}";
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:aa andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];
}

#pragma mark 24.获取升级结果
-(void)getDeviceUpdateResultWithDeviceToken:(NSString *)deviceToken callBackBlock:(void (^)(id data))block{
//        char *aa=
//        "{"
//            "\"operation\":\"readREQ\","
//            "\"sequence\":12345,"
//            "\"object\":{"
//            "\"objId\":\"update\","
//            "\"objInstances\":["
//            "{"
//                "\"objInstanceId\":\"single\","
//                "\"resources\":["
//                "{"
//                "\"resId\":\"UpdateResult\""
//                    "}"
//                    "]"
//                "}"
//                "]"
//            "}"
//        "}";
    NSString *requestStr=[NSString stringWithFormat:@"{\"operation\":\"readREQ\",\"sequence\":%ld,\"object\":{\"objId\":\"device\",\"objInstances\":[{\"objInstanceId\":\"single\",\"resources\":[{\"resId\":\"softwareVersion\"}]}]}}",_sequence];
    char *requestContent=(char *)[requestStr UTF8String];
    
    char *requestTopic=[self getGenerateTopicWithDeviceToken:deviceToken];
    //调用mqtt publish发送请求
    [self sendRequsetMessageWithContent:requestContent andTopicString:requestTopic andReceiveDatacallBackBlock:^(id data) {
        block(data);
    }];

}

@end
