//
//  NSObject+THRTableDataProviding.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-09-29.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THRProperty;

@interface NSObject (THRTableDataProviding)

@property (readonly) NSString *listRepresentation;
@property (readonly) Class tableViewCellClass;
@property (readonly) NSString *tableViewCellReuseIdentifier;
@property (readonly) UITableViewCellStyle tableViewCellStyle;

//+ (THRProperty *)titleProperty;
//+ (NSArray *)valueProperties;
//+ (NSArray *)optionProperties;
//+ (NSArray *)connectionProperties;
//+ (NSArray *)collectionProperties;

+ (Class)tableViewCellClass;
+ (NSString *)tableViewCellReuseIdentifier;
+ (UITableViewCellStyle)tableViewCellStyle;

+ (UITableViewCell *)newCell;
- (UITableViewCell *)newCell;

- (UITableViewCell *)cellForTableView:(UITableView *)tableView;
- (void)configureTableViewCell:(UITableViewCell *)tableViewCell;

@end
