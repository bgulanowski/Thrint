// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Library.h instead.

#import <CoreData/CoreData.h>


@class Library, LibraryID;

@interface NSManagedObjectContext (LibraryConveniences)

- (Library *)findLibraryWithID:(LibraryID *)objectID;
- (Library *)insertLibrary;

@end



@class Component;

@interface LibraryID : NSManagedObjectID {}
@end


@interface _Library : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LibraryID*)objectID;

@property (nonatomic, retain) NSString *name;
//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* dependents;
- (NSMutableSet*)dependentsSet;

@end


@interface _Library (CoreDataGeneratedAccessors)

- (void)addDependents:(NSSet*)value_;
- (void)removeDependents:(NSSet*)value_;
- (void)addDependentsObject:(Component*)value_;
- (void)removeDependentsObject:(Component*)value_;
@end


@interface _Library (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSMutableSet*)primitiveDependents;
- (void)setPrimitiveDependents:(NSMutableSet*)value;
@end
