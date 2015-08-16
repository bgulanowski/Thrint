//
//  THRPropertyList.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRPropertyList.h"

#import <objc/runtime.h>

@interface THRPropertyList ()
@property NSArray *properties;
@end

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

@end

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

@implementation NSObject (THRPropertyCreating)

- (THRProperty *)propertyForKey:(NSString *)key {
    return [THRProperty propertyWithName:key type:[self propertyTypeForKey:key] value:[self valueForKey:key]];
}

- (NSArray *)propertiesForKeys:(NSArray *)keys {
    NSMutableArray *properties = [NSMutableArray array];
    for (NSString *key in keys) {
        [properties addObject:[self propertyForKey:key]];
    }
    return properties;
}

- (NSArray *)propertiesForType:(THRPropertyType)propertyType {
    if (propertyType == THRPropertyTypeValue) {
        return self.properties;
    }
    else {
        return @[];
    }
}

- (NSArray *)properties {
    return [self propertiesForKeys:[self propertyKeys]];
}

+ (NSArray *)propertyKeys {
    
    NSMutableArray *keys = [NSMutableArray array];
    
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (unsigned int index=0; index<outCount; ++index) {
        [keys addObject:[NSString stringWithUTF8String:property_getName(properties[index])]];
    }
    free(properties);
    
    return keys;
}

- (NSDictionary *)propertiesByType {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (THRPropertyType type = THRPropertyTypeTitle; type<THRPropertyTypeCount; ++type) {
        dictionary[@(type)] = [self propertiesForType:type];
    }
    return dictionary;
}

+ (THRPropertyType)propertyTypeForKey:(NSString *)key {
    return THRPropertyTypeValue;
}

- (THRPropertyType)propertyTypeForKey:(NSString *)key {
    return [[self class] propertyTypeForKey:key];
}

- (NSArray *)propertyKeys {
    return [[self class] propertyKeys];
}

//- (NSArray *)valuesForKeys:(NSArray *)keys {
//    NSMutableArray *values = [NSMutableArray array];
//    for (NSString *key in keys) {
//        [values addObject:[self valueForKey:key]];
//    }
//    return values;
//}

@end
