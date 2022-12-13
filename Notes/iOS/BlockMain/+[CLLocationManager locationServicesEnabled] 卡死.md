# +[CLLocationManager locationServicesEnabled] 卡死
随着 iOS 16 的不断覆盖，突然发现线上的地理位置经纬度获取卡死在 iOS 16 上暴涨，具体堆栈如下：

```
Thread 0:
0   libsystem_kernel.dylib              0x00000001ba074b10 mach_msg_trap + 8
1   libsystem_kernel.dylib              0x00000001ba075132 mach_msg + 70
2   libdispatch.dylib                   0x000000018028c732 _dispatch_mach_send_and_wait_for_reply + 502
3   libdispatch.dylib                   0x000000018028caea dispatch_mach_send_with_result_and_wait_for_reply$VARIANT$mp + 50
4   libxpc.dylib                        0x00000001da607456 xpc_connection_send_message_with_reply_sync + 234
5   Foundation                          0x0000000181cf387a __NSXPCCONNECTION_IS_WAITING_FOR_A_SYNCHRONOUS_REPLY__ + 10
6   Foundation                          0x0000000181cf9192 -[NSXPCConnection _sendInvocation:orArguments:count:methodSignature:selector:withProxy:] + 2366
7   Foundation                          0x0000000181d0b92e -[NSXPCConnection _sendSelector:withProxy:arg1:] + 126
8   Foundation                          0x0000000181cdf51a _NSXPCDistantObjectSimpleMessageSend1 + 62
9   CoreLocation                        0x00000001873ae26a CLGetStatusBarIconState + 646
10  CoreLocation                        0x00000001873ac64e CLClientIsLocationServicesEnabled + 222
11  CoreLocation                        0x00000001873ac35a CLClientRetrieveAuthorizationStatus + 2314
```

**原地理位置获取代码**

```objc
- (CLLocationCoordinate2D)locationCoordinate {
    CLLocationDegrees latitude = 0;
    CLLocationDegrees longitude = 0;
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *loc = [CLLocationManager new];
        latitude = loc.location.coordinate.latitude;
        longitude = loc.location.coordinate.longitude;
    }
    return CLLocationCoordinate2DMake(latitude, longitude);
}
```


如果升级了 Xcode 14，Xcode 也会有对应的提示
> [CoreLocation] This method can cause UI unresponsiveness if invoked on the main thread. Instead, consider waiting for the `-locationManagerDidChangeAuthorization:` callback and checking `authorizationStatus` first.

其实这个在 16 以下的系统也会卡死，但概率较小，比较坑的是只有 Xcode 14 才有这个提示。。。

## 解决

从 Xcode 的提示中可以知道 locationServicesEnabled 有卡死主线程的风险，需要用 authorizationStatus 方式替代。如果对应的业务都在子线程的话，在不影响已有业务的场景下，该问题可以忽略。具体解决方案如下所示：

```objc
- (CLLocationCoordinate2D)locationCoordinate {
    BOOL shouldCreat = NO;
    if (@available(iOS 14.0, *)) {
        shouldCreat = YES;
    } else {
        if (kCLAuthorizationStatusAuthorizedWhenInUse == CLLocationManager.authorizationStatus ||
            kCLAuthorizationStatusAuthorizedAlways == CLLocationManager.authorizationStatus) {
            shouldCreat = YES;
        }
    }
    
    static CLLocationManager *locationManager = nil;
    if (shouldCreat) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            locationManager = [CLLocationManager new];
        });
    }
    
    CLLocationDegrees latitude = 0;
    CLLocationDegrees longitude = 0;
    BOOL locationEnable = NO;
    if (@available(iOS 14.0, *)) {
        if (kCLAuthorizationStatusAuthorizedWhenInUse == locationManager.authorizationStatus ||
            kCLAuthorizationStatusAuthorizedAlways == locationManager.authorizationStatus) {
            locationEnable = YES;
        }
    } else {
        if (locationManager) {
            locationEnable = YES;
        }
    }
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}
```