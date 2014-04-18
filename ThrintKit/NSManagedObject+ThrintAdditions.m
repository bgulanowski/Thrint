//
//  NSManagedObject+ThrintAdditions.m
//  Thrint
//
//  Created by Brent Gulanowski on 2014-04-18.
//  Copyright (c) 2014 Bored Astronaut. All rights reserved.
//

#import "NSManagedObject+ThrintAdditions.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import <CoreData/CoreData.h>

@implementation NSManagedObject (ThrintAdditions)

+ (NSFetchRequest *)defaultFetchRequest {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    fetch.predicate = predicate;
    fetch.sortDescriptors = [self defaultSortDescriptors];
    return fetch;
}

+ (NSFetchedResultsController *)defaultFetchControllerForContext:(NSManagedObjectContext *)context {
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:[self defaultFetchRequest]
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
    return controller;
}

@end
