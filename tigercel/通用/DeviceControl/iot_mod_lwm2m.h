/*******************************************************************************
 *
 * Copyright (c) 2013, 2014 Intel Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution.
 *
 * The Eclipse Public License is available at
 *    http://www.eclipse.org/legal/epl-v10.html
 * The Eclipse Distribution License is available at
 *    http://www.eclipse.org/org/documents/edl-v10.php.
 *
 * Contributors:
 *    David Navarro, Intel Corporation - initial API and implementation
 *    Fabien Fleutot - Please refer to git log
 *    Simon Bernard - Please refer to git log
 *    Toby Jaffey - Please refer to git log
 *    Julien Vermillard - Please refer to git log
 *    Bosch Software Innovations GmbH - Please refer to git log
 *    Pascal Rieux - Please refer to git log
 *******************************************************************************/

/*                                                                             
 * Copyright(c) 2015 Tigercel Communication Technologies Co., Ltd              
 * All rights reserved.                                                        
 *                                                                             
 * System : IOT Platform                                                       
 * Title  : iot_mod_lwm2m.h                                                       
 * RCS ID : $Date:  $                                                          
 *  $Author:  $                                                                
 *  $Revision:  $                                                              
 */                                                                            
                                                                               
#ifndef _IOT_MOD_LWM2M_H_
#define _IOT_MOD_LWM2M_H_
                                                                                 
/*****************************************************************************/  
/*    INCLUDE FILE DECLARATIONS                                              */
/*****************************************************************************/ 
#include <stdint.h>     

#include "cJSON.h"
#include <stdbool.h>
                                                                                 
/*****************************************************************************/  
/*    DEFINE DECLARATIONS                                                    */
/*****************************************************************************/  
#define LWM2M_RET_OK 0
#define LWM2M_RET_IGNORE 1

#define LWM2M_RET_CREATED 0x41
#define LWM2M_RET_DELETED 0x42
#define LWM2M_RET_CHANGED 0x44
#define LWM2M_RET_CONTENT 0x45

#define LWM2M_RET_BAD_REQUEST 0x80
#define LWM2M_RET_UNAUTHORIZED 0x81
#define LWM2M_RET_NOT_FOUND 0x84
#define LWM2M_RET_METHOD_NOT_ALLOW 0x85
#define LWM2M_RET_NOT_ACCEPTABLE 0x86

#define LWM2M_RET_INTERNAL_SERVER_ERROR 0xA0
#define LWM2M_RET_NOT_IMPLEMENT 0xA1
#define LWM2M_RET_SERVICE_UNAVAILABLE 0xA2

/* Standard object Id */
#define LWM2M_SECURITY_OBJECT_ID            0
#define LWM2M_SERVER_OBJECT_ID              1
#define LWM2M_ACL_OBJECT_ID                 2
#define LWM2M_DEVICE_OBJECT_ID              3
#define LWM2M_CONN_MONITOR_OBJECT_ID        4
#define LWM2M_FIRMWARE_UPDATE_OBJECT_ID     5
#define LWM2M_LOCATION_OBJECT_ID            6
#define LWM2M_CONN_STATS_OBJECT_ID          7

/* Tigercel Private object Id */
#define LWM2M_LAMP_OBJECT_ID 10241
#define LWM2M_SCENARIO_OBJECT_ID 10242
#define LWM2M_TIMER_OBJECT_ID 10243

/* Discovery object ID */
#define LWM2M_DISCOVERY_OBJECT_ID 10301

#define LWM2M_MAX_OBJECT_ID 65535

