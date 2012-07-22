// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Role.m instead.

#import "_Role.h"


@implementation NSManagedObjectContext (RoleConveniences)

- (Role *)findRoleWithID:(RoleID *)objectID {
    return (Role *)[self objectWithID:objectID];
}

- (Role *)insertRole {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Role" inManagedObjectContext:self];
}

@end

@implementation RoleID
@end

@implementation _Role

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Role" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Role";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Role" inManagedObjectContext:moc_];
}

- (RoleID*)objectID {
	return (RoleID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"uniqueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"unique"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}


@dynamic name;

@dynamic unique;

- (BOOL)uniqueValue {
	NSNumber *result = [self unique];
	return [result boolValue];
}

- (void)setUniqueValue:(BOOL)value_ {
	[self setUnique:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveUniqueValue {
	NSNumber *result = [self primitiveUnique];
	return [result boolValue];
}

- (void)setPrimitiveUniqueValue:(BOOL)value_ {
	[self setPrimitiveUnique:[NSNumber numberWithBool:value_]];
}


@dynamic developers;

- (NSMutableSet*)developersSet {
	[self willAccessValueForKey:@"developers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"developers"];
  
	[self didAccessValueForKey:@"developers"];
	return result;
}

@dynamic team;


@end
