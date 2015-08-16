//
//  THRList.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-03-31.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THRList <NSObject>

@property (readonly, copy) NSArray *items;

- (NSUInteger)countOfItems;
- (id)objectInItemsAtIndex:(NSUInteger)index;
- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes;

@end

@protocol THRMutableList <THRList>

- (void)setItems:(NSArray *)items;

- (void)insertObject:(id)object inItemsAtIndex:(NSUInteger)index;
- (void)insertItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (void)removeObjectFromItemsAtIndex:(NSUInteger)index;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(id)item;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items;

@end

@interface THRList : NSObject<THRMutableList>
@end

@interface THRSavedList : NSObject<THRList>
- (instancetype)initWithRequest:(NSFetchRequest *)request managedObjectContext:(NSManagedObjectContext *)objectContext;
@end

@interface NSManagedObjectContext (THRListCreating)
- (THRSavedList *)listWithRequest:(NSFetchRequest *)request;
- (NSString *)defaultSortKeyForEntity:(NSEntityDescription *)entity;
@end