/* Standard Resources Ids for LWM2M Device Object */
#define LWM2M_DEVICE_MANUFACTURER_ID 0
#define LWM2M_DEVICE_MODEL_NUMBER_ID 1
#define LWM2M_DEVICE_SERIAL_NUMBER_ID 2
#define LWM2M_DEVICE_FIRMWARE_VERSION_ID 3
#define LWM2M_DEVICE_REBOOT_ID 4
#define LWM2M_DEVICE_FACTORY_RESET_ID 5
#define LWM2M_DEVICE_AVAILABLE_POWER_SOURCES_ID 6
#define LWM2M_DEVICE_POWER_SOURCE_VOLTAGE_ID 7
#define LWM2M_DEVICE_POWER_SOURCE_CURRENT_ID 8
#define LWM2M_DEVICE_BATTERY_LEVEL_ID 9
#define LWM2M_DEVICE_MEMORY_FREE_LEVEL_ID 10
#define LWM2M_DEVICE_ERROR_CODE_ID 11
#define LWM2M_DEVICE_RESET_ERROR_CODE_ID 12
#define LWM2M_DEVICE_CURRENT_TIME_ID 13
#define LWM2M_DEVICE_UTC_OFFSET_ID 14
#define LWM2M_DEVICE_TIMEZONE_ID 15
#define LWM2M_DEVICE_SUPPORTED_BAM_ID 16
#define LWM2M_DEVICE_DEVICE_TYPE_ID 17
#define LWM2M_DEVICE_HARDWARE_VERSION_ID 18
#define LWM2M_DEVICE_SOFTWARE_VERSION_ID 19
#define LWM2M_DEVICE_BATTERY_STATUS_ID 20
#define LWM2M_DEVICE_MEMORY_TOTAL_ID 21

#define LWM2M_DEVICE_UTC_OFFSET_MAX_LEN 8
#define LWM2M_DEVICE_DEV_TOKEN_MAX_LEN 32
#define LWM2M_DEVICE_USR_TOKEN_MAX_LEN 32

/* Private Resources Ids for LWM2M Device Object */
#define LWM2M_DEVICE_MAC_ID 22
#define LWM2M_DEVICE_IP_ID 23
#define LWM2M_DEVICE_DEV_TOKEN_ID 24
#define LWM2M_DEVICE_REBIND_FLAG_ID 25

#define LWM2M_DEVICE_MAC_MAX_LEN 17
#define LWM2M_DEVICE_IP_MAX_LEN 15

/* Resource Ids for LWM2M Lamp Object */
#define LWM2M_LAMP_LIGHT_MODE_ID 0
#define LWM2M_LAMP_LIGHT_BRIGHT_ID 1
#define LWM2M_LAMP_LIGHT_COLOR_ID 2
#define LWM2M_LAMP_LIGHT_COLOR_TEMP 3
#define LWM2M_LAMP_LIGHT_BLINK_FREQ_ID 4
#define LWM2M_LAMP_LIGHT_STATE_ID 5
#define LWM2M_LAMP_LIGHT_SCENARIO_ID 6
#define LWM2M_LAMP_LIGHT_POWER_SAVING_ID 7

/* Resource Ids for LWM2M Scenario Object */
#define LWM2M_SCENARIO_NAME_ID 0
#define LWM2M_SCENARIO_LIGHT_MODE_ID 1
#define LWM2M_SCENARIO_LIGHT_BRIGHT_ID 2
#define LWM2M_SCENARIO_LIGHT_COLOR_ID 3
#define LWM2M_SCENARIO_LIGHT_COLOR_TEMP_ID 4
#define LWM2M_SCENARIO_LIGHT_BLINK_FREQ_ID 5
#define LWM2M_SCENARIO_LIGHT_STATE_ID 6

/* Resource instance id for color  */
#define LWM2M_RESINSTANCE_LIGHT_COLOR_R_ID 0
#define LWM2M_RESINSTANCE_LIGHT_COLOR_G_ID 1
#define LWM2M_RESINSTANCE_LIGHT_COLOR_B_ID 2

/* Resources Ids for LWM2M Timer Object */
#define LWM2M_TIMER_ACTIVE_ID 0
#define LWM2M_TIMER_WEEKDAY_MAP_ID 1
#define LWM2M_TIMER_START_TIME_ID 2
#define LWM2M_TIMER_END_TIME_ID 3
#define LWM2M_TIMER_LIGHT_SCENARIO_ID 4

/* Resources Ids for LWM2M Discovery Object */
#define LWM2M_DISCOVERY_SOURCE_IP_ID 0
#define LWM2M_DISCOVERY_SOURCE_PORT_ID 1
#define LWM2M_DISCOVERY_TIMESTAMP_ID 2


