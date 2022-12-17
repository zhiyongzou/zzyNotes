//
//  LocationBlockViewController.m
//  CommonTest
//
//  Created by zzyong on 2022/12/11.
//

#import "LocationBlockViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationBlockViewController () <CLLocationManagerDelegate>

@end

@implementation LocationBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D c2d = [self locationCoordinate];
    NSLog(@"locationCoordinate: %@ %@", @(c2d.latitude), @(c2d.longitude));
}

- (CLLocationCoordinate2D)locationCoordinateBlock {
    CLLocationDegrees latitude = 0;
    CLLocationDegrees longitude = 0;
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *loc = [CLLocationManager new];
        latitude = loc.location.coordinate.latitude;
        longitude = loc.location.coordinate.longitude;
    }
    return CLLocationCoordinate2DMake(latitude, longitude);
}

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

- (CLLocationCoordinate2D)locationCoordinate2 {
    static CLLocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
    });
    
    return locationManager.location.coordinate;
}

- (CLLocationCoordinate2D)locationCoordinate3 {
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

#pragma mark - CLLocationManagerDelegate

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    NSLog(@"%s", __func__);
}

@end
