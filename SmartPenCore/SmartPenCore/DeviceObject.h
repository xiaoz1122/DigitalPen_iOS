//
//  DeviceObject.h
//  SmartPenCore
//
//  Created by Xiaoz on 15/7/16.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Enums.h"

@interface DeviceObject : NSObject
{
    NSString        *key;           //设备标识
    int             verMajor;       //设备大版本
    int             verMinor;       //设备小版本
    NSInteger       sceneWidth;
    NSInteger       sceneHeight;
    CBPeripheral    *peripheral;
}

@property (nonatomic,assign) int verMajor;
@property (nonatomic,assign) int verMinor;
@property (nonatomic,assign) SceneType sceneType;  //场景类型
@property (retain, nonatomic) CBPeripheral *peripheral;

//获取设备名字
-(NSString *)getName;

//获取场景宽度
-(NSInteger)getSceneWidth;

//获取场景高度
-(NSInteger)getSceneHeight;

@end
