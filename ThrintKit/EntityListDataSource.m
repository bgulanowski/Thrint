//
//  EntityListDataSource.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "EntityListDataSource.h"

#import "NSManagedObjectContext+ThrintAdditions.h"
#import "NSManagedObject+ThrintAdditions.h"
#import "NSManagedObject+ViewAdditions.h"

#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>
#import <BAFoundation/NSManagedObject+BAAdditions.h>
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
        if(_context && !self.fetchController)
            [nc addObserver:self selector:@selector(contextSaved:) name:NSManagedObjectContextDidSaveNotification object:_context];
    }
}

- (void)setPredicate:(NSPredicate *)predicate {
    if(![predicate isEqual:_predicate]) {
        _predicate = predicate;
        self.content = nil;
    }
}

- (NSFetchedResultsController *)fetchController {
    if (!_fetchController) {
        _fetchController = [self.context defaultFetchControllerForEntityName:self.entityName];
        _fetchController.delegate = self;
    }
    return _fetchController;
}

#pragma mark - Designated Initializer

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


#pragma mark - LisdDataSource

- (NSInteger)indexForInsertedObject:(id)object {
    NSString *key = [[self.context classForEntityName:self.entityName] defaultSortKey];
    NSArray *content = self.content;
    return [content indexOfObject:object
                    inSortedRange:NSMakeRange(0, [content count])
                          options:NSBinarySearchingInsertionIndex
                  usingComparator:^NSComparisonResult(id obj1, id obj2) {
                      return [[obj1 valueForKey:key] compare:[obj2 valueForKey:key]];
                  }];
}

- (id)insertObject {
    
    NSManagedObject *object = [super insertObject];
    if(!object) {
        object = [[self.context classForEntityName:self.entityName] insertObject];
		if (self.owner && self.ownerProperty) {
			[object setValue:self.owner forKey:self.ownerProperty];
		}
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


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    NSMutableArray *indexPaths = [NSMutableArray array];
    NSMutableArray *content = [self mutableContent];
    
    if (type == NSFetchedResultsChangeUpdate) {
        [indexPaths addObject:indexPath];
    }
    else {
        if (type == NSFetchedResultsChangeDelete || type == NSFetchedResultsChangeMove) {
            [content removeObjectAtIndex:indexPath.row];
            [indexPaths addObject:indexPath];
        }
        if (type == NSFetchedResultsChangeInsert || type == NSFetchedResultsChangeMove) {
            [content insertObject:anObject atIndex:newIndexPath.row];
            [indexPaths addObject:newIndexPath];
        }
    }
    
    UITableView *tableView = self.tableView;

    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    return sectionName;
}

#pragma mark - New

- (NSArray *)contentFromFetchController {
    NSError *error = nil;
    NSFetchedResultsController *fetchController = self.fetchController;
    if (![fetchController performFetch:&error]) {
        NSLog(@"%@", error);
    }
    return [fetchController fetchedObjects];
}

- (NSArray *)contentFromContext {
    return [NSMutableArray arrayWithArray:[self.context objectsForEntityNamed:self.entityName matchingPredicate:self.predicate]];
}

- (void)reloadContent {
    
    // preserve selection when reloading
    id selection = self.selection;

    NSArray *content = [self contentFromFetchController];
    if (!content && _context && _entityName) {
        content = [self contentFromContext];
    }
    
    // delegate will be notified in -setContent:
    self.content = content;

    if(selection)
        self.selection = selection;
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
