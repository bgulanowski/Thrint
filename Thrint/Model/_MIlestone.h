// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Milestone.h instead.

#import <CoreData/CoreData.h>


@class Milestone, MilestoneID;

@interface NSManagedObjectContext (MilestoneConveniences)

- (Milestone *)findMilestoneWithID:(MilestoneID *)objectID;
- (Milestone *)insertMilestone;

@end



@class Feature;

@interface MilestoneID : NSManagedObjectID {}
@end


@interface _Milestone : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MilestoneID*)objectID;

@property (nonatomic, retain) NSDate *dueDate;
//- (BOOL)validateDueDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString *version;
//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* features;
- (NSMutableSet*)featuresSet;

@property (nonatomic, readonly) NSArray *products;
@end


@interface _Milestone (CoreDataGeneratedAccessors)

- (void)addFeatures:(NSSet*)value_;
- (void)removeFeatures:(NSSet*)value_;
- (void)addFeaturesObject:(Feature*)value_;
- (void)removeFeaturesObject:(Feature*)value_;
@end


@interface _Milestone (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDueDate;
- (void)setPrimitiveDueDate:(NSDate*)value;

- (NSString*)primitiveVersion;
- (void)setPrimitiveVersion:(NSString*)value;


- (NSMutableSet*)primitiveFeatures;
- (void)setPrimitiveFeatures:(NSMutableSet*)value;
@end
