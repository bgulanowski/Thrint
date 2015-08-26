//
//  THRPropertyList.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRPropertyList.h"

#import <BAFoundation/NSObject+BAIntrospection.h>

static THRPropertyType THRPropertyTypeForValueType(BAValueType valueType);

#pragma mark -

@interface THRPropertyList ()
@property NSArray *properties;
@end

#pragma mark -

@implementation THRPropertyList

@synthesize properties=_properties;

- (instancetype)initWithObject:(id)object names:(NSArray *)names {
    self = [super init];
    if (self) {
        _properties = [object propertiesForKeys:names];
    }
    return self;
}

+ (instancetype)propertyListWithObject:(id)object names:(NSArray *)names {
    return [[self alloc] initWithObject:object names:names];
}

#pragma mark - THRList

- (NSArray *)items {
    return self.properties;
}

- (NSUInteger)countOfItems {
    return self.properties.count;
}

- (id)objectInItemsAtIndex:(NSUInteger)index {
    return [self.properties objectAtIndex:index];
}

- (NSArray *)itemsAtIndexes:(NSIndexSet *)indexes {
    return [self.properties objectsAtIndexes:indexes];
}

@end

#pragma mark -

@implementation THRProperty

- (instancetype)initWithName:(NSString *)name type:(THRPropertyType)type value:(id)value {
    self = [super init];
    if (self) {
        _name = name;
        _type = type;
        _value = value;
    }
    return self;
}

+ (instancetype)propertyWithName:(NSString *)name type:(THRPropertyType)type value:(id)value {
    return [[self alloc] initWithName:name type:type value:value];
}

#pragma mark - THRItem

- (NSString *)listRepresentation {
    return [self.value description];
}

@end

#pragma mark -

@implementation NSObject (THRPropertyCreating)

- (THRProperty *)propertyForKey:(NSString *)key {
    return [THRProperty propertyWithName:key type:[self propertyTypeForKey:key] value:[self valueForKey:key]];
}

- (THRProperty *)propertyForValueInfo:(BAValueInfo *)valueInfo {
    return [self propertyForKey:valueInfo.name];
}

- (NSArray *)propertiesForKeys:(NSArray *)keys {
    NSMutableArray *properties = [NSMutableArray array];
    for (NSString *key in keys) {
        [properties addObject:[self propertyForKey:key]];
    }
    return properties;
}

- (NSArray *)propertiesForType:(THRPropertyType)propertyType {
    return [self.properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %td", propertyType]];
}

- (NSArray *)properties {
    NSMutableArray *properties = [NSMutableArray array];
    NSArray *propertyInfo = [[self class] propertyInfo];
    for (BAValueInfo *valueInfo in propertyInfo) {
        [properties addObject:[self propertyForValueInfo:valueInfo]];
    }
    return properties;
}

- (NSDictionary *)propertiesByType {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (THRPropertyType type = THRPropertyTypeUndefined+1; type<THRPropertyTypeCount; ++type) {
        dictionary[@(type)] = [self propertiesForType:type];
    }
    return dictionary;
}

+ (THRPropertyType)propertyTypeForValueInfo:(BAValueInfo *)valueInfo {
    return THRPropertyTypeForValueType(valueInfo.valueType);
}

+ (THRPropertyType)propertyTypeForKey:(NSString *)key {
    return THRPropertyTypeForValueType([self propertyInfoForName:key].valueType);
}

- (THRPropertyType)propertyTypeForKey:(NSString *)key {
    return [[self class] propertyTypeForKey:key];
}

+ (NSArray *)propertyKeys {
    return [[self propertyInfo] valueForKey:NSStringFromSelector(@selector(name))];
}

- (NSArray *)propertyKeys {
    return [[self class] propertyKeys];
}

+ (NSArray *)titleKeys {
    return @[@"name", @"title", @"_name", @"_title"];
}

//- (NSArray *)valuesForKeys:(NSArray *)keys {
//    NSMutableArray *values = [NSMutableArray array];
//    for (NSString *key in keys) {
//        [values addObject:[self valueForKey:key]];
//    }
//    return values;
//}

@end

THRPropertyType THRPropertyTypeForValueType(BAValueType valueType) {
    
    switch (valueType) {
        case BAValueTypeBool:
            return THRPropertyTypeOption;
            
        case BAValueTypeInteger:
        case BAValueTypeFloat:
        case BAValueTypeCString:
        case BAValueTypeString:
            return THRPropertyTypeValue;

        case BAValueTypeObject:
            return THRPropertyTypeConnection;

        case BAValueTypeCollection:
            return THRPropertyTypeCollection;
            
        case BAValueTypeCArray:
        case BAValueTypeClass:
        case BAValueTypeUndefined:
            break;
            
        default:
            break;
    }
    return THRPropertyTypeUndefined;
}
