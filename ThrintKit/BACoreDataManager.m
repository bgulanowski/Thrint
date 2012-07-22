//
//  BACoreDataManager.m
//
//  Created by Brent Gulanowski on 09-10-22.
//  Copyright 2009 Bored Astronaut. All rights reserved.
//

#import "BACoreDataManager.h"


@interface BACoreDataManager ()

- (BOOL)openPersistentStore:(NSPersistentStoreCoordinator *)psc;
- (BOOL)moveAsideOldStore;

@property (nonatomic, strong) NSTimer *scheduledSaveTimer;

@end



@implementation BACoreDataManager

@synthesize model, coordinator, context, editingContext, storeURL, storeUnreadable, readOnly, saveDelay, scheduledSaveTimer;
@synthesize editCount;

#pragma mark - NSObject
- (void)dealloc {
    self.model = nil;
    self.coordinator = nil;
    self.context = nil;
    self.editingContext = nil;
    self.storeURL = nil;
    [super dealloc];
}

- (NSURL *)modelURL {
    
    Class class = [self class];
    NSString *path = nil;
    
    do {
        NSString *className = NSStringFromClass(class);
        
        path = [[NSBundle bundleForClass:class] pathForResource:className ofType:@"mom"];
        if(nil == path) path = [[NSBundle bundleForClass:class] pathForResource:className ofType:@"momd"];
        
        class = [class superclass];
    } while (class && !path);
    
    return [NSURL fileURLWithPath:path];
}

- (NSManagedObjectModel *)model {
	
	if(nil == model)
		model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
	
	return model;
}

- (NSPersistentStoreCoordinator *)coordinator {
	
	if(nil != coordinator)
		return coordinator;
	
	if(YES == storeUnreadable)
		return nil;
	
	NSPersistentStoreCoordinator *psc = nil;
	
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
	
    if( ! [self openPersistentStore:psc]) {
		if([self readOnly] || ![self moveAsideOldStore] || ![self openPersistentStore:psc]) {
			[self setStoreUnreadable:YES];
            [psc release];
			psc = nil;
		}
	}

	if(nil != psc) {
		[self willChangeValueForKey:@"coordinator"];
		coordinator = psc;	
		[self didChangeValueForKey:@"coordinator"];
	}
		
    return coordinator;	
}

- (NSManagedObjectContext *)context {
	
	if(nil == context && nil != [self coordinator]) {
		[self willChangeValueForKey:@"context"];
		context = [[NSManagedObjectContext alloc] init];	
		[context setPersistentStoreCoordinator:coordinator];
		[context setUndoManager:nil];
		[context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
		[self didChangeValueForKey:@"context"];
	}
	
	return context;
}

- (NSManagedObjectContext *)editingContext {
    dispatch_once(&editorToken, ^{
        
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editorSaved:) name:NSManagedObjectContextDidSaveNotification object:moc];
        moc.persistentStoreCoordinator = coordinator;
        self.editingContext = moc;
        [moc release];
    });
    return editingContext;
}

- (id)initWithStoreURL:(NSURL *)url {
	self = [super init];
	if(self) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[url path] stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
		[self setStoreURL:url];
        self.saveDelay = 5;
#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
#endif
	}
	return self;
}


#pragma mark - BACoreDataManager
- (BOOL)save {
	
    [scheduledSaveTimer invalidate];

	if([self storeUnreadable])
		return NO;
	
	if([self readOnly])
		return YES;
	
    BOOL success = YES;
	NSError *error = nil;
    
    NSAssert(context != nil, @"No managed object context!");
    NSAssert(editingContext != nil, @"No editing context!");
	
	@try {
#ifdef DEBUG
        if(editCount)
            NSLog(@"Not saving editing context; edits in progress");
#endif
        if(!editCount && !(success = [editingContext save:&error]))
            NSLog(@"Could not save editing context: %@", error);
        else if(!(success = [context save:&error]))
            NSLog(@"Could not save context: %@", error);
        if(!editCount)
            [editingContext reset];
	}
	@catch (NSException * e) {
		NSLog(@"Exception saving core data database: '%@'.", e);
		[self setStoreUnreadable:YES];
	}
    
#ifdef DEBUG
    NSLog(@"%@ saved", self);
#endif
    
	return success;
}

