//
//  EntityListDataSource.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "ListDataSource.h"


typedef BOOL (^DeletePreparation)(NSManagedObject *object);


@interface EntityListDataSource : ListDataSource

@property (nonatomic, copy)   DeletePreparation deletePreparation;

@property (nonatomic, assign) NSManagedObjectContext *context;
@property (nonatomic, retain) NSPredicate *predicate;
@property (nonatomic, retain) NSString *entityName;

@property (nonatomic) BOOL ignoreSaves;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (id)initWithObject:(NSManagedObject *)object entityName:(NSString *)entityName keyPath:(NSString *)keyPath;

@end

@interface NSDictionary (ManagedObjectContextNotifications)
- (BOOL)hasInsertsOrDeletesForEntityNamed:(NSString *)entityName;
@end
