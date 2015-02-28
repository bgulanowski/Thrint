//
//  ThrintKit.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-07.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

/* The purpose of this class is just to create an object file.
 */

#import <ThrintKit/NSObject+ThrintAdditions.h>

#import <ThrintKit/ListDataSource.h>
#import <ThrintKit/EntityListDataSource.h>
#import <ThrintKit/ListVC.h>
#import <ThrintKit/DetailVC.h>
#import <ThrintKit/ThrintTableViewController.h>

#import <ThrintKit/BooleanAttributeCell.h>
#import <ThrintKit/DateAttributeCell.h>
#import <ThrintKit/ImageAttributeCell.h>
#import <ThrintKit/IntegerAttributeCell.h>
#import <ThrintKit/SliderAttributeCell.h>
#import <ThrintKit/TextAttributeCell.h>
#import <ThrintKit/Thrint.h>

@interface ThrintKit : NSObject

+ (NSString *)versionString;
+ (NSBundle *)resourceBundle;

@end
