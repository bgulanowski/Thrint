// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Milestone.m instead.

#import "_Milestone.h"


@implementation NSManagedObjectContext (MilestoneConveniences)

- (Milestone *)findMilestoneWithID:(MilestoneID *)objectID {
    return (Milestone *)[self objectWithID:objectID];
}

- (Milestone *)insertMilestone {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Milestone" inManagedObjectContext:self];
}

@end

@implementation MilestoneID
@end

@implementation _Milestone

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Milestone" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Milestone";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Milestone" inManagedObjectContext:moc_];
}

- (MilestoneID*)objectID {
	return (MilestoneID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}


@dynamic dueDate;

@dynamic version;


@dynamic features;

- (NSMutableSet*)featuresSet {
	[self willAccessValueForKey:@"features"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"features"];
  
	[self didAccessValueForKey:@"features"];
	return result;
}


@dynamic products;

@end
