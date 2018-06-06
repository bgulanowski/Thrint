//
//  NSManagedObjectContext+ThrintAdditions.m
//  Thrint
//
//  Created by Brent Gulanowski on 2014-04-18.
//  Copyright (c) 2014 Bored Astronaut. All rights reserved.
//

#import "NSManagedObjectContext+ThrintAdditions.h"

#import "NSEntityDescription+ThrintAdditions.h"

#import <BAFoundation/NSEntityDescription+BAAdditions.h>
#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>

@implementation NSManagedObjectContext (ThrintAdditions)

- (NSFetchedResultsController *)defaultFetchControllerForEntityName:(NSString *)entityName {
    return [[self entityForName:entityName] defaultFetchControllerForContext:self];
}

@end
