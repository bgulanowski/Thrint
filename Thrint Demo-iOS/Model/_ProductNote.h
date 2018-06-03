// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ProductNote.h instead.

#import <CoreData/CoreData.h>


@class ProductNote, ProductNoteID;

@interface NSManagedObjectContext (ProductNoteConveniences)

- (ProductNote *)findProductNoteWithID:(ProductNoteID *)objectID;
- (ProductNote *)insertProductNote;

@end



@class Product;

@interface ProductNoteID : NSManagedObjectID {}
@end


@interface _ProductNote : NSManagedObject {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProductNoteID*)objectID;

@property (nonatomic, retain) NSString *details;
//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString *title;
//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Product* product;
//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;

@end


@interface _ProductNote (CoreDataGeneratedAccessors)

@end


@interface _ProductNote (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveDetails;
- (void)setPrimitiveDetails:(NSString *)value;

- (NSString *)primitiveTitle;
- (void)setPrimitiveTitle:(NSString *)value;


- (Product*)primitiveProduct;
- (void)setPrimitiveProduct:(Product*)value;

@end
