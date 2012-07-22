// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Library.m instead.

#import "_Library.h"


@implementation NSManagedObjectContext (LibraryConveniences)

- (Library *)findLibraryWithID:(LibraryID *)objectID {
    return (Library *)[self objectWithID:objectID];
}

- (Library *)insertLibrary {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Library" inManagedObjectContext:self];
}

@end

@implementation LibraryID
@end

@implementation _Library

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Library" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Library";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Library" inManagedObjectContext:moc_];
}

- (LibraryID*)objectID {
	return (LibraryID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}


@dynamic name;


@dynamic dependents;

- (NSMutableSet*)dependentsSet {
	[self willAccessValueForKey:@"dependents"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"dependents"];
  
	[self didAccessValueForKey:@"dependents"];
	return result;
}


@end
