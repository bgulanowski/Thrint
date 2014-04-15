//
//  EntityListDataSource.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "EntityListDataSource.h"

#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>
#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"
#import <BAFoundation/BACoreDataManager.h>


@implementation EntityListDataSource

@synthesize deletePreparation=_deletePreparation;
@synthesize context=_context;
@synthesize predicate=_predicate;
@synthesize entityName=_entityName;
@synthesize ignoreSaves=_ignoreSaves;

#pragma mark - Accessors
- (void)setEntityName:(NSString *)entityName {
    if(![_entityName isEqualToString:entityName]) {
        _entityName = entityName;
        self.content = nil;
    }
}

- (void)setContext:(NSManagedObjectContext *)moc {
    if(![moc isEqual:_context]) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        if(_context) [nc removeObserver:self];
        _context = moc;
        self.content = nil;
        if(_context)
            [nc addObserver:self selector:@selector(contextSaved:) name:NSManagedObjectContextDidSaveNotification object:_context];
    }
}

- (void)setPredicate:(NSPredicate *)predicate {
    if(![predicate isEqual:_predicate]) {
        _predicate = predicate;
        self.content = nil;
    }
}


#pragma mark - Initializer
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName predicate:(NSPredicate *)predicate {
    self = [self init];
    if(self) {
        self.predicate = predicate;
        self.entityName = entityName;
        self.context = context;
    }
    return self;
}

- (id)initWithObject:(NSManagedObject *)object entityName:(NSString *)entityName keyPath:(NSString *)keyPath {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", keyPath, object];
    return [self initWithManagedObjectContext:[object managedObjectContext] entityName:entityName predicate:predicate];
}


#pragma mark - LisdDataSourceSubclass
- (NSInteger)indexForInsertedObject:(id)object {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityName inManagedObjectContext:_context];
    Class class = NSClassFromString([entity managedObjectClassName]);
    NSString *key = [class defaultSortKey];

    return [self.content indexOfObject:object
                         inSortedRange:NSMakeRange(0, [self.content count])
                               options:NSBinarySearchingInsertionIndex
                       usingComparator:^NSComparisonResult(id obj1, id obj2) {
                           return [[obj1 valueForKey:key] compare:[obj2 valueForKey:key]];
                       }];
}

- (id)insertObject {
    
    NSManagedObject *object = [super insertObject];
    
    if(!object) {
        
        NSString *className = [[NSEntityDescription entityForName:self.entityName inManagedObjectContext:_context] managedObjectClassName];
        
        object = [NSClassFromString(className) insertObject];
    }
    
    _ignoreSaves = YES;
    [[UIApplication modelManager] save];
    _ignoreSaves = NO;

    return object;
}

- (BOOL)deleteObject:(NSManagedObject *)object {

    if(_deletePreparation && !_deletePreparation(object)) return NO;

    self.ignoreSaves = YES;
    [object.managedObjectContext deleteObject:object];
    [[UIApplication modelManager] save];
    self.ignoreSaves = NO;
    
    return YES;
}


#pragma mark - New
- (void)reloadContent {
    if(!_context || !_entityName) {
        self.content = nil;
        return;
    }
    
    // preserve selection when reloading
    id selection = self.selection;
    
    // delegate will be notified in -setContent:
    self.content = [NSMutableArray arrayWithArray:[_context objectsForEntityNamed:_entityName matchingPredicate:self.predicate]];
    if(selection) self.selection = selection;
}


#pragma mark - Notifications
- (void)contextSaved:(NSNotification *)note {
    if(!_ignoreSaves) {
        // if we push a view that edits in a different context, when our context saves, there are no changes tracked !! grr
//        if([[note userInfo] hasInsertsOrDeletesForEntityNamed:_entityName])
            [self reloadContent];
    }
}

@end

@implementation NSDictionary (ManagedObjectContextNotifications)

- (BOOL)hasInsertsOrDeletesForEntityNamed:(NSString *)entityName {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"entity.name = %@", entityName];
    
    return ([[[self valueForKey:NSInsertedObjectsKey] filteredSetUsingPredicate:pred] count] ||
            [[[self valueForKey:NSDeletedObjectsKey] filteredSetUsingPredicate:pred] count]);

}

@end
