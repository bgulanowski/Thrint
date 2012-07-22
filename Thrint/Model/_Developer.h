// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Developer.h instead.

#import <CoreData/CoreData.h>


@class Developer, DeveloperID;

@interface NSManagedObjectContext (DeveloperConveniences)

- (Developer *)findDeveloperWithID:(DeveloperID *)objectID;
- (Developer *)insertDeveloper;

@end



@class Feature;
@class Role;

@interface DeveloperID : NSManagedObjectID {}
@end


@interface _Developer : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DeveloperID*)objectID;

@property (nonatomic, retain) NSNumber *active;
@property BOOL activeValue;
- (BOOL)activeValue;
- (void)setActiveValue:(BOOL)value_;
//- (BOOL)validateActive:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSDate *joinDate;
//- (BOOL)validateJoinDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString *name;
//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* features;
- (NSMutableSet*)featuresSet;

@property (nonatomic, retain) NSSet* roles;
- (NSMutableSet*)rolesSet;

@property (nonatomic, readonly) NSArray *products;
@property (nonatomic, readonly) NSArray *teams;
@end


@interface _Developer (CoreDataGeneratedAccessors)

- (void)addFeatures:(NSSet*)value_;
- (void)removeFeatures:(NSSet*)value_;
- (void)addFeaturesObject:(Feature*)value_;
- (void)removeFeaturesObject:(Feature*)value_;
- (void)addRoles:(NSSet*)value_;
- (void)removeRoles:(NSSet*)value_;
- (void)addRolesObject:(Role*)value_;
- (void)removeRolesObject:(Role*)value_;
@end


@interface _Developer (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveActive;
- (void)setPrimitiveActive:(NSNumber*)value;
- (BOOL)primitiveActiveValue;
- (void)setPrimitiveActiveValue:(BOOL)value_;

- (NSDate*)primitiveJoinDate;
- (void)setPrimitiveJoinDate:(NSDate*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSMutableSet*)primitiveFeatures;
- (void)setPrimitiveFeatures:(NSMutableSet*)value;
- (NSMutableSet*)primitiveRoles;
- (void)setPrimitiveRoles:(NSMutableSet*)value;
@end
