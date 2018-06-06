//
//  ThrintKit.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-07.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Thrint/THRList.h>
#import <Thrint/THRProperty.h>

#import <Thrint/ListDataSource.h>
#import <Thrint/EntityListDataSource.h>
#import <Thrint/ListVC.h>
#import <Thrint/DetailVC.h>
#import <Thrint/ThrintTableViewController.h>

#import <Thrint/BooleanAttributeCell.h>
#import <Thrint/DateAttributeCell.h>
#import <Thrint/ImageAttributeCell.h>
#import <Thrint/IntegerAttributeCell.h>
#import <Thrint/SliderAttributeCell.h>
#import <Thrint/TextAttributeCell.h>
#import <Thrint/THRDataManager.h>

#import <Thrint/NSObject+THRTableDataProviding.h>

@interface ThrintKit : NSObject

+ (NSString *)versionString;
+ (NSBundle *)resourceBundle;

@end
