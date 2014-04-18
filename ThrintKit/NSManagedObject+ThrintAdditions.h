//
//  NSManagedObject+ThrintAdditions.h
//  Thrint
//
//  Created by Brent Gulanowski on 2014-04-18.
//  Copyright (c) 2014 Bored Astronaut. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ThrintAdditions)

+ (NSFetchRequest *)defaultFetchRequest;
+ (NSFetchedResultsController *)defaultFetchControllerForContext:(NSManagedObjectContext *)context;

@end
