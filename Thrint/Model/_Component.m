// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Component.m instead.

#import "_Component.h"


@implementation NSManagedObjectContext (ComponentConveniences)

- (Component *)findComponentWithID:(ComponentID *)objectID {
    return (Component *)[self objectWithID:objectID];
}

- (Component *)insertComponent {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:self];
}

@end

@implementation ComponentID
@end

@implementation _Component

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Component";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Component" inManagedObjectContext:moc_];
}

- (ComponentID*)objectID {
	return (ComponentID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}


@dynamic name;


@dynamic dependencies;

- (NSMutableSet*)dependenciesSet {
	[self willAccessValueForKey:@"dependencies"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"dependencies"];
  
	[self didAccessValueForKey:@"dependencies"];
	return result;
}

@dynamic features;

- (NSMutableSet*)featuresSet {
	[self willAccessValueForKey:@"features"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"features"];
  
	[self didAccessValueForKey:@"features"];
	return result;
}

@dynamic product;


@dynamic developers;

@end
