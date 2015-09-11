//
//  ViewController.m
//  SmartPenSample
//
//  Created by Xiaoz on 15/7/22.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import "ViewController.h"
#import "SmartPenCore/SmartPenService.h"

@interface ViewController ()<ScanDeviceDelegate,
                            ConnectStateDelegate,
                            UITableViewDataSource,
                            UITableViewDelegate,
                            UIAlertViewDelegate>

@end

@implementation ViewController
@synthesize deviceArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SmartPenService sharePenService];
    deviceArray = [[NSMutableArray alloc] init];
    
    self.contentTableView.dataSource = self;
    self.contentTableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)refreshButtonClick:(UIButton *)sender {
    
    //[self.disCoverDivice removeAllObjects];
    [self.deviceArray removeAllObjects];
    [self.contentTableView reloadData];
    
    [[SmartPenService sharePenService] scanDevice:self];
}

-(void)performDismiss{
    [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
}

-(void)showAlert:(NSString *)msg{
    [self showAlert:msg cancel:nil];
    
    // Auto dismiss after 3 seconds
    //[self performSelector:@selector(performDismiss) withObject:nil afterDelay:3.0f];
}

-(void)showAlert:(NSString *)msg cancel:(NSString *)cancel{
    baseAlert = [[UIAlertView alloc] initWithTitle:msg
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:cancel
                                 otherButtonTitles:nil,nil];
    [baseAlert show];
}


//ScanDeviceDelegate 发现设备
-(void)find:(DeviceObject *)deviceObject{
    NSLog(@"Find device name:%@",[deviceObject getName]);
    
    [deviceArray addObject:deviceObject];
    [self.contentTableView reloadData];
}

//ConnectStateDelegate 连接状态更改
-(void)stateChange:(ConnectState)state{
    NSLog(@"stateChange:%u",state);
    switch (state) {
        case PEN_INIT_COMPLETE:
            [self performDismiss];
            [self performSegueWithIdentifier:@"toInfo" sender:self];
            break;
        case DISCONNECTED:
            [self performDismiss];
            [self showAlert:@"已断开连接。" cancel:@"确定"];
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark tableView delegate implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRowsInSection = 0;
    if (self.deviceArray && [self.deviceArray count] > 0) {
        numberOfRowsInSection = [self.deviceArray count];
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[deviceArray objectAtIndex:indexPath.row] getName];
    
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceObject *selectItem = [deviceArray objectAtIndex:[indexPath row]];
    NSLog(@"select name:%@",[selectItem getName]);
    
    [self showAlert:@"正在连接，请稍后..."];
    [[SmartPenService sharePenService] connectDevice:selectItem delegate:self];

}

@end
