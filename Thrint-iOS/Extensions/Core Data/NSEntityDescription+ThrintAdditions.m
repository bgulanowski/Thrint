//
//  NSEntityDescription+ThrintAdditions.m
//  Thrint
//
//  Created by Brent Gulanowski on 2014-04-21.
//  Copyright (c) 2014 Bored Astronaut. All rights reserved.
//

#import "NSEntityDescription+ThrintAdditions.h"

#import <BAFoundation/NSEntityDescription+BAAdditions.h>

@implementation NSEntityDescription (ThrintAdditions)

- (NSFetchedResultsController *)defaultFetchControllerForContext:(NSManagedObjectContext *)context {
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:[self defaultFetchRequest]
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:[self defaultSortKey]
                                                                                            cacheName:nil];
    return controller;
}

@end
