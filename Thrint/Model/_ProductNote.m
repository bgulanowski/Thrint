// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// This template requires Bored Astronaut Core Data Additions (BAAdditions)
// Make changes to ProductNote.m instead.

#import "_ProductNote.h"


@implementation NSManagedObjectContext (ProductNoteConveniences)

- (ProductNote *)findProductNoteWithID:(ProductNoteID *)objectID {
    return (ProductNote *)[self objectWithID:objectID];
}

- (ProductNote *)insertProductNote {
	return [NSEntityDescription insertNewObjectForEntityForName:@"ProductNote" inManagedObjectContext:self];
}

@end

@implementation ProductNoteID
@end

@implementation _ProductNote

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ProductNote" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ProductNote";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ProductNote" inManagedObjectContext:moc_];
}

- (ProductNoteID*)objectID {
	return (ProductNoteID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}


@dynamic details;

@dynamic title;


@dynamic product;


@end
