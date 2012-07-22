//
//  NSManagedObjectContext+BAAdditions.h
//  Bored Astronaut Additions
//
//  Created by Brent Gulanowski on 22/02/08.
//  Copyright 2008 Bored Astronaut. All rights reserved.
//

#import <CoreData/CoreData.h>


#define BAActiveContext [NSManagedObjectContext activeContext]


extern NSString *defaultStoreName;


@interface NSManagedObjectContext (BAAdditions)

+ (NSString *)defaultStorePath;
+ (NSManagedObjectContext *)configuredContextForStorePath:(NSString *)path model:(NSManagedObjectModel *)model type:(NSString *)storeType;
+ (NSManagedObjectContext *)configuredContextForStorePath:(NSString *)path model:(NSManagedObjectModel *)model;
+ (NSManagedObjectContext *)configuredContextWithDefaultStoreForModel:(NSManagedObjectModel *)model;
+ (NSManagedObjectContext *)configuredContextWithDefaultStoreForName:(NSString *)name;

// NOT retained
+ (NSManagedObjectContext *)activeContext;
+ (void)setActiveContext:(NSManagedObjectContext *)context;

- (NSManagedObjectContext *)editingContext;

- (void)makeActive;

- (NSArray *)objectsForEntityNamed:(NSString *)entity matchingPredicate:(NSPredicate *)aPredicate;
- (id)objectForEntityNamed:(NSString *)entity matchingPredicate:(NSPredicate *)aPredicate;

- (NSArray *)objectsForEntityNamed:(NSString *)entity matchingValue:(id)aValue forKey:(NSString *)aKey;
- (id)objectForEntityNamed:(NSString *)entity matchingValue:(id)aValue forKey:(NSString *)aKey;

- (id)objectForEntityNamed:(NSString *)entity matchingValue:(id)aValue forKey:(NSString *)aKey create:(BOOL*)create;

- (NSManagedObject *)objectWithIDString:(NSString *)IDString;

@end
