//
//  NSEntityDescription+ThrintAdditions.h
//  Thrint
//
//  Created by Brent Gulanowski on 2014-04-21.
//  Copyright (c) 2014 Bored Astronaut. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (ThrintAdditions)

- (NSFetchedResultsController *)defaultFetchControllerForContext:(NSManagedObjectContext *)context;

@end
