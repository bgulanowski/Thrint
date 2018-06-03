// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Team.m instead.

#import "_Team.h"


@implementation NSManagedObjectContext (TeamConveniences)

- (Team *)findTeamWithID:(TeamID *)objectID {
    return (Team *)[self objectWithID:objectID];
}

- (Team *)insertTeam {
	return (Team *)[NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self];
}

@end

@implementation TeamID
@end

@implementation _Team

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Team";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Team" inManagedObjectContext:moc_];
}

- (TeamID*)objectID {
	return (TeamID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}


@dynamic name;


@dynamic products;

- (NSMutableSet*)productsSet {
	[self willAccessValueForKey:@"products"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"products"];
  
	[self didAccessValueForKey:@"products"];
	return result;
}

@dynamic roles;

- (NSMutableSet*)rolesSet {
	[self willAccessValueForKey:@"roles"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"roles"];
  
	[self didAccessValueForKey:@"roles"];
	return result;
}


@dynamic developers;

@end
