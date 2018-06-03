//
//  AppDelegate.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThrintDemo.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, ThrintDelegate, BAApplicationDelegateAdditions>

@property (nonatomic, strong) ThrintDemo *thrint;

@property (nonatomic, strong) UIWindow *window;

@end