#define LWM2M_LIST_ADD(H,N) lwm2m_list_add((lwm2m_list_t *)H, (lwm2m_list_t *)N);
#define LWM2M_LIST_FIND(H,I) lwm2m_list_find((lwm2m_list_t *)H, I)
#define LWM2M_LIST_RM(H,I,N) lwm2m_list_remove((lwm2m_list_t *)H, I, (lwm2m_list_t **)N);
#define LWM2M_LIST_FREE(H) lwm2m_list_free((lwm2m_list_t *)H)

/*
 * TLV
 */

#define LWM2M_TLV_HEADER_MAX_LENGTH 6

/*
 * Bitmask for the lwm2m_tlv_t::flag
 * LWM2M_TLV_FLAG_STATIC_DATA specifies that lwm2m_tlv_t::value
 * points to static memory and must no be freeed by the caller.
 * LWM2M_TLV_FLAG_TEXT_FORMAT specifies that lwm2m_tlv_t::value
 * is expressed or requested in plain text format.
 */
#define LWM2M_TLV_FLAG_STATIC_DATA   0x01
#define LWM2M_TLV_FLAG_TEXT_FORMAT   0x02

#ifdef LWM2M_BOOTSTRAP
#define LWM2M_TLV_FLAG_BOOTSTRAPPING 0x04
#endif

typedef size_t rt_size_t;

/*****************************************************************************/  
/*    DATA TYPE DECLARATIONS                                                 */
/*****************************************************************************/
/*
 * Utility functions for sorted linked list
 */

typedef struct _lwm2m_list_t
{
    struct _lwm2m_list_t * next;
    uint16_t    id;
} lwm2m_list_t;

/*
 * Bits 7 and 6 of assigned values for LWM2M_TYPE_RESOURCE,
 * LWM2M_TYPE_MULTIPLE_RESOURCE, LWM2M_TYPE_RESOURCE_INSTANCE
 * and LWM2M_TYPE_OBJECT_INSTANCE must match the ones defined
 * in the TLV format from LWM2M TS §6.3.3
 *
 */
typedef enum
{
    LWM2M_TYPE_RESOURCE = 0xC0,
    LWM2M_TYPE_MULTIPLE_RESOURCE = 0x80,
    LWM2M_TYPE_RESOURCE_INSTANCE = 0x40,
    LWM2M_TYPE_OBJECT_INSTANCE = 0x00
} lwm2m_tlv_type_t;

typedef enum
{
    LWM2M_TYPE_UNDEFINED = 0,
    LWM2M_TYPE_STRING,
    LWM2M_TYPE_INTEGER,
    LWM2M_TYPE_FLOAT,
    LWM2M_TYPE_BOOLEAN,
    LWM2M_TYPE_OPAQUE,
    LWM2M_TYPE_TIME,
    LWM2M_TYPE_OBJECT_LINK
} lwm2m_data_type_t;

typedef struct
{
    uint8_t     flags;
    lwm2m_tlv_type_t  type;
    lwm2m_data_type_t dataType;
    uint16_t    id;
    size_t      length;
    uint8_t *   value;
} lwm2m_tlv_t;


/*
 * LWM2M Objects
 *
 * For the read callback, if *numDataP is not zero, *dataArrayP is pre-allocated
 * and contains the list of resources to read.
 *
 */

typedef struct _lwm2m_object_t lwm2m_object_t;

typedef uint8_t (*lwm2m_read_callback_t) (uint16_t instanceId, int * numDataP, lwm2m_tlv_t ** dataArrayP, lwm2m_object_t * objectP);
typedef uint8_t (*lwm2m_write_callback_t) (uint16_t instanceId, int numData, lwm2m_tlv_t * dataArray, lwm2m_object_t * objectP);
typedef uint8_t (*lwm2m_execute_callback_t) (uint16_t instanceId, uint16_t resourceId, uint8_t * buffer, int length, lwm2m_object_t * objectP);
typedef uint8_t (*lwm2m_create_callback_t) (uint16_t instanceId, int numData, lwm2m_tlv_t * dataArray, lwm2m_object_t * objectP);
typedef uint8_t (*lwm2m_delete_callback_t) (uint16_t instanceId, lwm2m_object_t * objectP);
typedef void (*lwm2m_close_callback_t) (lwm2m_object_t * objectP);

