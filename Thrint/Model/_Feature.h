// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Feature.h instead.

#import <CoreData/CoreData.h>


@class Feature, FeatureID;

@interface NSManagedObjectContext (FeatureConveniences)

- (Feature *)findFeatureWithID:(FeatureID *)objectID;
- (Feature *)insertFeature;

@end



@class Component;
@class Milestone;
@class Developer;
@class Test;

@interface FeatureID : NSManagedObjectID {}
@end


@interface _Feature : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FeatureID*)objectID;

@property (nonatomic, retain) NSString *details;
//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString *name;
//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Component* component;
//- (BOOL)validateComponent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Milestone* milestone;
//- (BOOL)validateMilestone:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Developer* owner;
//- (BOOL)validateOwner:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* tests;
- (NSMutableSet*)testsSet;

@end


@interface _Feature (CoreDataGeneratedAccessors)

- (void)addTests:(NSSet*)value_;
- (void)removeTests:(NSSet*)value_;
- (void)addTestsObject:(Test*)value_;
- (void)removeTestsObject:(Test*)value_;
@end


@interface _Feature (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (Component*)primitiveComponent;
- (void)setPrimitiveComponent:(Component*)value;

- (Milestone*)primitiveMilestone;
- (void)setPrimitiveMilestone:(Milestone*)value;

- (Developer*)primitiveOwner;
- (void)setPrimitiveOwner:(Developer*)value;

- (NSMutableSet*)primitiveTests;
- (void)setPrimitiveTests:(NSMutableSet*)value;
@end
