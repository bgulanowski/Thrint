// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Product.h instead.

#import <CoreData/CoreData.h>


@class Product, ProductID;

@interface NSManagedObjectContext (ProductConveniences)

- (Product *)findProductWithID:(ProductID *)objectID;
- (Product *)insertProduct;

@end



@class Component;
@class ProductNote;
@class Team;

@interface ProductID : NSManagedObjectID {}
@end


@interface _Product : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProductID*)objectID;

@property (nonatomic, retain) NSString *code;
//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSDate *dueDate;
//- (BOOL)validateDueDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSData *imageData;
//- (BOOL)validateImageData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString *name;
//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString *other;
//- (BOOL)validateOther:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString *otherTitle;
//- (BOOL)validateOtherTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSDate *startDate;
//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet* components;
- (NSMutableSet*)componentsSet;

@property (nonatomic, retain) NSSet* notes;
- (NSMutableSet*)notesSet;

@property (nonatomic, retain) Team* team;
//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, readonly) NSArray *assets;
@property (nonatomic, readonly) NSArray *behaviours;
@property (nonatomic, readonly) NSArray *dependencies;
@property (nonatomic, readonly) NSArray *developers;
@property (nonatomic, readonly) NSArray *milestones;
@end


@interface _Product (CoreDataGeneratedAccessors)

- (void)addComponents:(NSSet*)value_;
- (void)removeComponents:(NSSet*)value_;
- (void)addComponentsObject:(Component*)value_;
- (void)removeComponentsObject:(Component*)value_;
- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(ProductNote*)value_;
- (void)removeNotesObject:(ProductNote*)value_;
@end


@interface _Product (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;

- (NSDate*)primitiveDueDate;
- (void)setPrimitiveDueDate:(NSDate*)value;

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveOther;
- (void)setPrimitiveOther:(NSString*)value;

- (NSString*)primitiveOtherTitle;
- (void)setPrimitiveOtherTitle:(NSString*)value;

- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;


- (NSMutableSet*)primitiveComponents;
- (void)setPrimitiveComponents:(NSMutableSet*)value;
- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;
- (Team*)primitiveTeam;
- (void)setPrimitiveTeam:(Team*)value;

@end
