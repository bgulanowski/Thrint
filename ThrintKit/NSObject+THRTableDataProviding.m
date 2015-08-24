//
//  NSObject+THRTableDataProviding.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-09-29.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "NSObject+THRTableDataProviding.h"

#import <BAFoundation/NSObject+BAIntrospection.h>

@implementation NSObject (THRTableDataProviding)

- (NSString *)listRepresentation {
    return [self description];
}

+ (Class)tableViewCellClass {
    return [UITableViewCell class];
}

- (Class)tableViewCellClass {
    return [[self class] tableViewCellClass];
}

+ (UITableViewCellStyle)tableViewCellStyle {
    return UITableViewCellStyleDefault;
}

- (UITableViewCellStyle)tableViewCellStyle {
    return [[self class] tableViewCellStyle];
}

+ (NSString *)tableViewCellReuseIdentifier {
    return @"ListDataSourceCell";
}

- (NSString *)tableViewCellReuseIdentifier {
    return [[self class] tableViewCellReuseIdentifier];
}

+ (UITableViewCell *)newCell {
    return [(UITableViewCell *)[[self tableViewCellClass] alloc] initWithStyle:[self tableViewCellStyle] reuseIdentifier:[self tableViewCellReuseIdentifier]];
}

- (UITableViewCell *)newCell {
    return [[self class] newCell];
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self tableViewCellReuseIdentifier]] ?: [self newCell];
    [self configureTableViewCell:cell];
    return cell;
}

- (void)configureTableViewCell:(UITableViewCell *)tableViewCell {
    tableViewCell.textLabel.text = [self listRepresentation];
}

@end
