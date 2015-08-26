//
//  THRList+THRTableDataProviding.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRList.h"

@protocol THRViewList <THRList, UITableViewDataSource>
@end

@protocol THRViewItem <THRItem>

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

//+ (THRProperty *)titleProperty;
//+ (NSArray *)valueProperties;
//+ (NSArray *)optionProperties;
//+ (NSArray *)connectionProperties;
//+ (NSArray *)collectionProperties;

@end

@interface THRList (THRTableDataProviding)<THRViewList>
@end
