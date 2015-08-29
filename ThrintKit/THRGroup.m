//
//  THRGroup.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-28.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRGroup.h"

#import "THRList.h"

@implementation THRGroup {
@protected
    NSMutableArray *_lists;
    dispatch_queue_t _queue;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self countOfLists];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self objectInListsAtIndex:section] countOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self itemAtIndexPath:indexPath] cellForTableView:tableView];
}

#pragma mark - THRGroup

- (NSArray *)lists {
    __block NSArray *lists;
    dispatch_sync(_queue, ^{
        lists = [_lists copy];
    });
    return lists;
}

- (NSUInteger)countOfLists {
    __block NSUInteger count;
    dispatch_sync(_queue, ^{
        count = _lists.count;
    });
    return count;
}

- (id<THRList>)objectInListsAtIndex:(NSUInteger)index {
    __block id<THRList> list;
    dispatch_sync(_queue, ^{
        list = [_lists objectAtIndex:index];
    });
    return list;
}

- (NSArray *)listsAtIndexes:(NSIndexSet *)indexes {
    __block NSArray *lists;
    dispatch_sync(_queue, ^{
        lists = [_lists objectsAtIndexes:indexes];
    });
    return lists;
}

- (id<THRItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self objectInListsAtIndex:indexPath.section] objectInItemsAtIndex:indexPath.row];
}

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithLists:@[]];
}

- (instancetype)initWithLists:(NSArray *)lists {
    self = [super init];
    if (self) {
        _lists = [lists mutableCopy];
    }
    return self;
}

+ (instancetype)groupWithLists:(NSArray *)lists {
    return [[self alloc] initWithLists:lists];
}


@end

@implementation THRMutableGroup

- (void)insertObject:(id<THRList>)list inListsAtIndex:(NSUInteger)index {
    dispatch_sync(_queue, ^{
        [_lists insertObject:list atIndex:index];
    });
}

- (void)insertLists:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    dispatch_sync(_queue, ^{
        [_lists insertObjects:array atIndexes:indexes];
    });
}

- (void)removeObjectFromListsAtIndex:(NSUInteger)index {
    dispatch_sync(_queue, ^{
        [_lists removeObjectAtIndex:index];
    });
}

- (void)removeListsAtIndexes:(NSIndexSet *)indexes {
    dispatch_sync(_queue, ^{
        [_lists removeObjectsAtIndexes:indexes];
    });
}

- (void)replaceObjectInListsAtIndex:(NSUInteger)index withObject:(id<THRList>)list {
    dispatch_sync(_queue, ^{
        [_lists replaceObjectAtIndex:index withObject:list];
    });
}

- (void)replaceListsAtIndexes:(NSIndexSet *)indexes withLists:(NSArray *)lists {
    dispatch_sync(_queue, ^{
        [_lists replaceObjectsAtIndexes:indexes withObjects:lists];
    });
}

- (THRMutableList *)mutableListAtIndex:(NSUInteger)index {
    THRList *list = [self objectInListsAtIndex:index];
    THRMutableList *mutableList = nil;
    if ([list respondsToSelector:@selector(mutableProxy)]) {
        mutableList = [list mutableProxy];
    }
    return mutableList;
}

- (void)insertItem:(NSObject<THRItem> *)item atIndexPath:(NSIndexPath *)indexPath {
    [[self mutableListAtIndex:indexPath.section] insertObject:item inItemsAtIndex:indexPath.row];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    [[self mutableListAtIndex:indexPath.section] removeObjectFromItemsAtIndex:indexPath.row];
}


- (void)replaceItemAtIndexPath:(NSIndexPath *)indexPath withItem:(NSObject<THRItem> *)item {
    [[self mutableListAtIndex:indexPath.section] replaceObjectInItemsAtIndex:indexPath.row withObject:item];
}

@end
