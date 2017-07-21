//
//  MapNavigationTool.m
//  MapNavigationDemo
//
//  Created by Yochi·Kung on 2017/7/20.
//  Copyright © 2017年 gongyouqiang. All rights reserved.
//

#import "MapNavigationTool.h"

#import <UIKit/UIKit.h>

@implementation MapNavigationTool

/** 导航 usercoor:(CLLocationCoordinate2D)usercoor  */
+ (NSArray *)mapNavigationdestinationCoor:(CLLocationCoordinate2D)destinationCoor
                          destinationName:(NSString *)destinationName
                          ismapNavigation:(BOOL)ismapNavigation
{
    NSMutableArray *maps = [NSMutableArray array];
    NSMutableDictionary *mapDic = [NSMutableDictionary dictionary];

    if (!destinationName && destinationName.length == 0) {

        destinationName = @"终点";
    }

    //苹果地图
    NSMutableDictionary*iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];

    //百度地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {

        NSMutableDictionary*baiduMapDic = [NSMutableDictionary dictionary];

        baiduMapDic[@"title"] = @"百度地图";

        /** 参数说明
         origin={{我的位置}} 这个是不能被修改的 不然无法把出发位置设置为当前位置

         destination=latlng:%f,%f|name=目的地
         name=XXXX name这个字段不能省略 否则导航会失败 而后面的文字则可以随便填
         coord_type=gcj02
         coord_type允许的值为bd09ll、gcj02、wgs84 如果你APP的地图SDK用的是百度地图SDK 请填bd09ll 否则 就填gcj02 wgs84你基本是用不上了(关于地图加密这里也不多谈 请自行学习)
         */

        NSString*urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=bd09ll",destinationCoor.latitude,destinationCoor.longitude, destinationName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        baiduMapDic[@"url"] = urlString;
        [mapDic setValue:urlString forKey:@"百度地图"];

        [maps addObject:baiduMapDic];
    }

    //高德地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {

        NSMutableDictionary*gaodeMapDic = [NSMutableDictionary dictionary];

        gaodeMapDic[@"title"] = @"高德地图";

        NSString *applicationName = [self getAppName];
        NSString *applicationScheme = [self getAppURLScheme];

        /** 参数说明
         sourceApplication=%@&backScheme=%@
         sourceApplication代表你自己APP的名称 会在之后跳回的时候显示出来 所以必须填写 backScheme是你APP的URL Scheme 不填是跳不回来的哟
         dev=0
         这里填0就行了 跟上面的gcj02一个意思 1代表wgs84 也用不上
         */
        NSString*urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",applicationName,applicationScheme,destinationName,destinationCoor.latitude,destinationCoor.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        gaodeMapDic[@"url"] = urlString;
        [mapDic setValue:urlString forKey:@"高德地图"];
        [maps addObject:gaodeMapDic];
    }

    //腾讯地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {

        NSMutableDictionary*qqMapDic = [NSMutableDictionary dictionary];

        qqMapDic[@"title"] = @"腾讯地图";

        /** 参数说明 http://lbs.qq.com/uri_v1/guide-route.html */
        NSString*urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0",destinationCoor.latitude, destinationCoor.longitude, destinationName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        qqMapDic[@"url"] = urlString;
        [mapDic setValue:urlString forKey:@"腾讯地图"];
        [maps addObject:qqMapDic];
    }

    //谷歌地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {

        NSMutableDictionary*googleMapDic = [NSMutableDictionary dictionary];

        googleMapDic[@"title"] = @"谷歌地图";
        NSString *applicationName = [self getAppName];
        NSString *applicationScheme = [self getAppURLScheme];
        /** 
         x-source=%@&x-success=%@
         跟高德一样 这里分别代表APP的名称和URL Scheme
         saddr=
         这里留空则表示从当前位置触发 */
        NSString*urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",applicationName,applicationScheme,destinationCoor.latitude, destinationCoor.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        googleMapDic[@"url"] = urlString;
        [mapDic setValue:urlString forKey:@"谷歌地图"];
        [maps addObject:googleMapDic];
    }

    if (ismapNavigation) {

        NSArray *titles = mapDic.allKeys;
        if ([titles containsObject:@"百度地图"]) {

            [MapNavigationTool wakeupTheMapNavigation:mapDic[@"百度地图"]];
        }else if ([titles containsObject:@"高德地图"]) {

            [MapNavigationTool wakeupTheMapNavigation:mapDic[@"高德地图"]];
        }else if ([titles containsObject:@"腾讯地图"]) {

            [MapNavigationTool wakeupTheMapNavigation:mapDic[@"腾讯地图"]];
        }else if ([titles containsObject:@"谷歌地图"]) {

            [MapNavigationTool wakeupTheMapNavigation:mapDic[@"谷歌地图"]];
        }else {

            MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destinationCoor addressDictionary:nil]];
            currentLoc.name = @"我的位置";
            toLocation.name = destinationName;
            NSArray *items = @[currentLoc,toLocation];
            NSDictionary *dic = @{
                                  MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                  MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                  MKLaunchOptionsShowsTrafficKey : @(YES)
                                  };

            [MKMapItem openMapsWithItems:items launchOptions:dic];
        }
    }
    
    return maps;
}

+ (void)wakeupTheMapNavigation:(NSString *)urlString
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

/** 获取 bundle version版本号 */
+ (NSString *)getLocalAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/** 获取BundleID */
+ (NSString *)getAppBundleIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

/** 获取编译版本号 */
+ (NSString *)getAppBuildNumber
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

/** 获取AppName */
+ (NSString *)getAppName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

+ (NSString *)getAppURLScheme
{
    NSArray *URLSchemes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];

    //NSLog(@"URLScheme : %@", URLSchemes);
    NSDictionary *dict = [URLSchemes firstObject];
    NSArray *schemes = dict[@"CFBundleURLSchemes"];
    NSString *scheme = [schemes firstObject];

    return scheme;
}

@end
