//
//  THRPropertyList+THRTableDataProviding.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRPropertyList+THRTableDataProviding.h"

#import "NSObject+THRTableDataProviding.h"

@implementation THRPropertyList (THRTableDataProviding)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return THRPropertyTypeCount;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.properties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.properties[indexPath.row] cellForTableView:tableView];
}

@end

@implementation THRProperty (THRTableDataProviding)

+ (NSString *)tableViewCellReuseIdentifier {
    return NSStringFromClass(self);
}

+ (UITableViewCell *)newCell {
    return [(UITableViewCell *)[[self tableViewCellClass] alloc] initWithStyle:[self tableViewCellStyle] reuseIdentifier:[self tableViewCellReuseIdentifier]];
}

- (UITableViewCell *)newCell {
    return [[self class] newCell];
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self tableViewCellReuseIdentifier]] ?: [self newCell];
    
    return cell;
}

@end
