
/*                                                                             
 * Copyright(c) 2015 Tigercel Communication Technologies Co., Ltd              
 * All rights reserved.                                                        
 *                                                                             
 * System : IOT Platform                                                       
 * Title  : iot_mod_lwm2m_json.h                                                       
 * RCS ID : $Date:  $                                                          
 *  $Author:  $                                                                
 *  $Revision:  $                                                              
 */                                                                            
                                                                               
#ifndef _IOT_MOD_LWM2M_JSON_H_
#define _IOT_MOD_LWM2M_JSON_H_
                                                                                 
/*****************************************************************************/  
/*    INCLUDE FILE DECLARATIONS                                              */
/*****************************************************************************/  
#include "cJSON.h"                                                        
#include <stdint.h>
#include <stdlib.h>                                            
/*****************************************************************************/  
/*    DEFINE DECLARATIONS                                                    */
/*****************************************************************************/  
#define LWM2M_JSON_OPERATION "operation"
#define LWM2M_JSON_SEQUENCE "sequence"
#define LWM2M_JSON_DESCRIPTION "description"
#define LWM2M_JSON_OPERATION_CREATE "createREQ"
#define LWM2M_JSON_OPERATION_DELETE "deleteREQ"
#define LWM2M_JSON_OPERATION_READ "readREQ"
#define LWM2M_JSON_OPERATION_WRITE "writeREQ"
#define LWM2M_JSON_OPERATION_EXECUTE "executeREQ"

#define LWM2M_JSON_OPERATION_CREATE_ACK "createACK"
#define LWM2M_JSON_OPERATION_DELETE_ACK "deleteACK"
#define LWM2M_JSON_OPERATION_READ_ACK "readACK"
#define LWM2M_JSON_OPERATION_WRITE_ACK "writeACK"
#define LWM2M_JSON_OPERATION_EXECUTE_ACK "executeACK"

#define LWM2M_JSON_OPERATION_CREATE_NACK "createNACK"
#define LWM2M_JSON_OPERATION_DELETE_NACK "deleteNACK"
#define LWM2M_JSON_OPERATION_READ_NACK "readNACK"
#define LWM2M_JSON_OPERATION_WRITE_NACK "writeNACK"
#define LWM2M_JSON_OPERATION_EXECUTE_NACK "executeNACK"

#define LWM2M_JSON_OPERATION_RET_BADREQ "bad request"
#define LWM2M_JSON_OPERATION_RET_UNAUTH "unauthorized"
#define LWM2M_JSON_OPERATION_RET_NOTFOUND "not found"
#define LWM2M_JSON_OPERATION_RET_NOTALLOW "method not allow"
#define LWM2M_JSON_OPERATION_RET_NOTACCEPT "not acceptable"
#define LWM2M_JSON_OPERATION_RET_INTERNALERR "internal server error"
#define LWM2M_JSON_OPERATION_RET_NOTIMPLEMENT "not implement"
#define LWM2M_JSON_OPERATION_RET_UNAVAIL "unavailable"
#define LWM2M_JSON_OPERATION_RET_UNKNOWN "unknown"

#define LWM2M_JSON_OBJECT "object"
#define LWM2M_JSON_OBJECT_ID "objId"
#define LWM2M_JSON_OBJECT_ID_DEVICE "device"
#define LWM2M_JSON_OBJECT_ID_LAMP "lamp"
#define LWM2M_JSON_OBJECT_ID_TIMER "timer"
#define LWM2M_JSON_OBJECT_ID_SCENARIO "scenario"
#define LWM2M_JSON_OBJECT_INSTANCES "objInstances"
#define LWM2M_JSON_OBJECT_INSTANCE_ID "objInstanceId"

#define LWM2M_JSON_INSTANCE_ID_SINGLE "single"

#define LWM2M_JSON_OBJECT_RESOURCES "resources"
#define LWM2M_JSON_RESOURCE_ID "resId"
#define LWM2M_JSON_RESOURCE_INSTANCES "resInstances"
#define LWM2M_JSON_RESOURCE_INSTANCE_ID "resInstanceId"
#define LWM2M_JSON_RESOURCE_DATATYPE "dataType"
#define LWM2M_JSON_RESOURCE_DATAVAL "value"

#define LWM2M_JSON_RESOURCE_DATATYPE_BOOL "boolean"
#define LWM2M_JSON_RESOURCE_DATATYPE_STRING "string"
#define LWM2M_JSON_RESOURCE_DATATYPE_INTEGER "integer"
#define LWM2M_JSON_RESOURCE_DATATYPE_TIME "time"

#define LWM2M_JSON_RESOURCE_DATAVAL_TRUE "true"
#define LWM2M_JSON_RESOURCE_DATAVAL_FALSE "false"

