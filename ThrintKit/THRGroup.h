//
//  THRGroup.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-28.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THRItem;
@protocol THRList;

@interface THRGroup : NSObject <UITableViewDataSource>

@property (readonly, copy) NSArray *lists;
- (NSUInteger)countOfLists;
- (id<THRList>)objectInListsAtIndex:(NSUInteger)index;
- (NSArray *)listsAtIndexes:(NSIndexSet *)indexes;

- (id<THRItem>)itemAtIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithLists:(NSArray *)lists NS_DESIGNATED_INITIALIZER;
+ (instancetype)groupWithLists:(NSArray *)lists;

@end

@interface THRMutableGroup : THRGroup

- (void)insertObject:(id<THRList>)list inListsAtIndex:(NSUInteger)index;
- (void)insertLists:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (void)removeObjectFromListsAtIndex:(NSUInteger)index;
- (void)removeListsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInListsAtIndex:(NSUInteger)index withObject:(id<THRList>)list;
- (void)replaceListsAtIndexes:(NSIndexSet *)indexes withLists:(NSArray *)lists;

- (void)insertItem:(id<THRItem>)item atIndexPath:(NSIndexPath *)indexPath;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)replaceItemAtIndexPath:(NSIndexPath *)indexPath withItem:(id<THRItem>)item;

@end
