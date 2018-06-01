// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Feature.m instead.

#import "_Feature.h"


@implementation NSManagedObjectContext (FeatureConveniences)

- (Feature *)findFeatureWithID:(FeatureID *)objectID {
    return (Feature *)[self objectWithID:objectID];
}

- (Feature *)insertFeature {
	return (Feature *)[NSEntityDescription insertNewObjectForEntityForName:@"Feature" inManagedObjectContext:self];
}

@end

@implementation FeatureID
@end

@implementation _Feature

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Feature" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Feature";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Feature" inManagedObjectContext:moc_];
}

- (FeatureID*)objectID {
	return (FeatureID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}


@dynamic details;

@dynamic name;


@dynamic component;

@dynamic milestone;

@dynamic owner;

@dynamic tests;

- (NSMutableSet*)testsSet {
	[self willAccessValueForKey:@"tests"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tests"];
  
	[self didAccessValueForKey:@"tests"];
	return result;
}


@end
