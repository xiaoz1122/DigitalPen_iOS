//
//  DeviceObject.m
//  SmartPenCore
//
//  Created by Xiaoz on 15/7/16.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import "DeviceObject.h"

#define VALUE_A4_WIDTH 10000;
#define VALUE_A4_HEIGHT 14500;

#define VALUE_A5_WIDTH 7000;
#define VALUE_A5_HEIGHT 9500;

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

-(NSInteger)getSceneWidth{
    switch(sceneType){
        case A4:
            return VALUE_A4_WIDTH;
        case A4_horizontal:
            return VALUE_A4_HEIGHT;
        case A5:
            return VALUE_A5_WIDTH;
        case A5_horizontal:
            return VALUE_A5_HEIGHT;
        default:
            return sceneWidth;
    }
}

-(NSInteger)getSceneHeight{
    switch(sceneType){
        case A4:
            return VALUE_A4_HEIGHT;
        case A4_horizontal:
            return VALUE_A4_WIDTH;
        case A5:
            return VALUE_A5_HEIGHT;
        case A5_horizontal:
            return VALUE_A5_WIDTH;
        default:
            return sceneHeight;
    }
}

@end