struct _lwm2m_object_t
{
    uint16_t                 objID;
    lwm2m_list_t *           instanceList;
    lwm2m_read_callback_t    readFunc;
    lwm2m_write_callback_t   writeFunc;
    lwm2m_execute_callback_t executeFunc;
    lwm2m_create_callback_t  createFunc;
    lwm2m_delete_callback_t  deleteFunc;
    lwm2m_close_callback_t   closeFunc;
    void *                   userData;
};

typedef enum {
    LWM2M_CLIENT_STATE_INIT = (uint8_t)0x00,
    LWM2M_CLIENT_STATE_NOT_BOUND = (uint8_t)0x01,
    LWM2M_CLIENT_STATE_WAIT_FOR_BIND = (uint8_t)0x02,
    LWM2M_CLIENT_STATE_BINDING = (uint8_t)0x03,
    LWM2M_CLIENT_STATE_NORMAL = (uint8_t)0x04,
} lwm2m_client_state_t;

typedef struct {
    uint8_t state;
    uint8_t msgQ;
    uint16_t objectNum;
    pthread_mutex_t lock;
    lwm2m_object_t **objectList;
    void *userData;
} lwm2m_client_t;                                                                                 
                                                                                 
/*****************************************************************************/  
/*    EXTERN FUNCTION DECLARATIONS                                           */
/*****************************************************************************/  
extern lwm2m_client_t *lwm2m_init(uint8_t clientQ, void *userData);
extern void lwm2m_delete_object_list_content(lwm2m_client_t *pClient);
extern void lwm2m_close(lwm2m_client_t *pClient);
extern int lwm2m_config
(
    lwm2m_client_t *pClient,
    uint16_t objectNum,
    lwm2m_object_t *objectList[]
);

// Add 'node' to the list 'head' and return the new list
extern lwm2m_list_t * lwm2m_list_add(lwm2m_list_t * head, lwm2m_list_t * node);
// Return the node with ID 'id' from the list 'head' or NULL if not found
extern lwm2m_list_t * lwm2m_list_find(lwm2m_list_t * head, uint16_t id);
// Remove the node with ID 'id' from the list 'head' and return the new list
extern lwm2m_list_t * lwm2m_list_remove(lwm2m_list_t * head, uint16_t id, lwm2m_list_t ** nodeP);
// Return the lowest unused ID in the list 'head'
extern uint16_t lwm2m_list_newId(lwm2m_list_t * head);
// Free a list. Do not use if nodes contain allocated pointers as it calls lwm2m_free on nodes only.
// If the nodes of the list need to do more than just "free()" their instances, don't use lwm2m_list_free().
extern void lwm2m_list_free(lwm2m_list_t * head);

/*
 *  Resource values
 */

// defined in utils.c
extern int lwm2m_PlainTextToInt64(uint8_t * buffer, int length, int64_t * dataP);
extern int lwm2m_PlainTextToFloat64(uint8_t * buffer, int length, double * dataP);

/*
 * These utility functions allocate a new buffer storing the plain text
 * representation of data. They return the size in bytes of the buffer
 * or 0 in case of error.
 * There is no trailing '\0' character in the buffer.
 */
extern rt_size_t lwm2m_int64ToPlainText(int64_t data, uint8_t ** bufferP);
extern rt_size_t lwm2m_float64ToPlainText(double data, uint8_t ** bufferP);
extern rt_size_t lwm2m_boolToPlainText(bool data, uint8_t ** bufferP);

extern lwm2m_tlv_t * lwm2m_tlv_new(int size);
extern int lwm2m_tlv_parse(uint8_t * buffer, rt_size_t bufferLen, lwm2m_tlv_t ** dataP);
extern int lwm2m_tlv_serialize(int size, lwm2m_tlv_t * tlvP, uint8_t ** bufferP);
extern void lwm2m_tlv_free(int size, lwm2m_tlv_t * tlvP);

