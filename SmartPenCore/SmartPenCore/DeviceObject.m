//
//  DeviceObject.m
//  SmartPenCore
//
//  Created by Xiaoz on 15/7/16.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import "DeviceObject.h"

@implementation DeviceObject

@synthesize verMajor;
@synthesize verMinor;
@synthesize peripheral;
@synthesize sceneType;

-(NSString *)getName{
    return peripheral.name;
}

@end
