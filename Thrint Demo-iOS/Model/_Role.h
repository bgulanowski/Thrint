// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Role.h instead.

#import <CoreData/CoreData.h>


@class Role, RoleID;

@interface NSManagedObjectContext (RoleConveniences)

- (Role *)findRoleWithID:(RoleID *)objectID;
- (Role *)insertRole;

@end



@class Developer;
@class Team;

@interface RoleID : NSManagedObjectID {}
@end


@interface _Role : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RoleID*)objectID;

@property (nonatomic, retain) NSString *name;
//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSNumber *unique;
@property BOOL uniqueValue;
- (BOOL)uniqueValue;
- (void)setUniqueValue:(BOOL)value_;
//- (BOOL)validateUnique:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* developers;
- (NSMutableSet*)developersSet;

@property (nonatomic, retain) Team* team;
//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@end


@interface _Role (CoreDataGeneratedAccessors)

- (void)addDevelopers:(NSSet*)value_;
- (void)removeDevelopers:(NSSet*)value_;
- (void)addDevelopersObject:(Developer*)value_;
- (void)removeDevelopersObject:(Developer*)value_;
@end


@interface _Role (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (NSNumber *)primitiveUnique;
- (void)setPrimitiveUnique:(NSNumber *)value;
- (BOOL)primitiveUniqueValue;
- (void)setPrimitiveUniqueValue:(BOOL)value_;


- (NSMutableSet*)primitiveDevelopers;
- (void)setPrimitiveDevelopers:(NSMutableSet*)value;
- (Team*)primitiveTeam;
- (void)setPrimitiveTeam:(Team*)value;

@end
