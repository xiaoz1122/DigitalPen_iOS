//
//  PointObject.h
//  SmartPenCore
//
//  Created by Xiaoz on 15/7/22.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface PointObject : NSObject

@property (nonatomic,assign) int originalX;
@property (nonatomic,assign) int originalY;
@property (nonatomic,assign) BOOL isRoute;          //是否是笔迹
@property (nonatomic,assign) BOOL isSw1;            //是否按键1被按下
@property (nonatomic,assign) BOOL isMove;           //是否正在移动
@property (nonatomic,assign) BatteryState battery;  //电量信息

-(NSString *)toString;

@end
