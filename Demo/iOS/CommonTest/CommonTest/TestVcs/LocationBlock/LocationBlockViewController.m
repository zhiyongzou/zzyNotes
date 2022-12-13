//
//  LocationBlockViewController.m
//  CommonTest
//
//  Created by zzyong on 2022/12/11.
//

#import "LocationBlockViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationBlockViewController ()

@end

@implementation LocationBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locationCoordinate];
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

@end
