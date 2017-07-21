//
//  ViewController.m
//  MapNavigationDemo
//
//  Created by Yochi·Kung on 2017/7/20.
//  Copyright © 2017年 gongyouqiang. All rights reserved.
//

#import "ViewController.h"
#import "MapNavigationTool.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CLLocationCoordinate2D treascoor;
    treascoor.latitude   = 22.573422;
    treascoor.longitude  = 113.87252;
    
    [MapNavigationTool mapNavigationdestinationCoor:treascoor destinationName:@"天涯海角" ismapNavigation:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
