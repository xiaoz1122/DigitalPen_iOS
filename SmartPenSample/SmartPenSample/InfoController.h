//
//  InfoController.h
//  SmartPenSample
//
//  Created by Xiaoz on 15/7/29.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UILabel *labelOriginalX;
@property (weak, nonatomic) IBOutlet UILabel *labelOriginalY;
@property (weak, nonatomic) IBOutlet UILabel *labelIsRoute;
@property (weak, nonatomic) IBOutlet UILabel *labelIsMove;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *labelIsSw1;

@property (weak, nonatomic) IBOutlet UILabel *labelWidth;
@property (weak, nonatomic) IBOutlet UILabel *labelHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelSceneX;
@property (weak, nonatomic) IBOutlet UILabel *labelSceneY;

@end
