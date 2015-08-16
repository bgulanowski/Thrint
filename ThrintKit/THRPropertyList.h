//
//  THRPropertyList.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ThrintKit/ThrintKit.h>

typedef NS_ENUM(NSUInteger, THRPropertyType) {
    THRPropertyTypeTitle,
    THRPropertyTypeOption,
    THRPropertyTypeValue,
    THRPropertyTypeConnection,
    THRPropertyTypeCollection,
    THRPropertyTypeCount
};

@class THRProperty;

@interface THRPropertyList : NSObject<THRList>

@property (readonly) NSArray *properties;

- (instancetype)initWithObject:(id)object names:(NSArray *)names;
+ (instancetype)propertyListWithObject:(id)object names:(NSArray *)names;

@end

@interface THRProperty : NSObject

@property (readonly) NSString *name;
@property (readonly) THRPropertyType type;
@property (readonly) id value;

@end

// Specialized Properties for each type

@interface THRPropertyAttribute : THRProperty
@end

@interface THRPropertyRelationship : THRProperty
@end

// Specialized Attribute Properties

@interface THRPropertyBoolean : THRPropertyAttribute
@end

@interface THRPropertyInteger : THRPropertyAttribute
@end

@interface THRPropertyFloat : THRPropertyAttribute
@end

@interface THRPropertyOption : THRPropertyInteger
@end

@interface THRPropertyString : THRPropertyAttribute
@end

@interface THRPropertyTitle : THRPropertyString
@end

// Specialized Relationship Properties

@interface THRPropertyCollection : THRPropertyRelationship
@end



@interface NSObject (THRPropertyCreating)

// In the default implementation, all properties are values
@property (readonly) NSArray *properties;

- (THRProperty *)propertyForKey:(NSString *)key;
- (NSArray *)propertiesForKeys:(NSArray *)keys;
- (NSArray *)propertiesForType:(THRPropertyType)propertyType;
- (NSDictionary *)propertiesByType;

+ (THRPropertyType)propertyTypeForKey:(NSString *)key;
- (THRPropertyType)propertyTypeForKey:(NSString *)key;

+ (NSArray *)propertyKeys;
- (NSArray *)propertyKeys;

@end
