//
//  BlePenUtil.m
//  SmartPenCore
//
//  Created by Xiaoz on 15/9/8.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//
#define PEN_DATA_VALID_LENGTH 6


#import "BlePenUtil.h"
#import "Enums.h"
#import "PointObject.h"

@implementation BlePenUtil

static NSMutableData *mBleDataBuffer;

-(NSMutableArray *)getPointList:(DeviceObject *)device bleData:(NSData *)bleData{
    if (mBleDataBuffer == nil) {
        mBleDataBuffer = [[NSMutableData alloc] init];
    }
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSData *data = [self filterBleData:device bleData:bleData];
    if(data != nil){
        //NSLog(@"bleData:%@",data);
        [mBleDataBuffer appendData:data];
    
        char* penData = [self getValidPenData:mBleDataBuffer];
        if(penData != NULL){
            [self fillPointList:list penData:penData];
            
            //释放内存块
            penData = nil;
        }
    }
    return list;
}

-(void)fillPointList:(NSMutableArray *)list penData:(char *)penData{
    int i = 0;
    PointObject *item;
    while(penData[i] != NULL){
        if([self isPenData:penData index:i]){
            item = [PointObject alloc];
            item.originalX = ((penData[i+3]&0xff)<<8)|(penData[i+2]&0xff);
            item.originalY = ((penData[i+5]&0xff)<<8)|(penData[i+4]&0xff);
            item.isRoute = [self isPenRoute:penData index:i];
            item.isSw1 = [self isPenSw1:penData index:i];
            item.battery = [self getBatteryInfo:penData index:i];
            item.isMove = item.isRoute && lastPointRoute;
            
            [list addObject:item];
            
            lastPointRoute = item.isRoute;
            
            //打印panData
            NSString* dataString = @"";
            for (int n = 0; n < 6; n++) {
                dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"%x ", penData[i+n]&0xff]];
            }
            NSLog(@"penData:%@",dataString);
        }
        i += 6;
    }
}

-(NSData *)filterBleData:(DeviceObject *)device bleData:(NSData *)bleData{
    NSData *result = nil;
    const char *data = (char *)[bleData bytes];
    
    UInt8 head = data[0];
    
    if(device != nil && device.verMajor == XN680T){
        if(head >= 0x80){
            result = nil;
        }else{
            int length = (int)head;
            char *value = malloc(length * 2);
            for(int i = 0;i < length;i++){
                value[i] = data[i + 1];
            }
            result =[NSData dataWithBytes:value length:length];
        }
    }else{
        if((mBleDataBuffer.length == 0 && head >= 0x80 && head < 0x90)
           || mBleDataBuffer.length > 0){
            result = bleData;
        }
    }
    return result;
}

-(char *)getValidPenData:(NSMutableData *)buffer{
    char *result = NULL;
    if(buffer.length > PEN_DATA_VALID_LENGTH){
        int residue = buffer.length % PEN_DATA_VALID_LENGTH;
        int newLength = (int)buffer.length - residue;
        
        result = malloc(newLength * 2);
        
        char *bufferBytes = (char *)[buffer bytes];
        for(int i = 0;i < newLength;i++){
            result[i] = bufferBytes[i];
        }
        
        [buffer replaceBytesInRange:NSMakeRange(0, newLength) withBytes:NULL length:0];
    }
    return result;
}

//判断是否是笔数据
-(BOOL)isPenData:(char *)data index:(int)i{
    BOOL result = false;
    UInt8 oneByte = data[i];
    UInt8 twoByte = data[i+1];
    if(oneByte >= 0x80 && twoByte >= 0x80
       && oneByte < 0x90 && twoByte < 0x90){
        result = true;
    }
    return result;
}

//判断是否是书写笔迹
-(BOOL)isPenRoute:(char *)data index:(int)i{
    BOOL result = false;
    if([self isPenData:data index:i]){
        UInt8 state = data[i+1];
        //0001 笔尖按下
        //0010 sw1按下
        //0011 同时按下
        if(state == 0x81 || state == 0x83){
            result = true;
        }
    }
    return result;
}

//判断是否按下按键1
-(BOOL)isPenSw1:(char *)data index:(int)i{
    BOOL result = false;
    if([self isPenData:data index:i]){
        UInt8 state = data[i+1];
        //0001 笔尖按下
        //0010 sw1按下
        //0011 同时按下
        if(state == 0x82 || state == 0x83){
            result = true;
        }
    }
    return result;
}

//获取电量信息
-(BatteryState)getBatteryInfo:(char *)data index:(int)i{
    BatteryState result = NOT;
    if([self isPenData:data index:i]){
        UInt8 state = data[i];
        if(state == 0X81){
            result = LOW;
        }else if(state == 0x82){
            result = GOOD;
        }
    }
    return result;
}

@end
