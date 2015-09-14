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
    NSString *showName;
    
    //指定规则的名字过滤
    NSRange range = [peripheral.name rangeOfString:@"Pen"];
    if (range.location == 0 && range.length == 3) {
        int index = peripheral.name.length-6;
        //只显示最后6位识别码
        showName = [NSString stringWithFormat:@"Pen%@",[peripheral.name substringFromIndex:index]];
    }else{
        showName = peripheral.name;
    }
    return showName;
}

@end
