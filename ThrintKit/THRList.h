//
//  THRList.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-03-31.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@protocol THRItem;
@protocol THRGroup;

@protocol THRList <NSObject>

@property (readonly, copy) NSArray *items;

- (NSUInteger)countOfItems;
- (NSObject<THRItem> *)objectInItemsAtIndex:(NSUInteger)index;
- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes;

@end


@protocol THRSectionedList <NSObject>
- (NSObject<THRItem> *)itemAtIndexPath:(NSIndexPath *)indexPath;
@end


@protocol THRGroupedList <THRList, THRSectionedList>

@property (readonly, copy) NSArray *groups;

- (NSUInteger)countOfGroups;
- (NSObject<THRGroup> *)objectInGroupsAtIndex:(NSUInteger)index;
- (NSArray *)groupsAtIndexes:(NSIndexSet *)indexes;

@end


@protocol THRMutableList <THRList>

- (void)setItems:(NSArray *)items;

- (void)insertObject:(NSObject<THRItem> *)object inItemsAtIndex:(NSUInteger)index;
- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (void)removeObjectFromItemsAtIndex:(NSUInteger)index;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(NSObject<THRItem> *)item;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items;

@end


@protocol THRMutableSectionedList <NSObject>
- (void)insertItem:(NSObject<THRItem> *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)replaceItemAtIndexPath:(NSIndexPath *)indexPath withItem:(NSObject<THRItem> *)item;
@end


@protocol THRMutableGroupedList <THRMutableList, THRGroupedList>

- (void)insertObject:(NSObject<THRGroup> *)group inGroupsAtIndex:(NSUInteger)index;
- (void)insertGroups:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (void)removeObjectFromGroupsAtIndex:(NSUInteger)index;
- (void)removeGroupsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInGroupsAtIndex:(NSUInteger)index withObject:(NSObject<THRGroup> *)group;
- (void)replaceGroupsAtIndexes:(NSIndexSet *)indexes withGroups:(NSArray *)groups;

@end


@class THRPropertyList;

@protocol THRItem <NSObject>

- (NSString *)listRepresentation;

@optional
- (THRPropertyList *)propertyList;
- (NSArray *)childItems;

@end


// For now, a Group is just a List.
// This may a problem, since a list is immutable.
@protocol THRGroup <THRList, THRItem>
@end


@interface THRList : NSObject<THRMutableList>
- (instancetype)initWithItems:(NSArray *)items NS_DESIGNATED_INITIALIZER;
+ (instancetype)listWithItems:(NSArray *)items;
@end


@interface THRGroupedList : THRList<THRMutableGroupedList>
- (instancetype)initWithGroups:(NSArray *)groups NS_DESIGNATED_INITIALIZER;
+ (instancetype)groupedListWithGroups:(NSArray *)groups;
@end


// THRManaged(Object)List? Move to another file?

@interface THRSavedList : NSObject<THRList>
// -initWithEntityName:managedObjectContext: ?
- (instancetype)initWithRequest:(NSFetchRequest *)request managedObjectContext:(NSManagedObjectContext *)objectContext;
@end


@interface NSManagedObjectContext (THRListCreating)

// -listForEntityName:?
- (THRSavedList *)listWithRequest:(NSFetchRequest *)request;
@end
