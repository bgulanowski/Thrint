//
//  RootVC.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Thrint;

@interface ThrintTableViewController : UITableViewController

@property (nonatomic, weak)   Thrint *thrint;
@property (nonatomic, strong) NSArray *entityNames;

@end
