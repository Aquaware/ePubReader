//
//  AppDelegate.h
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property ( nonatomic, strong ) UINavigationController* navigationController;
@property ( nonatomic, strong ) ViewController* viewController;

@end
