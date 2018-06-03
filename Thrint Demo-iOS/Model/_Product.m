// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Product.m instead.

#import "_Product.h"


@implementation NSManagedObjectContext (ProductConveniences)

- (Product *)findProductWithID:(ProductID *)objectID {
    return (Product *)[self objectWithID:objectID];
}

- (Product *)insertProduct {
	return (Product *)[NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self];
}

@end

@implementation ProductID
@end

@implementation _Product

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Product";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Product" inManagedObjectContext:moc_];
}

- (ProductID*)objectID {
	return (ProductID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}


@dynamic code;

@dynamic dueDate;

@dynamic imageData;

@dynamic name;

@dynamic other;

@dynamic otherTitle;

@dynamic startDate;


@dynamic components;

- (NSMutableSet*)componentsSet {
	[self willAccessValueForKey:@"components"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"components"];
  
	[self didAccessValueForKey:@"components"];
	return result;
}

@dynamic notes;

- (NSMutableSet*)notesSet {
	[self willAccessValueForKey:@"notes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"notes"];
  
	[self didAccessValueForKey:@"notes"];
	return result;
}

@dynamic team;


@dynamic assets;

@dynamic behaviours;

@dynamic dependencies;

@dynamic developers;

@dynamic milestones;

@end
