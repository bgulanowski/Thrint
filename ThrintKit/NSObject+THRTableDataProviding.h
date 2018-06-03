//
//  NSObject+THRTableDataProviding.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-09-29.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THRItem.h"

@interface NSObject (THRItemConforming)<THRItem>

// Cells

+ (Class)tableViewCellClass;
+ (NSString *)tableViewCellReuseIdentifier;
+ (UITableViewCellStyle)tableViewCellStyle;
+ (UITableViewCell *)newCell;

- (Class)tableViewCellClass;
- (NSString *)tableViewCellReuseIdentifier;
- (UITableViewCellStyle)tableViewCellStyle;
- (UITableViewCell *)newCell;

// Properties

+ (NSSet *)defaultTitlePropertyKeys;

+ (NSString *)titlePropertyKey;
+ (NSArray *)valuePropertyKeys;
+ (NSArray *)optionPropertyKeys;
+ (NSArray *)connectionPropertyKeys;
+ (NSArray *)collectionPropertyKeys;

- (NSString *)titlePropertyKey;
- (NSArray *)valuePropertyKeys;
- (NSArray *)optionPropertyKeys;
- (NSArray *)connectionPropertyKeys;
- (NSArray *)collectionPropertyKeys;

- (NSArray *)propertyLists;

@end
