//
//  PointObject.m
//  SmartPenCore
//
//  Created by Xiaoz on 15/7/22.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import "PointObject.h"

@implementation PointObject

@synthesize originalX;
@synthesize originalY;
@synthesize isRoute;
@synthesize isSw1;
@synthesize isMove;
@synthesize battery;
@synthesize sceneType;

-(NSString *)toString{
    NSString* string = [NSString stringWithFormat:@"x:%d,y:%d",originalX, originalY];
    return string;
}

-(short)getWidth{
    switch (sceneType) {
        case A4:
            return 10000;
        case A4_horizontal:
            return 14500;
        case A5:
            return 7000;
        case A5_horizontal:
            return 9500;
        default:
            return 0;
    }
}

-(short)getHeight{
    switch (sceneType) {
        case A4:
            return 14500;
        case A4_horizontal:
            return 10000;
        case A5:
            return 9500;
        case A5_horizontal:
            return 7000;
        default:
            return 0;
    }
}

-(short)getSceneX{
    return [self getSceneX:0];
}
-(short)getSceneX:(int)showWidth{
    short value = (short)(originalX + [self getWidth] / 2);
    if(value < 0){
        value = 0;
    }else if(value > [self getWidth]){
        value = [self getWidth];
    }
    
    if(showWidth > 0){
        //按显示宽度等比缩放
        value = (short)((float)value * ((float)showWidth / (float)[self getWidth]));
    }
    
    return value;
}

-(short)getSceneY{
    return [self getSceneY:0];
}
-(short)getSceneY:(int)showHeight{
    //计算偏移量
    short value = originalY > [self getHeight]?[self getHeight]:originalY;
    
    if(showHeight > 0){
        //按显示宽度等比缩放
        value = (short)((float)value * ((float)showHeight / (float)[self getHeight]));
    }
    
    return value;
}

@end
