//
//  THRList.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-03-31.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import <Thrint/THRItem.h>

@protocol THRMutableList;

@protocol THRList <UITableViewDataSource>

@property (readonly, copy) NSArray *items;

- (NSUInteger)countOfItems;
- (NSObject<THRItem> *)objectInItemsAtIndex:(NSUInteger)index;
- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes;

@optional
- (id<THRMutableList>)mutableProxy;

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

@interface THRList : NSObject <THRList>
- (instancetype)initWithItems:(NSArray *)items;
+ (instancetype)listWithItems:(NSArray *)items;
@end

@interface THRMutableList : THRList <THRMutableList>
@end


// THRManaged(Object)List? Move to another file?

@interface THRSavedList : THRList
// -initWithEntityName:managedObjectContext: ?
- (instancetype)initWithRequest:(NSFetchRequest *)request managedObjectContext:(NSManagedObjectContext *)objectContext;
@end


@interface NSManagedObjectContext (THRListCreating)

// -listForEntityName:?
- (THRSavedList *)listWithRequest:(NSFetchRequest *)request;
@end
