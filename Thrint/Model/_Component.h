// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Component.h instead.

#import <CoreData/CoreData.h>


@class Component, ComponentID;

@interface NSManagedObjectContext (ComponentConveniences)

- (Component *)findComponentWithID:(ComponentID *)objectID;
- (Component *)insertComponent;

@end



@class Library;
@class Feature;
@class Product;

@interface ComponentID : NSManagedObjectID {}
@end


@interface _Component : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ComponentID*)objectID;

@property (nonatomic, retain) NSString *name;
//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* dependencies;
- (NSMutableSet*)dependenciesSet;

@property (nonatomic, retain) NSSet* features;
- (NSMutableSet*)featuresSet;

@property (nonatomic, retain) Product* product;
//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;

@property (nonatomic, readonly) NSArray *developers;
@end


@interface _Component (CoreDataGeneratedAccessors)

- (void)addDependencies:(NSSet*)value_;
- (void)removeDependencies:(NSSet*)value_;
- (void)addDependenciesObject:(Library*)value_;
- (void)removeDependenciesObject:(Library*)value_;
- (void)addFeatures:(NSSet*)value_;
- (void)removeFeatures:(NSSet*)value_;
- (void)addFeaturesObject:(Feature*)value_;
- (void)removeFeaturesObject:(Feature*)value_;
@end


@interface _Component (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSMutableSet*)primitiveDependencies;
- (void)setPrimitiveDependencies:(NSMutableSet*)value;
- (NSMutableSet*)primitiveFeatures;
- (void)setPrimitiveFeatures:(NSMutableSet*)value;
- (Product*)primitiveProduct;
- (void)setPrimitiveProduct:(Product*)value;

@end
