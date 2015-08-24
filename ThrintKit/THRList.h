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
@protocol THRSection;

@protocol THRList <NSObject>

@property (readonly, copy) NSArray *items;

- (NSUInteger)countOfItems;
- (id<THRItem>)objectInItemsAtIndex:(NSUInteger)index;
- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes;

@end

@protocol THRMutableList <THRList>

- (void)setItems:(NSArray *)items;

- (void)insertObject:(id<THRItem>)object inItemsAtIndex:(NSUInteger)index;
- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (void)removeObjectFromItemsAtIndex:(NSUInteger)index;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(id<THRItem>)item;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items;

@end

@class THRPropertyList;

@protocol THRItem <NSObject>

- (NSArray *)childItems;
- (THRPropertyList *)propertyList;

@end

@protocol THRSection <NSObject>

- (UIView *)headerView;
- (UIView *)footerView;
- (UITableViewCell *)cellForRow:(NSUInteger)row;

@end


@interface THRList : NSObject<THRMutableList>
- (instancetype)initWithItems:(NSArray *)items;
+ (instancetype)listWithItems:(NSArray *)items;
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
