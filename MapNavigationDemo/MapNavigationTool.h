//
//  MapNavigationTool.h
//  MapNavigationDemo
//
//  Created by Yochi·Kung on 2017/7/20.
//  Copyright © 2017年 gongyouqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapNavigationTool : NSObject

+ (NSArray *)mapNavigationdestinationCoor:(CLLocationCoordinate2D)destinationCoor
                          destinationName:(NSString *)destinationName
                          ismapNavigation:(BOOL)ismapNavigation;

@end
