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


## ~~失败的方案~~

~~从 Xcode 的提示中可以知道 locationServicesEnabled 有卡死主线程的风险，需要用 authorizationStatus 方式替代。解决方案如下所示：~~

```objc
// 解决失败，引入新增 CLClientStopVehicleHeadingUpdates 卡死。。。
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
    
    if (locationEnable) {
        return locationManager.location.coordinate;
    } else {
        return CLLocationCoordinate2DMake(0, 0);
    }
}
```

## 解决
以为换成`authorizationStatus`方式可以解决获取地理位置授权的卡死`（毕竟 Xcode 没有提示会有问题）`，结果还是太年轻了，上线灰度后出现了另外一个新增卡死，堆栈如下。


```
0   libsystem_kernel.dylib              0x00000001d4d6b8c4 mach_msg_trap + 8
1   libsystem_kernel.dylib              0x00000001d4d6acc6 mach_msg + 70
2   libdispatch.dylib                   0x00000001aa119a2a _dispatch_mach_send_and_wait_for_reply + 526
3   libdispatch.dylib                   0x00000001aa119dbe dispatch_mach_send_with_result_and_wait_for_reply$VARIANT$mp + 50
4   libxpc.dylib                        0x00000001efdef43e xpc_connection_send_message_with_reply_sync + 234
5   Foundation                          0x00000001ab8b1e9a __NSXPCCONNECTION_IS_WAITING_FOR_A_SYNCHRONOUS_REPLY__ + 10
6   Foundation                          0x00000001ab6b69d2 -[NSXPCConnection _sendInvocation:orArguments:count:methodSignature:selector:withProxy:] + 2426
7   Foundation                          0x00000001ab6dc49e -[NSXPCConnection _sendSelector:withProxy:arg1:arg2:arg3:] + 146
8   Foundation                          0x00000001ab8bd926 _NSXPCDistantObjectSimpleMessageSend3 + 42
9   CoreLocation                        0x00000001b0064ff2 CLClientCreateIso6709Notation + 46286
10  CoreLocation                        0x00000001b006a85e CLSetClientTransientAuthorizationInfo + 1086
11  CoreLocation                        0x00000001b003b07e CLClientStopVehicleHeadingUpdates + 105350
```

其实一开始的考虑就是为了可以在未授权的情况下节省`CLLocationManager`对象创建的开销，但是在主线程使用`authorizationStatus`方式判断权限依然会卡死。

### 最终方案
不判断地理位置授权状态，直接创建`CLLocationManager`，虽然直接创建会导致一些不必要的开销，但是对于 UI 卡死来说，这点开销可忽略不计。


```objc
- (CLLocationCoordinate2D)locationCoordinate {
    static CLLocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [CLLocationManager new];
    });
    
    return locationManager.location.coordinate;
}

```

### CLLocationManager 创建注意

CLLocationManager 在子线程创建 Xcode 会有一个警告日志，说不能在子线程创建，因为地理位置的一些状态更新是依赖 runLoop 的，例如，其代理方法没有回调了（`locationManagerDidChangeAuthorization:`）。但是如果只是为了获取到用户最后一次的位置信息，这个完全可以忽略，就算在子线程创建一样可以获取到最后一次的地理位置信息。

> Xcode 警告

A location manager (xxx) was created on a dispatch queue executing on a thread other than the main thread.  It is the developer's responsibility to ensure that there is a run loop running on the thread on which the location manager object is allocated.  In particular, creating location managers in arbitrary dispatch queues (not attached to the main queue) is not supported and will result in callbacks not being received.

神奇的是 **Xcode14** 没有这个提示了，以为 iOS 16 以后可以在子线程创建，最后测试发现是不行的。当然 App 侧开发一般不会放到子线程去创建，但是 SDK 开发就有可能涉及了，所以还是要注意下。苹果的这个操作完全理解不了！

测试代码：

```objc
- (CLLocationCoordinate2D)locationCoordinate {
    static CLLocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            locationManager = [CLLocationManager new];
            locationManager.delegate = self;
        });
    });
    
    return locationManager.location.coordinate;
}
```
