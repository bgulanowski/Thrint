//
//  NSManagedObjectContext+ThrintAdditions.m
//  Thrint
//
//  Created by Brent Gulanowski on 2014-04-18.
//  Copyright (c) 2014 Bored Astronaut. All rights reserved.
//

#import "NSManagedObjectContext+ThrintAdditions.h"
#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>

@implementation NSManagedObjectContext (ThrintAdditions)

- (NSFetchedResultsController *)defaultFetchControllerForEntityName:(NSString *)entityName {
    return [[self classForEntityName:entityName] defaultFetchControllerForContext:self];
}

@end
