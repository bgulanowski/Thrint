//
//  NSManagedObjectContext+BAAdditions.m
//  Bored Astronaut Additions
//
//  Created by Brent Gulanowski on 22/02/08.
//  Copyright 2008 Bored Astronaut. All rights reserved.
//

#import "NSManagedObjectContext+BAAdditions.h"
#import "NSManagedObject+BAAdditions.h"


NSString *defaultStoreName = @"Data Store";


@implementation NSManagedObjectContext (BAAdditions)

static NSManagedObjectContext *activeContext;

+ (void)load {
	activeContext = nil;
}

+ (NSString *)defaultStorePath {

	NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
	NSString *processName = [[NSProcessInfo processInfo] processName];
	NSString *fileName = [defaultStoreName stringByAppendingPathExtension:@"sqlite"];

	return [NSString pathWithComponents:[NSArray arrayWithObjects:appSupport, processName, fileName, nil]];
}

+ (NSManagedObjectContext *)configuredContextForStorePath:(NSString *)path model:(NSManagedObjectModel *)model type:(NSString *)storeType {
	
	NSError *error = nil;
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	NSPersistentStoreCoordinator *coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	NSPersistentStore *store = nil;

	if(![[NSFileManager defaultManager] createDirectoryAtPath:[path stringByDeletingLastPathComponent]
								  withIntermediateDirectories:YES 
												   attributes:nil
														error:&error])
		NSLog(@"Error creating directory: %@", error);
	else
		store = [coord addPersistentStoreWithType:storeType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:&error];
	
	if(nil == store && nil != error)
		NSLog(@"Error creating persistent store at path '%@': '%@'.", path, error);
	
	[context setPersistentStoreCoordinator:coord];

	[self setActiveContext:context];
	
	return context;
}

+ (NSManagedObjectContext *)configuredContextForStorePath:(NSString *)path model:(NSManagedObjectModel *)model {
	return [self configuredContextForStorePath:path model:model type:NSSQLiteStoreType];
}

+ (NSManagedObjectContext *)configuredContextWithDefaultStoreForModel:(NSManagedObjectModel *)model {

	NSString *path = [self defaultStorePath];
	
	return [self configuredContextForStorePath:path model:model];
}

+ (NSManagedObjectContext *)configuredContextWithDefaultStoreForName:(NSString *)name {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"mom"];
    
    if(!path)
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"];
    
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
									
	return [self configuredContextWithDefaultStoreForModel:model];
}

+ (NSManagedObjectContext *)activeContext {
	return activeContext;
}

+ (void)setActiveContext:(NSManagedObjectContext *)context {
	activeContext = context;
}

- (void)makeActive {
	[NSManagedObjectContext setActiveContext:self];
}

- (NSManagedObjectContext *)editingContext {
        
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editorSaved:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:moc];
    moc.persistentStoreCoordinator = self.persistentStoreCoordinator;

    return moc;
}

- (void)editorSaved:(NSNotification *)note {
    [self mergeChangesFromContextDidSaveNotification:note];
//    [[note object] reset];
}

- (NSArray *)objectsForEntityNamed:(NSString *)entity matchingValue:(id)aValue forKey:(NSString *)aKey {
	
	NSPredicate *pred = nil;
	
	if(nil != aValue && nil != aKey) {
		NSString *format = [NSString stringWithFormat:@"%@ LIKE[c] ", aKey];
		format = [format stringByAppendingString:@"%@"];
		pred = [NSPredicate predicateWithFormat:format, aValue];
	}
	
	return [self objectsForEntityNamed:entity matchingPredicate:pred];
}

- (id)objectForEntityNamed:(NSString *)entity matchingValue:(id)aValue forKey:(NSString *)aKey {
	return [[self objectsForEntityNamed:entity matchingValue:aValue forKey:aKey] lastObject];
}

- (NSArray *)objectsForEntityNamed:(NSString *)entityName matchingPredicate:(NSPredicate *)aPredicate {
	
	NSArray *result = nil;
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    Class class = NSClassFromString([entity managedObjectClassName]);
	NSError *error = nil;
	
	if(nil != aPredicate)
		[fetch setPredicate:aPredicate];

	[fetch setEntity:entity];
    [fetch setSortDescriptors:[class defaultSortDescriptors]];

	result = [self executeFetchRequest:fetch error:&error];
	if(nil != error) {
		NSLog(@"Please respond to this error: %@", error);
	}
	
	return result;
}

- (id)objectForEntityNamed:(NSString *)entity matchingPredicate:(NSPredicate *)aPredicate {
	return [[self objectsForEntityNamed:entity matchingPredicate:aPredicate] lastObject];
}

- (id)objectForEntityNamed:(NSString *)entity matchingValue:(id)aValue forKey:(NSString *)aKey create:(BOOL*)create {
	
	id object = nil;
	
	if(aValue && aKey)
		object = [self objectForEntityNamed:entity matchingValue:aValue forKey:aKey];
	
	if(create && *create) {
		if(object) {
			*create = NO;
		}
		else {
			object = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self];
			[object setValue:aValue forKey:aKey];
		}
	}
	
	return object;
}

- (NSManagedObject *)objectWithIDString:(NSString *)IDString {
    NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:IDString]];
	return objectID ? [self existingObjectWithID:objectID error:NULL] : nil;
}

@end
