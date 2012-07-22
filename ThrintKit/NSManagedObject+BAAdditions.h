//
//  NSManagedObject+BAAdditions.h
//  Bored Astronaut Additions
//
//  Created by Brent Gulanowski on 24/02/08.
//  Copyright 2008 Bored Astronaut. All rights reserved.
//

#import <CoreData/CoreData.h>


#define RELATIONSHIP_PROPERTY_TYPE ((NSAttributeType)8000)


extern NSString *kNuIntegerTransformerName;
//extern NSString *kNuDecimalTransformerName;
extern NSString *kNuFloatTransformerName;
extern NSString *kNuDateTransformerName;


@interface NSManagedObject (BAAdditions)

- (id)valueForDataKey:(NSString *)aKey;
- (void)setValue:(id)anObj forDataKey:(NSString *)aKey;

- (int)intForKey:(NSString *)aKey;
- (void)setInt:(int)anInt forKey:(NSString *)aKey;

+ (NSString *)entityName; // returns nil; subclasses should override
+ (NSEntityDescription *)entity;
- (NSArray *)attributeNames;
- (NSArray *)relationshipNames;

- (NSAttributeDescription *)attributeForName:(NSString *)name;
- (NSAttributeDescription *)attributeForKeyPath:(NSString *)keyPath;
- (NSRelationshipDescription *)relationshipForName:(NSString *)name;

// Subclasses should override for performance
- (NSAttributeType)attributeTypeForProperty:(NSString **)ioName owner:(NSManagedObject **)oOwner;
- (NSAttributeType)attributeTypeForProperty:(NSString *)propertyName;

+ (NSString *)stringForValue:(id)value attributeType:(NSAttributeType)type;
+ (id)transformedValueForString:(NSString *)value attributeType:(NSAttributeType)type;

- (NSString *)stringValueForAttribute:(NSString *)attrName;
- (void)setStringValue:(NSString *)value forAttribute:(NSString *)attribute;

- (NSString *)stringValueForProperty:(NSString *)propertyName;
- (void)setStringValue:(NSString *)value forProperty:(NSString *)propertyName;

- (NSArray *)sortDescriptorsForRelationship:(NSString *)relName;
- (id)objectInRelationship:(NSString *)relName atIndex:(NSUInteger)index;

- (NSManagedObject *)insertNewObjectForRelationship:(NSString *)relName;
 // relies on -objectInRelationship:atIndex:
- (void)removeObjectFromRelationship:(NSString *)relName atIndex:(NSUInteger)index;

- (NSString *)objectIDString;
- (NSString *)objectIDAsFileName;
- (NSString *)stringRepresentation;
- (NSString *)listString;

+ (NSString *)defaultSortKey;
+ (BOOL)defaultSortAscending;
+ (NSArray *)defaultSortDescriptors;

+ (NSManagedObject *)insertObject;

@end
