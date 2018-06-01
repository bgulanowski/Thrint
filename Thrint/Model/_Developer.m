// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Developer.m instead.

#import "_Developer.h"


@implementation NSManagedObjectContext (DeveloperConveniences)

- (Developer *)findDeveloperWithID:(DeveloperID *)objectID {
    return (Developer *)[self objectWithID:objectID];
}

- (Developer *)insertDeveloper {
	return (Developer *)[NSEntityDescription insertNewObjectForEntityForName:@"Developer" inManagedObjectContext:self];
}

@end

@implementation DeveloperID
@end

@implementation _Developer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Developer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Developer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Developer" inManagedObjectContext:moc_];
}

- (DeveloperID*)objectID {
	return (DeveloperID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"activeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"active"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}


@dynamic active;

- (BOOL)activeValue {
	NSNumber *result = [self active];
	return [result boolValue];
}

- (void)setActiveValue:(BOOL)value_ {
	[self setActive:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveActiveValue {
	NSNumber *result = [self primitiveActive];
	return [result boolValue];
}

- (void)setPrimitiveActiveValue:(BOOL)value_ {
	[self setPrimitiveActive:[NSNumber numberWithBool:value_]];
}

@dynamic joinDate;

@dynamic name;


@dynamic features;

- (NSMutableSet*)featuresSet {
	[self willAccessValueForKey:@"features"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"features"];
  
	[self didAccessValueForKey:@"features"];
	return result;
}

@dynamic roles;

- (NSMutableSet*)rolesSet {
	[self willAccessValueForKey:@"roles"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"roles"];
  
	[self didAccessValueForKey:@"roles"];
	return result;
}


@dynamic products;

@dynamic teams;

@end
