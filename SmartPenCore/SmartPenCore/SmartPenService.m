//
//  SmartPenService.m
//  SmartPenCore
//
//  Created by Xiaoz on 15/7/16.
//  Copyright (c) 2015年 Xiaoz. All rights reserved.
//

#import "SmartPenService.h"
#import "BlePenUtil.h"


#define deviceServiceUUID @"0000FE03-0000-1000-8000-00805F9B34FB"//@"180A"//
#define deviceInfoCharacteristicUUID @"0000FFD0-0000-1000-8000-00805F9B34FB"
#define deviceNotifyCharacteristicUUID @"0000FFC1-0000-1000-8000-00805F9B34FB"
#define deviceWriteCharacteristicUUID @"0000FFC2-0000-1000-8000-00805F9B34FB"

@implementation SmartPenService
@synthesize lastData = _lastData;
@synthesize foundPeripherals;
@synthesize characteristicDict;
@synthesize scanDeviceDelegate;
@synthesize connectStateDelegate;
@synthesize pointChangeDelegate;
@synthesize currConnectDevice;

static SmartPenService *_this = nil;

+ (id)sharePenService{
    if (_this == nil)
        _this = [[SmartPenService alloc] init];
    
    return _this;
}

+(NSString *)test{
    return @"test";
}

- (NSMutableData *)lastData{
    if (nil == _lastData) {
        _lastData = [[NSMutableData alloc] init];
    }
    return _lastData;
}

#pragma mark private method
- (id)init{
    if(self = [super init]){
        [self initBlutoothManager];
        currConnectDevice = nil;
    }
    return self;
}

-(void)initBlutoothManager{
    NSLog(@"initBlutoothManager");
    self.foundPeripherals = [[NSMutableDictionary alloc] init];
    self.characteristicDict = [[NSMutableDictionary alloc] init];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:aQueue];
}


-(void)scanDevice:(id<ScanDeviceDelegate>)delegate{
    if(!isBluetoothReady)return;
    if(isScanning)return;
    
    NSLog(@"start ScanDevice");
    
    self.scanDeviceDelegate = delegate;
    [foundPeripherals removeAllObjects];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setValue:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    [bluetoothManager scanForPeripheralsWithServices:nil options:options];
}

/**
 停止扫描
 **/
-(void)stopScanDevice{
    if(!isBluetoothReady)return;
    if(!isScanning)return;
    isScanning = false;
    [bluetoothManager stopScan];
}

/**
 连连接蓝牙设备
 **/
- (void)connectDevice:(CBPeripheral *)peripheral{
    if (peripheral) {
        [bluetoothManager connectPeripheral:peripheral options:nil];
    }
}

/**
 连连接蓝牙设备
 **/
-(void)connectDevice:(DeviceObject *)device delegate:(id<ConnectStateDelegate>)delegate{
    if(!isBluetoothReady)return;
    if(isScanning)[self stopScanDevice];
    
    self.connectStateDelegate = delegate;
    self.currConnectDevice = device;
    
    [bluetoothManager connectPeripheral:device.peripheral options:nil];
}

/*
 断开蓝牙连接
 */
- (void)disconnectDevice {
    if ([self isConnectingPeripheral]) {
        if (curCBPeripheral != nil) {
            [bluetoothManager cancelPeripheralConnection:curCBPeripheral];
        }
    }
}

-(DeviceObject *)getCurrDevice{
    return self.currConnectDevice;
}

- (BOOL)isConnectingPeripheral{
    if ([[characteristicDict allKeys] count] > 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"centralManagerDidUpdateState");
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:{
            isBluetoothReady = FALSE;
        }
            break;
        case CBCentralManagerStatePoweredOn:{
            isBluetoothReady = TRUE;
        }
            break;
        case CBCentralManagerStateResetting:
            
            break;
        case CBCentralManagerStateUnauthorized:
            
            break;
        case CBCentralManagerStateUnknown:
            
            break;
        case CBCentralManagerStateUnsupported:{
            isBluetoothReady = FALSE;
        }
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
    NSLog(@"didRetrievePeripherals  %@",peripherals);
    
}
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
    
    NSLog(@"didRetrieveConnectedPeripherals  %@",peripherals);
}

