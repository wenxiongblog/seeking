//
//  LSLocationManager.m
//  Project
//
//  Created by XuWen on 2020/3/6.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LSLocationManager()<CLLocationManagerDelegate>
@property (nonatomic,copy)LocationBlock locationBlock;
@property (nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation LSLocationManager

static LSLocationManager *__singletion;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__singletion == nil) {
            __singletion = [[self alloc] init];
        }
    });
    return __singletion;
}

//开始定位
+ (void)requestAuthorization
{
    [[LSLocationManager share].locationManager requestWhenInUseAuthorization];
}

- (void)startLocation:(LocationBlock)locationBlock;
{
    self.locationBlock = locationBlock;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    [self.locationManager requestLocation];
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(self.locationBlock){
        self.locationBlock(NO,0, 0, @"");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count){
            CLPlacemark *placemark = placemarks.firstObject;
            NSString *contry = placemark.addressDictionary[@"Country"];
            NSString *state = placemark.addressDictionary[@"State"];
            NSString *city = placemark.addressDictionary[@"City"];
            NSString *address = [NSString stringWithFormat:@"%@,%@,%@",contry,state,city];
            //获取一次经纬度即可
            [manager stopUpdatingLocation];
            //返回地理位置和城市名称
            if(self.locationBlock){
                self.locationBlock(YES,placemark.location.coordinate.latitude, placemark.location.coordinate.longitude, address);
            }
        }else{
            //只返回位置
            if(self.locationBlock){
                self.locationBlock(YES,location.coordinate.latitude, location.coordinate.longitude, @"");
            }
        }
    }];
}

@end
