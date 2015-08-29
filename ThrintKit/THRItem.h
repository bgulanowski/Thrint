//
//  THRItem.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-28.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THRProperty;
@class THRGroup;

@protocol THRItem <NSObject>

// Cells

- (UITableViewCell *)cellForTableView:(UITableView *)tableView;
- (void)configureTableViewCell:(UITableViewCell *)tableViewCell;

// Child items

- (NSArray *)childItems;

// Groups

- (THRGroup *)propertyGroup;

@end
