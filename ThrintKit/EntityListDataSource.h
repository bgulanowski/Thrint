//
//  EntityListDataSource.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "ListDataSource.h"


typedef BOOL (^DeletePreparation)(NSManagedObject *object);


@interface EntityListDataSource : ListDataSource<NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *context;

@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSManagedObject *owner;

@property (nonatomic, copy)   DeletePreparation deletePreparation;

@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSString *ownerProperty;

@property (nonatomic) BOOL ignoreSaves;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (id)initWithObject:(NSManagedObject *)object entityName:(NSString *)entityName keyPath:(NSString *)keyPath;

@end

@interface NSDictionary (ManagedObjectContextNotifications)
- (BOOL)hasInsertsOrDeletesForEntityNamed:(NSString *)entityName;
@end