extern void lwm2m_tlv_encode_int(int64_t data, lwm2m_tlv_t * tlvP);
extern int lwm2m_tlv_decode_int(lwm2m_tlv_t * tlvP, int64_t * dataP);
extern void lwm2m_tlv_encode_float(double data, lwm2m_tlv_t * tlvP);
extern int lwm2m_tlv_decode_float(lwm2m_tlv_t * tlvP, double * dataP);
extern void lwm2m_tlv_encode_bool(bool data, lwm2m_tlv_t * tlvP);
extern int lwm2m_tlv_decode_bool(lwm2m_tlv_t * tlvP, bool * dataP);
extern void lwm2m_tlv_include(lwm2m_tlv_t * subTlvP, rt_size_t count, lwm2m_tlv_t * tlvP);


/*
 * These utility functions fill the buffer with a TLV record containing
 * the data. They return the size in bytes of the TLV record, 0 in case
 * of error.
 */
extern int lwm2m_intToTLV(lwm2m_tlv_type_t type, int64_t data, uint16_t id, uint8_t * buffer, rt_size_t buffer_len);
extern int lwm2m_boolToTLV(lwm2m_tlv_type_t type, bool value, uint16_t id, uint8_t * buffer, rt_size_t buffer_len);
extern int lwm2m_opaqueToTLV(lwm2m_tlv_type_t type, uint8_t * dataP, rt_size_t data_len, uint16_t id, uint8_t * buffer, rt_size_t buffer_len);
extern int lwm2m_decodeTLV(uint8_t * buffer, rt_size_t buffer_len, lwm2m_tlv_type_t * oType, uint16_t * oID, rt_size_t * oDataIndex, rt_size_t * oDataLen);
extern int lwm2m_opaqueToInt(uint8_t * buffer, rt_size_t buffer_len, int64_t * dataP);
extern int lwm2m_opaqueToFloat(uint8_t * buffer, rt_size_t buffer_len, double * dataP);
extern int32_t lwm2m_handle_message
(
    lwm2m_client_t *pClient,
    uint16_t optCode,
    uint16_t objId,
    uint8_t *pReq,
    uint16_t reqLen,
    uint8_t **pRsp,
    uint16_t *pRspLen
);

#endif  /*_IOT_MOD_LWM2M_H_*/

/*
 
 int main()
 {
	char hh2[17]={0x08, 0x00, 0xE, 0xC0, 0x16, 0xC0, 0x00, 0xC0, 0x11, 0xC0, 0x01, 0xC0, 0x02, 0xC0, 0x12, 0xC0, 0x13};
	char hh[] = "{"
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
 "{\"resId\":\"firmwareVersion\"},"
 "{\"resId\":\"softwareVersion\"},"
 "{\"resId\":\"rebindFlag\"}"
 "]"
 "}"
 "]"
 "}"
 "}";
 
	char *hh3 = "{"
 "\"discoveryQuery\": {"
 "\"sourceIP\": \"129.12.12.12\","
 "\"sourcePort\": 1234,"
 "\"timestamp\": \"1234567890\""
 "}"
	"}";
	
 
 #if 0
	int len,i;
	char *tlv_result_str, *tmp_str;
	iot_mod_json_lwm2m_header_t header, header2;
	memset(&header, 0, sizeof(iot_mod_json_lwm2m_header_t));
	memset(&header2, 0, sizeof(iot_mod_json_lwm2m_header_t));
	len = iot_mod_json_to_lwm2m(hh, &header);
 
	printf("he\n");
	printf("len=%d\n", len);
	printf("%0.2x %0.2x\n", header.body[4], header.body[5]);
	output_tlv(stdout, header.body, len, 0);
 
	for(i=0; i<len; i++){
 printf("%0.2x\t", header.body[i]);
	}
	printf("\n");*//*
printf("he2\n");
header2.retCode=0;
header2.objId=3;
header2.operation=2;

len = iot_mod_lwm2m_to_json(hh2, 17, &header2);
printf("len=%d\n", len);
printf("json:\n%s\n", header2.body);
#endif

#if 0
char *tmp_tlv, *tmp_js;
int ret;

printf("start:\n");
ret = discovery_json_parse(hh3, &tmp_tlv);
printf("ret=%d\n", ret);

ret = discovery_tlv_parse(tmp_tlv, ret, &tmp_js);
printf("json:\n"
       "%s\n", tmp_js);
printf("ret=%d\n", ret);
#endif
return 0;
}


 */