/* resources for device object */
#define LWM2M_JSON_RESOURCE_ID_MAC "MAC"
#define LWM2M_JSON_RESOURCE_ID_MANUFACTURER "manufacturer"
#define LWM2M_JSON_RESOURCE_ID_DEVTYPE "deviceType"
#define LWM2M_JSON_RESOURCE_ID_MODNUM "moduleNumber"
#define LWM2M_JSON_RESOURCE_ID_SN "serialNumber"
#define LWM2M_JSON_RESOURCE_ID_HWVER "hardwareVersion"
#define LWM2M_JSON_RESOURCE_ID_FWVER "firmwareVersion"
#define LWM2M_JSON_RESOURCE_ID_SWVER "softwareVersion"
#define LWM2M_JSON_RESOURCE_ID_REBFLG "rebindFlag"
#define LWM2M_JSON_RESOURCE_ID_REBOOT "Reboot"
#define LWM2M_JSON_RESOURCE_ID_FRESET "factoryReset"
#define LWM2M_JSON_RESOURCE_ID_MEMFREE "memoryFree"
#define LWM2M_JSON_RESOURCE_ID_MEMTOTAL "memoryTotal"
#define LWM2M_JSON_RESOURCE_ID_ERRCODE "errorCode"
#define LWM2M_JSON_RESOURCE_ID_RSTERRCODE "resetErrorCode"
#define LWM2M_JSON_RESOURCE_ID_CURTIME "currentTime"
#define LWM2M_JSON_RESOURCE_ID_UTCOFF "UTCOffset"
#define LWM2M_JSON_RESOURCE_ID_TZ "timeZone"
#define LWM2M_JSON_RESOURCE_ID_IP "IP"
#define LWM2M_JSON_RESOURCE_ID_DEVTOKEN "devToken"

/* resources for lamp object */
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_MODE "lightMode"
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_BRIGHT "lightBright"
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_COLOR "lightColor"
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_COLOR_TEMP "lightColorTemp"
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_BLINK_FREQ "lightBlinkFreq"
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_STATE "lightSwitch"
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_SCENARIO "lightScenario"
#define LWM2M_JSON_RESOURCE_ID_LAMP_LIGHT_POWER_SAVING "lightPowerSaving"

/* resources for timer object */
#define LWM2M_JSON_RESOURCE_ID_TIMER_WEEKDAY "weekday"
#define LWM2M_JSON_RESOURCE_ID_TIMER_START_TIME "startTime"
#define LWM2M_JSON_RESOURCE_ID_TIMER_END_TIME "endTime"
#define LWM2M_JSON_RESOURCE_ID_TIMER_LIGHT_SCENARIO "lightScenario"
#define LWM2M_JSON_RESOURCE_ID_TIMER_STATE "state"

/* resources for scenario object */
#define LWM2M_JSON_RESOURCE_ID_SCENARIO_NAME "name"
#define LWM2M_JSON_RESOURCE_ID_SCENARIO_LIGHT_MODE "lightMode"
#define LWM2M_JSON_RESOURCE_ID_SCENARIO_LIGHT_BRIGHT "lightBright"
#define LWM2M_JSON_RESOURCE_ID_SCENARIO_LIGHT_COLOR "lightColor"
#define LWM2M_JSON_RESOURCE_ID_SCENARIO_LIGHT_COLOR_TEMP "lightColorTemp"
#define LWM2M_JSON_RESOURCE_ID_SCENARIO_LIGHT_BLINK_FREQ "lightBlinkFreq"
#define LWM2M_JSON_RESOURCE_ID_SCENARIO_LIGHT_STATE "lightSwitch"


/*****************************************************************************/  
/*    DATA TYPE DECLARATIONS                                                 */
/*****************************************************************************/  
typedef struct {
    uint16_t operation;
    uint16_t objId;
    uint16_t sequence;
    uint16_t retCode;
    uint8_t *body;
} iot_mod_json_lwm2m_header_t;                                                                                 
                                                                                 
/*****************************************************************************/  
/*    EXTERN FUNCTION DECLARATIONS                                           */
/*****************************************************************************/  
extern int iot_mod_json_to_lwm2m(char *pJsonStr, iot_mod_json_lwm2m_header_t *pHdr);
extern int iot_mod_lwm2m_to_json(char *pLwm2mStr, int strLen, iot_mod_json_lwm2m_header_t *pHdr);
extern int discovery_json_parse(char *json_in, char **tlv_out);
extern int discovery_tlv_parse(char *tlv_in, int tlv_len, char **json_out);

#endif  /*_IOT_MOD_LWM2M_JSON_H_*/
