//
//  THRItem.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-28.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THRProperty;

@protocol THRItem <NSObject>

+ (Class)tableViewCellClass;
+ (NSString *)tableViewCellReuseIdentifier;
+ (UITableViewCellStyle)tableViewCellStyle;

- (Class)tableViewCellClass;
- (NSString *)tableViewCellReuseIdentifier;
- (UITableViewCellStyle)tableViewCellStyle;

+ (UITableViewCell *)newCell;
- (UITableViewCell *)newCell;

- (UITableViewCell *)cellForTableView:(UITableView *)tableView;
- (void)configureTableViewCell:(UITableViewCell *)tableViewCell;

+ (THRProperty *)titleProperty;
+ (NSArray *)valueProperties;
+ (NSArray *)optionProperties;
+ (NSArray *)connectionProperties;
+ (NSArray *)collectionProperties;

@optional
- (NSArray *)childItems;
@end
