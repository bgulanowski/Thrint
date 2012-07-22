// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to Test.m instead.

#import "_Test.h"


@implementation NSManagedObjectContext (TestConveniences)

- (Test *)findTestWithID:(TestID *)objectID {
    return (Test *)[self objectWithID:objectID];
}

- (Test *)insertTest {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self];
}

@end

@implementation TestID
@end

@implementation _Test

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Test";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Test" inManagedObjectContext:moc_];
}

- (TestID*)objectID {
	return (TestID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}



@dynamic feature;


@end
