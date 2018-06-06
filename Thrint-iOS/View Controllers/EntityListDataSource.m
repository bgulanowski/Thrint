//
//  EntityListDataSource.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "EntityListDataSource.h"

#import "NSManagedObjectContext+ThrintAdditions.h"
#import "NSManagedObject+ViewAdditions.h"
#import "DetailVC.h"
#import "ListVC.h"

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
        [self reloadContent];
    }
    return self;
}

- (id)initWithOwner:(NSManagedObject *)owner relationship:(NSString *)relationshipName {
    
    NSRelationshipDescription *relationship = [owner relationshipForName:relationshipName];
    NSEntityDescription *contentEntity = [relationship destinationEntity];
    NSString *ownerKey = [[relationship inverseRelationship] name];
    NSPredicate *relationPredicate = [NSPredicate predicateWithFormat:@"%K = %@", ownerKey, owner];
    
    self = [self initWithManagedObjectContext:owner.managedObjectContext entityName:[contentEntity name] predicate:relationPredicate];
    if (self) {
        self.owner = owner;
        self.ownerProperty = ownerKey;
        // TODO: support to-many relationships
        self.selection = [owner valueForKey:relationshipName];
    }
    return self;
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
    
    return object;
}

- (id)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView {
    DetailVC *detailVC = [object detailViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    [(ListVC *)tableView.delegate presentViewController:nav animated:YES completion:nil];
    // fetch controller already updated content and informed us, where we updated view
    return object;
}

- (BOOL)deleteObject:(NSManagedObject *)object {
    [_context deleteObject:object];
    NSError *error = nil;
    if(![_context save:&error]) {
        NSLog(@"%@", error);
        return NO;
    }
    else {
        return YES;
    }
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView {
    [self deleteObject:[_fetchController objectAtIndexPath:indexPath]];
}

- (id)objectAtIndexPath:(NSIndexPath *)path {
    if (_useSections) {
        return [_fetchController objectAtIndexPath:path];
    }
    else {
        return [super objectAtIndexPath:path];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_useSections) {
        return [[_fetchController sections] count];
    }
    else {
        return [super numberOfSectionsInTableView:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_useSections) {
        return [[[_fetchController sections] objectAtIndex:section] numberOfObjects];
    }
    else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    NSIndexPath *insertPath = nil, *deletePath = nil;
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSMutableArray *content = [self mutableContent];
    
    if (!_useSections) {
        if (indexPath) {
            indexPath = [NSIndexPath indexPathForRow:[content indexOfObject:anObject] inSection:0];
        }
        if (newIndexPath) {
            newIndexPath = [NSIndexPath indexPathForRow:[[_fetchController fetchedObjects] indexOfObject:anObject] inSection:0];
        }
    }
    
    if (type == NSFetchedResultsChangeUpdate) {
        [indexPaths addObject:indexPath];
    }
    else {
        if (type == NSFetchedResultsChangeDelete || type == NSFetchedResultsChangeMove) {
            [content removeObjectAtIndex:indexPath.row];
            deletePath = indexPath;
        }
        if (type == NSFetchedResultsChangeInsert || type == NSFetchedResultsChangeMove) {
            [content insertObject:anObject atIndex:newIndexPath.row];
            insertPath = newIndexPath;
        }
    }
    
    UITableView *tableView = self.tableView;

    [tableView beginUpdates];
    if (insertPath) {
        [tableView insertRowsAtIndexPaths:@[insertPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (deletePath) {
        [tableView deleteRowsAtIndexPaths:@[deletePath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if ([indexPaths count]) {
        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    // TODO: implement
#if 0
    NSIndexSet *insertIndex = nil, *deleteIndex = nil, *moveIndex = nil;

    UITableView *tableView = self.tableView;
    
    [tableView beginUpdates];
    if (type == NSFetchedResultsChangeUpdate) {
        moveIndex = [NSIndexSet indexSetWithIndex:sectionIndex];
    }
    else {
        if (type == NSFetchedResultsChangeDelete || type == NSFetchedResultsChangeMove) {
            [content removeObjectAtIndex:indexPath.row];
            deletePath = indexPath;
        }
        if (type == NSFetchedResultsChangeInsert || type == NSFetchedResultsChangeMove) {
            [content insertObject:anObject atIndex:newIndexPath.row];
            insertPath = newIndexPath;
        }
    }
    [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
#endif
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    return sectionName;
}

#pragma mark - New

- (NSArray *)contentFromFetchController {
    NSError *error = nil;
    NSFetchedResultsController *fetchController = self.fetchController;
    if (fetchController && ![fetchController performFetch:&error]) {
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