/*
 发现蓝牙设备
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    id kCBAdvDataManufacturerData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    if ([kCBAdvDataManufacturerData isKindOfClass:[NSData class]]) {
        //根据广播包判断是否是数码笔
        const char *bytes = [kCBAdvDataManufacturerData bytes];
        UInt8 oneByte =bytes[0];
        UInt8 twoByte =bytes[1];
        if (oneByte == 0x44 && twoByte == 0x50) {
            //发现智能笔设备
            DeviceObject *device = [[DeviceObject alloc] init];
            device.peripheral = peripheral;
            device.verMajor = (int)bytes[2];
            device.verMinor = (int)bytes[3];
            
            //判断是否已添加到集合列队
            if (![foundPeripherals objectForKey:[device getName]]) {
                [foundPeripherals setObject:peripheral forKey:[device getName]];
                
                if(scanDeviceDelegate){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [scanDeviceDelegate find:device];
                    });
                }
            }
        }
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if (peripheral.state == CBPeripheralStateConnected) {
        //连接成功
        isConnected = true;
        curCBPeripheral = peripheral;
        curCBPeripheral.delegate = self;    //添加代理
        
        //发现服务
        [curCBPeripheral discoverServices:nil];
        
        //通知连接状态
        [self sendConnectState:CONNECTED];
        
        NSLog(@"CONNECTED name:%@",peripheral.name);
    }else{
        isConnected = false;
        NSLog(@"didConnectPeripheral state:%@",peripheral.state);
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didFailToConnectPeripheral  %@",error);
    curCBPeripheral = nil;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didDisconnectPeripheral %@ %@",peripheral,error);
    
    [self.characteristicDict removeAllObjects];
    self.currConnectDevice = nil;
    
    //通知已断开
    [self sendConnectState:DISCONNECTED];
}

-(void)sendConnectState:(ConnectState)state{
    if(connectStateDelegate){
        dispatch_async(dispatch_get_main_queue(), ^{
            [connectStateDelegate stateChange:state];
        });
    }
}

#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if(error){
        NSLog(@"didDiscoverCharacteristicsForService error:%@",error);
        return ;
    }
    
    //如果还没有连接
    if(![self isConnectingPeripheral]){
        for (CBService *service in peripheral.services) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:deviceInfoCharacteristicUUID]]) {
                    [characteristicDict setObject:characteristic forKey:deviceInfoCharacteristicUUID];
                
                }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:deviceNotifyCharacteristicUUID]]){
                    if(!characteristic.isNotifying){
                        [curCBPeripheral setNotifyValue:TRUE forCharacteristic:characteristic];
                        NSLog(@"setNofity");
                    }
                    [characteristicDict setObject:characteristic forKey:deviceNotifyCharacteristicUUID];
                
                }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:deviceWriteCharacteristicUUID]]){
                    [characteristicDict setObject:characteristic forKey:deviceWriteCharacteristicUUID];
                }
            }
        }
    
        //通知服务准备完成
        [self sendConnectState:SERVICES_READY];
    
        //开始初始化笔数据
        for (int i=0; i<10; i++) {
            NSLog(@"Read characteristic count:%d",i);
            [peripheral readValueForCharacteristic:[characteristicDict objectForKey:deviceNotifyCharacteristicUUID]];
            [NSThread sleepForTimeInterval:0.1];
        }
    
        [self sendConnectState:PEN_INIT_COMPLETE];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSLog(@"write value:%@",characteristic.UUID.description);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ %@",characteristic,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    // 当笔划过或者书写的时候 有数据
    NSLog(@"didUpdateValueForCharacteristic %@ error:%@",characteristic,error);
    if (error) {
        return;
    }
    
    NSData *data = characteristic.value;
    
    BlePenUtil *blePenUtil = [[BlePenUtil alloc] init];
    NSMutableArray *pointList = [blePenUtil getPointList:currConnectDevice bleData:data];
    
    PointObject *item;
    if(pointList.count > 0){
        for (int i = 0;i < pointList.count; i++) {
            item = [pointList objectAtIndex:i];
            item.sceneType = self.currConnectDevice.sceneType;
            [self sendPotinInfoHandler:item];
        }
    }
}

//发送笔迹信息处理
- (void)sendPotinInfoHandler:(PointObject*)point{
    if (pointChangeDelegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [pointChangeDelegate change:point];
        });
    }
}

@end
