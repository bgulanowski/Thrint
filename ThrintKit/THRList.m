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

@implementation THRList {
    NSMutableArray *_items;
    dispatch_queue_t _queue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
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

- (id)objectInItemsAtIndex:(NSUInteger)index
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

- (void)insertObject:(id)item inItemsAtIndex:(NSUInteger)index {
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
    
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes {
    
}

- (void)replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(id)item {
    dispatch_sync(_queue, ^{
        [_items replaceObjectAtIndex:index withObject:item];
    });
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items {
    dispatch_sync(_queue, ^{
        [_items replaceObjectsAtIndexes:indexes withObjects:items];
    });
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
        self.fetch = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:objectContext sectionNameKeyPath:[objectContext defaultSortKeyForEntity:request.entity] cacheName:nil];
    }
    return self;
}

#pragma mark -

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

- (NSString *)defaultSortKeyForEntity:(NSEntityDescription *)entity {
    return [[self classForEntityName:entity.name] defaultSortKey];
}

@end