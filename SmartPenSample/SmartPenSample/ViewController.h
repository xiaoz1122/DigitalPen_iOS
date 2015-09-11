//
//  ViewController.h
//  SmartPenSample
//
//  Created by Xiaoz on 15/7/22.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UIAlertView *baseAlert;
}
@property (nonatomic,weak) IBOutlet UIButton *refreshButton;
@property (nonatomic,weak) IBOutlet UITableView *contentTableView;
@property (nonatomic,strong) NSMutableArray *deviceArray;

@end

