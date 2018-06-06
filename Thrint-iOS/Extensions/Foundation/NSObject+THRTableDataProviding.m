//
//  NSObject+THRTableDataProviding.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-09-29.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "THRGroup.h"
#import "NSObject+THRTableDataProviding.h"

#import <BAFoundation/NSObject+BAIntrospection.h>
#import <BAFoundation/NSManagedObject+BAAdditions.h>

@implementation NSObject (THRItemConforming)

#pragma mark - Class cell implementations

+ (Class)tableViewCellClass {
    return [UITableViewCell class];
}

+ (UITableViewCellStyle)tableViewCellStyle {
    return UITableViewCellStyleDefault;
}

+ (NSString *)tableViewCellReuseIdentifier {
    return @"ListDataSourceCell";
}

+ (UITableViewCell *)newCell {
    return [(UITableViewCell *)[[self tableViewCellClass] alloc] initWithStyle:[self tableViewCellStyle] reuseIdentifier:[self tableViewCellReuseIdentifier]];
}

#pragma mark - Instance cell implementations

- (Class)tableViewCellClass {
    return [[self class] tableViewCellClass];
}

- (UITableViewCellStyle)tableViewCellStyle {
    return [[self class] tableViewCellStyle];
}

- (NSString *)tableViewCellReuseIdentifier {
    return [[self class] tableViewCellReuseIdentifier];
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
    NSString *key = [self titlePropertyKey];
    if (key) {
        tableViewCell.textLabel.text = [self valueForKey:key];
    }
}

#pragma mark - Properties

+ (NSSet *)defaultTitlePropertyKeys {
    return [NSSet setWithArray:@[@"name", @"title"]];
}

+ (NSString *)titlePropertyKey {
    // FIXME: Doing this for every cell we create is not efficient. Should be cached? memoized?
    NSMutableSet *propertyNames = [NSMutableSet setWithArray:[self propertyNames]];
    [propertyNames intersectSet:[self defaultTitlePropertyKeys]];
    return [propertyNames anyObject];
}

+ (NSArray *)valuePropertyKeys {
    return @[];
}

+ (NSArray *)optionPropertyKeys {
    return @[];
}

+ (NSArray *)connectionPropertyKeys {
    return @[];
}

+ (NSArray *)collectionPropertyKeys {
    return [[self propertyInfo] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"valueType = %d", BAValueTypeCollection]];
}

- (NSString *)titlePropertyKey {
    return [[self class] titlePropertyKey];
}

- (NSArray *)valuePropertyKeys {
    return [[self class] valuePropertyKeys];
}

- (NSArray *)optionPropertyKeys {
    return [[self class] optionPropertyKeys];
}

- (NSArray *)connectionPropertyKeys {
    return [[self class] connectionPropertyKeys];
}

- (NSArray *)collectionPropertyKeys {
    return [[self class] collectionPropertyKeys];
}

- (NSArray *)childItems {
    return [[self dictionaryWithValuesForKeys:[self connectionPropertyKeys]] allValues];
}

- (NSArray *)propertyLists {
    return @[];
}

- (THRGroup *)propertyGroup {
    return [THRGroup groupWithLists:[self propertyLists]];
}

@end

#pragma mark -

@implementation NSManagedObject (THRItemConforming)

- (NSString *)titlePropertyKey {
    NSMutableSet *set = [NSMutableSet setWithArray:[self attributeNames]];
    [set intersectSet:[[self class] defaultTitlePropertyKeys]];
    return [set anyObject];
}

@end
