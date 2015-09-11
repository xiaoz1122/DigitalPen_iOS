# DigitalPen For iOS
这是易方物联为旗下产品**数码笔**提供的iOS开源项目，用于让开发者快速的进行开发。


## 目录说明 ##
- <b>SmartPenCore：</b>数码笔SDK核心库。
- <b>SmartPenSample：</b>数码笔演示项⺫代码。


## 开发环境 ##
- Xcode 6.4
- iOS Deployment Target 8.1


## 集成SDK方式 ##
1. 左键点击要集成的项目 -> General -> Embedded Binaries -> 点击“+”号，选择“Add Other”添加SmartPenCore/Products/SmartPenCore.framework库文件。
2. 右键点击要集成的项目 -> Add Files to "You project",选择添加SmartPenCore项目文件，然后再General -> Embedded Binaries添加项目内的SmartPenCore.framework库文件。


## 扫描数码笔设备 ##
首先需要确认手机蓝牙是否已打开，然后执行以下方法：   
```
[[SmartPenService sharePenService] scanDevice:self];
```  
SmartPenService对象会通过ScanDeviceDelegate返回扫描到的设备。


## 连接数码笔设备 ##
通过ScanDeviceDelegate可以获取到返回的DeviceObject对象，然后执行以下方法：   
```
[[SmartPenService sharePenService] connectDevice:selectItem delegate:self];
```  
SmartPenService对象会通过ConnectStateDelegate返回连接状态，返回“PEN_INIT_COMPLETE”表示完全连接完成。


## 获取笔坐标信息 ##
连接成功后，可通过SmartPenService对象会通过PointChangeDelegate返回PointObject笔的坐标数据。  

#####PointObject对象公开属性：#####
- originalX：笔相对于接收器的实际X轴坐标，单位px；
- originalY：笔相对于接收器的实际Y轴坐标，单位px；
- isRoute：表示当前输出的坐标对象是否为笔迹，false表示当前笔为悬空状态；
- isSw1：表示当前数码笔上的按键1是否被按下，false表示没有被按下；
- isMove：表示笔当前正按下在移动；
- battery：表示电量信息。当数码笔电量过低时，会间隔发送BatteryState.LOW信号。


#####PointObject对象公开方法：#####
- 设置纸张场景类型，目前支持A4、A4(横向)、A5、A5(横向)和自定义，设置后会输出响应尺寸的坐标；  
```   
SmartPenService *service = [SmartPenService sharePenService];
[service getCurrDevice].sceneType = A4; 
```  

- 获取当前场景的宽，单位px。  
```	getWidth() ```
		
- 获取当前场景的高，单位px。  
```	getHeight() ```
	
- 笔相对于当前场景的X轴坐标，单位px；  
```	getSceneX() ```

- 笔坐标相对于showWidth等比缩放后的X轴坐标，单位px；  	
```	getSceneX(int showWidth) ```
	
- 笔相对于当前场景的Y轴坐标，单位px；  
```	getSceneY() ```
	
- 笔坐标相对于showHeight等比缩放后的Y轴坐标，单位px；  
```	getSceneY(int showHeight) ```
	

提示：
> 当isRoute由false变为true时，可视为Down；  
> 当isRoute由true变为false时，可视为Up；  
