// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Test.h instead.

#import <CoreData/CoreData.h>


@class Test, TestID;

@interface NSManagedObjectContext (TestConveniences)

- (Test *)findTestWithID:(TestID *)objectID;
- (Test *)insertTest;

@end



@class Feature;

@interface TestID : NSManagedObjectID {}
@end


@interface _Test : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TestID*)objectID;

@property (nonatomic, retain) Feature* feature;
//- (BOOL)validateFeature:(id*)value_ error:(NSError**)error_;

@end


@interface _Test (CoreDataGeneratedAccessors)

@end


@interface _Test (CoreDataGeneratedPrimitiveAccessors)


- (Feature*)primitiveFeature;
- (void)setPrimitiveFeature:(Feature*)value;

@end
