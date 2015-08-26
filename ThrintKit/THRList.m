//
//  THRList.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-03-31.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRList.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>
#import <BAFoundation/NSEntityDescription+BAAdditions.h>

@interface THRList ()
@end

@implementation THRList {
    NSMutableArray *_items;
@protected
    dispatch_queue_t _queue;
}

- (instancetype)init {
    return [self initWithItems:[NSArray array]];
}

#pragma mark - THRList

- (NSArray *)items {
    __block NSArray *items;
    dispatch_sync(_queue, ^{
        items = [_items copy];
    });
    return items;
}

- (NSUInteger)countOfItems {
    __block NSUInteger count;
    dispatch_sync(_queue, ^{
        count = _items.count;
    });
    return count;
}

- (NSObject<THRItem> *)objectInItemsAtIndex:(NSUInteger)index
{
    __block id item;
    dispatch_sync(_queue, ^{
        item = [_items objectAtIndex:index];
    });
    return item;
}

- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes {
    __block NSArray *items;
    dispatch_sync(_queue, ^{
        items = [_items objectsAtIndexes:indexes];
    });
    return items;
}

#pragma mark - THRMutableList

- (void)setItems:(NSArray *)items {
    dispatch_sync(_queue, ^{
        [_items removeAllObjects];
        [_items addObjectsFromArray:items];
    });
}

- (void)insertObject:(NSObject<THRItem> *)item inItemsAtIndex:(NSUInteger)index {
    dispatch_sync(_queue, ^{
        [_items insertObject:item atIndex:index];
    });
}

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes {
    dispatch_sync(_queue, ^{
        [_items insertObjects:items atIndexes:indexes];
    });
}

- (void)removeObjectFromItemsAtIndex:(NSUInteger)index {
    dispatch_sync(_queue, ^{
        [_items removeObjectAtIndex:index];
    });
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes {
    dispatch_sync(_queue, ^{
        [_items removeObjectsAtIndexes:indexes];
    });
}

- (void)replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(NSObject<THRItem> *)item {
    dispatch_sync(_queue, ^{
        [_items replaceObjectAtIndex:index withObject:item];
    });
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items {
    dispatch_sync(_queue, ^{
        [_items replaceObjectsAtIndexes:indexes withObjects:items];
    });
}

#pragma mark - Initializer

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        _items = [items mutableCopy];
    }
    return self;
}

+ (instancetype)listWithItems:(NSArray *)items {
    return [[self alloc] initWithItems:items];
}

@end

#pragma mark -

@implementation THRGroupedList {
    // Maybe we should re-use the items in the superclass to hold the groups?
    // Problems: a group can be an item, but an item can't be a group.
    //           groups are sublists. items are not sub-lists.
    NSMutableArray *_groups;
}

#pragma mark - THRList

- (instancetype)initWithItems:(NSArray *)items {
    return [self initWithGroups:@[]];
}

#pragma mark - THRSectionedList

- (NSObject<THRItem> *)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self objectInGroupsAtIndex:indexPath.section] objectInItemsAtIndex:indexPath.row];
}

#pragma mark - THRGroupedList Protocol

- (NSArray *)groups {
    __block NSArray *groups;
    dispatch_sync(_queue, ^{
        groups = [_groups copy];
    });
    return groups;
}

- (NSUInteger)countOfGroups {
    __block NSUInteger count;
    dispatch_sync(_queue, ^{
        count = _groups.count;
    });
    return count;
}

- (NSObject<THRGroup> *)objectInGroupsAtIndex:(NSUInteger)index {
    __block NSObject<THRGroup> *group;
    dispatch_sync(_queue, ^{
        group = [_groups objectAtIndex:index];
    });
    return group;
}

- (NSArray *)groupsAtIndexes:(NSIndexSet *)indexes {
    __block NSArray *groups;
    dispatch_sync(_queue, ^{
        groups = [_groups objectsAtIndexes:indexes];
    });
    return groups;
}

#pragma mark - THRMutableGroupedList

- (void)insertObject:(NSObject<THRGroup> *)group inGroupsAtIndex:(NSUInteger)index {
    dispatch_sync(_queue, ^{
        [_groups insertObject:group atIndex:index];
    });
}

- (void)insertGroups:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    dispatch_sync(_queue, ^{
        [_groups insertObjects:array atIndexes:indexes];
    });
}

- (void)removeObjectFromGroupsAtIndex:(NSUInteger)index {
    dispatch_sync(_queue, ^{
        [_groups removeObjectAtIndex:index];
    });
}

- (void)removeGroupsAtIndexes:(NSIndexSet *)indexes {
    dispatch_sync(_queue, ^{
        [_groups removeObjectsAtIndexes:indexes];
    });
}

- (void)replaceObjectInGroupsAtIndex:(NSUInteger)index withObject:(NSObject<THRGroup> *)group {
    dispatch_sync(_queue, ^{
        [_groups replaceObjectAtIndex:index withObject:group];
    });
}

- (void)replaceGroupsAtIndexes:(NSIndexSet *)indexes withGroups:(NSArray *)groups {
    dispatch_sync(_queue, ^{
        [_groups replaceObjectsAtIndexes:indexes withObjects:groups];
    });
}

#pragma mark - THRGroupedList Class

- (instancetype)initWithGroups:(NSArray *)groups {
    self = [super initWithItems:nil];
    if (self) {
        _groups = [groups mutableCopy];
    }
    return self;
}

+ (instancetype)groupedListWithGroups:(NSArray *)groups {
    return [[self alloc] initWithGroups:groups];
}

@end

#pragma mark -

@interface THRSavedList ()
@property (nonatomic, strong) NSFetchedResultsController *fetch;
@end

/*
 Core Data is not inherently thread safe, so this class is not, either. But maybe we could make this object
 support multiple core data contexts and fetch controllers, and keep objects in sync between them.
 */

@implementation THRSavedList

- (instancetype)initWithRequest:(NSFetchRequest *)request managedObjectContext:(NSManagedObjectContext *)objectContext {
    self = [super init];
    if (self) {
        self.fetch = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:objectContext sectionNameKeyPath:[request.entity defaultSortKey] cacheName:nil];
    }
    return self;
}

#pragma mark - THRList

- (NSArray *)items {
    return self.fetch.fetchedObjects;
}

- (NSUInteger)countOfItems {
    return [self.fetch.sections[0] numberOfObjects];
}

- (id)objectInItemsAtIndex:(NSUInteger)index {
    return [self.fetch objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes {
    return [self.fetch.fetchedObjects objectsAtIndexes:indexes];
}

@end

#pragma mark -

@implementation NSManagedObjectContext (THRListCreating)

- (THRSavedList *)listWithRequest:(NSFetchRequest *)request {
    return [[THRSavedList alloc] initWithRequest:request managedObjectContext:self];
}

@end