//
//  DeviceObject.h
//  SmartPenCore
//
//  Created by Xiaoz on 15/7/16.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceObject : NSObject
{
    NSString        *key;           //设备标识
    int             verMajor;       //设备大版本
    int             verMinor;       //设备小版本
    CBPeripheral    *peripheral;
}

@property (nonatomic,assign) int verMajor;
@property (nonatomic,assign) int verMinor;
@property (retain, nonatomic) CBPeripheral *peripheral;

//获取设备名字
-(NSString *)getName;

@end