- (void)scheduleSave {
    [scheduledSaveTimer invalidate];
    self.scheduledSaveTimer = [NSTimer scheduledTimerWithTimeInterval:saveDelay
                                                               target:self
                                                             selector:@selector(save)
                                                             userInfo:nil
                                                              repeats:NO];
}

- (void)startEditing {
    editCount++;
}

- (void)endEditing {
    NSAssert(editCount > 0, @"Unbalanced call to endEditing");
    editCount--;
}

- (void)resetEditCount {
    if(editCount != 0) {
        NSLog(@"Resetting edit count; edit count was %u", editCount);
        editCount = 0;
    }
}

- (void)cancelEdits {
    [self endEditing];
    if(!editCount)
        [editingContext rollback];
}

- (BOOL)openPersistentStore:(NSPersistentStoreCoordinator *)psc {
	
	NSError *error = nil;
	
	if(nil == [psc addPersistentStoreWithType:NSSQLiteStoreType
								configuration:nil
										  URL:[self storeURL]
									  options:nil
										error:&error]) {
		NSLog(@"Unable to open persistent store '%@'; error: '%@'.", [[self storeURL] path], error);
		return NO;
	}
	
	return YES;
}

- (BOOL)moveAsideOldStore {
	
	BOOL success = YES;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *storePath = [[self storeURL] path];
	NSString *destPath = [NSString stringWithFormat:@"%@-old.%@", [storePath stringByDeletingPathExtension], [storePath pathExtension]];
	NSError *error = nil;
	
	NSLog(@"Attempting to move aside old persistent store and re-create...");
	
	if([fm fileExistsAtPath:destPath] && ! [fm removeItemAtPath:destPath error:&error]) {
		NSLog(@"...unable to delete existing old persistent store at path '%@'. Error: '%@'.", destPath, error);
		success = NO;
	}
	else if( ! [fm moveItemAtPath:storePath toPath:destPath error:&error]) {
		NSLog(@"...unable to move aside old store; please ensure that the folder '%@' exists and is readable by %@. Error: %@",
				   [storePath stringByDeletingLastPathComponent], [[[NSProcessInfo processInfo] environment] objectForKey:@"LOGNAME"], error);
		success = NO;
	}
	
	return success;
}

- (void)refreshObjects:(NSArray *)objects {
	if([objects count] < 1) {
		[[self context] reset];
	}
	else {
		[[self context] setStalenessInterval:1];
		NSEnumerator *iter = [objects objectEnumerator];
		id obj;
		while (obj = [iter nextObject]) {
			[[self context] refreshObject:obj mergeChanges:YES];
		}
		[[self context] setStalenessInterval:0];
	}	
}

- (void)refreshObjectsWithURIs:(NSArray *)objectURIs {
	
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[objectURIs count]];
	NSEnumerator *iter = [objectURIs objectEnumerator];
	NSString *uri;
	
	while(uri = [iter nextObject]) {
		
		NSManagedObjectID *objectID = [[self coordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:uri]];
		
		if(nil != objectID)
			[objects addObject:[[self context] objectWithID:objectID]];
		else
			NSLog(@"Unabled to find object with managedObjectID URI %@.%@", uri, nil == objectID ? @"(Object ID not found.)" : @"");
	}
	
	if([objects count])
		[self refreshObjects:objects];
}

- (void)deleteObject:(NSManagedObject *)object {
	
    NSManagedObjectContext *objectContext = [object managedObjectContext];

	@try {
		[objectContext deleteObject:object];
	}
	@catch (NSException * e) {
		NSLog(@"Error attempting to delete managed object. Rolling back context.");
		[objectContext rollback];
	}
	@finally {
		[self save];
	}
}


#pragma mark - Notification handlers
- (void)editorSaved:(NSNotification *)note {
    NSLog(@"Merging changes from editing context");
    [context mergeChangesFromContextDidSaveNotification:note];
}

#if TARGET_OS_IPHONE
- (void)appWillResignActive:(NSNotification *)note {
    [scheduledSaveTimer invalidate];
}
#endif

@end


@implementation UIApplication (BAAdditions)

- (BACoreDataManager *)modelManager {
    if([[self delegate] conformsToProtocol:@protocol(BAApplicationDelegateAdditions)])
        return [(id<BAApplicationDelegateAdditions>)[self delegate] modelManager];
    return nil;
}

@end