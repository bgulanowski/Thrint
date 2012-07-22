// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Team.h instead.

#import <CoreData/CoreData.h>


@class Team, TeamID;

@interface NSManagedObjectContext (TeamConveniences)

- (Team *)findTeamWithID:(TeamID *)objectID;
- (Team *)insertTeam;

@end



@class Product;
@class Role;

@interface TeamID : NSManagedObjectID {}
@end


@interface _Team : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TeamID*)objectID;

@property (nonatomic, retain) NSString *name;
//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* products;
- (NSMutableSet*)productsSet;

@property (nonatomic, retain) NSSet* roles;
- (NSMutableSet*)rolesSet;

@property (nonatomic, readonly) NSArray *developers;
@end


@interface _Team (CoreDataGeneratedAccessors)

- (void)addProducts:(NSSet*)value_;
- (void)removeProducts:(NSSet*)value_;
- (void)addProductsObject:(Product*)value_;
- (void)removeProductsObject:(Product*)value_;
- (void)addRoles:(NSSet*)value_;
- (void)removeRoles:(NSSet*)value_;
- (void)addRolesObject:(Role*)value_;
- (void)removeRolesObject:(Role*)value_;
@end


@interface _Team (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSMutableSet*)primitiveProducts;
- (void)setPrimitiveProducts:(NSMutableSet*)value;
- (NSMutableSet*)primitiveRoles;
- (void)setPrimitiveRoles:(NSMutableSet*)value;
@end
