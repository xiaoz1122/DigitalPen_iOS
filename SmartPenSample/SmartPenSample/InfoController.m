//
//  InfoController.m
//  SmartPenSample
//
//  Created by Xiaoz on 15/7/29.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import "InfoController.h"
#import "SmartPenCore/SmartPenService.h"
#import "SmartPenCore/DeviceObject.h"
#import "SmartPenCore/Enums.h"

@interface InfoController ()<PointChangeDelegate>

@end

@implementation InfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SmartPenService *service = [SmartPenService sharePenService];
    [service setPointChangeDelegate:self];
    
    DeviceObject *device = [service getCurrDevice];
    //设置纸张场景
    device.sceneType = A4;
    if (device != nil) {
        NSString *deviceName = [device getName];
        self.labelDeviceName.text = deviceName;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disconnectButClick:(UIButton *)sender {
    [[SmartPenService sharePenService] disconnectDevice];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)change:(PointObject *)point{
    self.labelIsRoute.text = [NSString stringWithFormat:@"%d",point.isRoute];
    self.labelIsMove.text = [NSString stringWithFormat:@"%d",point.isMove];
    self.labelIsSw1.text = [NSString stringWithFormat:@"%d",point.isSw1];
    self.labelOriginalX.text = [NSString stringWithFormat:@"%d",point.originalX];
    self.labelOriginalY.text = [NSString stringWithFormat:@"%d",point.originalY];
    
    //↓↓↓直接输出sceneType设置的尺寸坐标
//    self.labelWidth.text = [NSString stringWithFormat:@"%d",[point getWidth]];
//    self.labelHeight.text = [NSString stringWithFormat:@"%d",[point getHeight]];
//    self.labelSceneX.text = [NSString stringWithFormat:@"%d",[point getSceneX]];
//    self.labelSceneY.text = [NSString stringWithFormat:@"%d",[point getSceneY]];
    
    
    
    //↓↓↓按屏幕等比缩放输出坐标
    //设置缩放后的宽度
    short width = 1280;
    //设置缩放后的高度，按sceneType设置的比例缩放
    short height = point.height * ((float)width / (float)point.width);
    
    self.labelWidth.text = [NSString stringWithFormat:@"%d",width];
    self.labelHeight.text = [NSString stringWithFormat:@"%d",height];
    self.labelSceneX.text = [NSString stringWithFormat:@"%d",[point getSceneX:width]];
    self.labelSceneY.text = [NSString stringWithFormat:@"%d",[point getSceneY:height]];
}


@end
