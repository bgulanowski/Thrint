//
//  NSManagedObject+BAAdditions.m
//  Bored Astronaut Additions
//
//  Created by Brent Gulanowski on 24/02/08.
//  Copyright 2008 Bored Astronaut. All rights reserved.
//

#import "NSManagedObject+BAAdditions.h"
#import "NSManagedObjectContext+BAAdditions.h"

#import "IntegerNumberTransformer.h"
#import "FloatNumberTransformer.h"
#import "DateTransformer.h"


NSString *kNuIntegerTransformerName = @"NuIntegerTransformer";
//NSString *kNuDecimalTransformerName = @"NuDecimalTransformer";
NSString *kNuFloatTransformerName = @"NuFloatTransformer";
NSString *kNuDateTransformerName = @"NuDateTransformer";


@implementation NSManagedObject (BAAdditions)

Class numberClass;

+ (void)load {
	numberClass = [NSNumber class];
    NSValueTransformer *transformer = [[IntegerNumberTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:kNuIntegerTransformerName];
    [transformer release];
//    [NSValueTransformer setValueTransformer:[[DecimalNumberTransformer alloc] init] forName:kNuDecimalTransformerName];
    transformer = [[FloatNumberTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:kNuFloatTransformerName];
    [transformer release];
    transformer = [[DateTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:kNuDateTransformerName];
    [transformer release];
}

- (id)valueForDataKey:(NSString *)aKey {
	id dataObject = [self valueForKey:aKey];
	if(nil != dataObject)
		return [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
	return nil;
}

- (void)setValue:(id)anObj forDataKey:(NSString *)aKey {
	[self setValue:[NSKeyedArchiver archivedDataWithRootObject:anObj] forKey:aKey];
}

- (int)intForKey:(NSString *)aKey {
	id number = [self valueForKey:aKey];
	if(NO == [number isKindOfClass:numberClass])
		[NSException raise:NSInternalInconsistencyException format:@""];
	return [number intValue];
}

- (void)setInt:(int)anInt forKey:(NSString *)aKey {
	if([self intForKey:aKey] != anInt)
		[self setValue:[NSNumber numberWithInt:anInt] forKey:aKey];
}

+ (NSString *)entityName {
	return NSStringFromClass(self);
}

+ (NSEntityDescription *)entity {
	return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:BAActiveContext];
}

- (NSArray *)attributeNames {
    return [[[self entity] attributesByName] allKeys];
}

- (NSArray *)relationshipNames {
    return [[[self entity] relationshipsByName] allKeys];
}

- (NSAttributeDescription *)attributeForName:(NSString *)name {
    return [[[self entity] attributesByName] objectForKey:name];
}

- (NSAttributeDescription *)attributeForKeyPath:(NSString *)keyPath {
    
    NSAttributeDescription *attribute = nil;
    NSArray *comps = [keyPath componentsSeparatedByString:@"."];
    NSEntityDescription *entity = [self entity];
    
    for(NSString *key in comps) {
        
        NSRelationshipDescription *relation = [[entity relationshipsByName] objectForKey:key];
        
        if(relation)
            entity = [relation destinationEntity];
        else
            attribute = [[entity attributesByName] valueForKey:key];
    }
    
    return attribute;
}

- (NSRelationshipDescription *)relationshipForName:(NSString *)name {
    return [[[self entity] relationshipsByName] objectForKey:name];
}

- (NSAttributeType)attributeTypeForProperty:(NSString **)ioName owner:(NSManagedObject **)oOwner {
    
    NSString *propertyName = *ioName;
    NSArray *components = [propertyName componentsSeparatedByString:@"."];
    NSManagedObject *destination = self;
    
    if([components count] > 1) {
        
        NSString *destinationKeyPath = [[components subarrayWithRange:NSMakeRange(0, [components count]-1)] componentsJoinedByString:@"."];
        
        *ioName = propertyName = [components lastObject];
        destination = [self valueForKeyPath:destinationKeyPath];
    }
    
    if(oOwner) *oOwner = destination;
    
    NSAttributeDescription *attribute = [destination attributeForName:propertyName];
    
    if(attribute)
        return [attribute attributeType];
    
    NSRelationshipDescription *relation = [destination relationshipForName:propertyName];
    
    if(relation)
        return RELATIONSHIP_PROPERTY_TYPE;
    
    return NSUndefinedAttributeType;
}

- (NSAttributeType)attributeTypeForProperty:(NSString *)propertyName {
    return [self attributeTypeForProperty:&propertyName owner:NULL];
}

+ (NSValueTransformer *)valueTransformerForAttributeType:(NSAttributeType)type {

    NSString *transformerName = nil;
    
    switch (type) {
            
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
        case NSBooleanAttributeType:
            transformerName = kNuIntegerTransformerName;
            break;

//        case NSDecimalAttributeType:
//            transformerName = kNuDecimalTransformerName;
//            break;
            
        case NSFloatAttributeType:
            transformerName = kNuFloatTransformerName;
            break;
            
        case NSStringAttributeType:
            break;
            
        case NSDateAttributeType:
            transformerName = kNuDateTransformerName;
            break;
            
        case NSUndefinedAttributeType:
        case NSBinaryDataAttributeType:
        default:
            return nil;
            break;
    }
    
    return [NSValueTransformer valueTransformerForName:transformerName];
}

+ (NSString *)stringForValue:(id)value attributeType:(NSAttributeType)type {
    
    if(RELATIONSHIP_PROPERTY_TYPE == type) {
        return [value stringRepresentation];
    }
    
    NSValueTransformer *transformer = [self valueTransformerForAttributeType:type];
    if(transformer)
        return [transformer reverseTransformedValue:value];
    else if(value)
        return [NSString stringWithFormat:@"%@", value];
    else
        return @"";
}

+ (id)transformedValueForString:(NSString *)value attributeType:(NSAttributeType)type {
    if(RELATIONSHIP_PROPERTY_TYPE == type) {
        // TODO: can we work out the object with just its description? We would need the entity
        return nil;
    }
    NSValueTransformer *transformer = [self valueTransformerForAttributeType:type];
    if(transformer) return [transformer transformedValue:value];
    if(NSStringAttributeType == type)
        return value;
    return nil;
}

- (NSString *)stringValueForAttribute:(NSString *)attrName {
    NSAttributeDescription *attribute = [[[self entity] attributesByName] objectForKey:attrName];
    return [[self class] stringForValue:[self valueForKey:attrName] attributeType:[attribute attributeType]];
}

- (void)setStringValue:(NSString *)value forAttribute:(NSString *)attrName {
    
    NSAttributeDescription *attribute = [[[self entity] attributesByName] objectForKey:attrName];
    id newValue = [[self class] transformedValueForString:value attributeType:[attribute attributeType]];
    
    [self setValue:newValue forKey:attrName];
}

- (NSString *)stringValueForProperty:(NSString *)propertyName {
    
    id value = [self valueForKeyPath:propertyName];
    
    return [[self class] stringForValue:value attributeType:[self attributeTypeForProperty:&propertyName owner:NULL]];
}

- (void)setStringValue:(NSString *)value forProperty:(NSString *)propertyName {
    
    NSManagedObject *owner = nil;
    NSString *ownerProp = propertyName;
    NSAttributeType type = [self attributeTypeForProperty:&ownerProp owner:&owner];
    
    if(RELATIONSHIP_PROPERTY_TYPE == type) {
        // TODO: lookup table from string description of object to actual object
        NSManagedObject *objectProperty = nil;
        [owner setValue:objectProperty forKey:ownerProp];
    }
    else
        [owner setStringValue:value forAttribute:ownerProp];
}

- (NSArray *)sortDescriptorsForRelationship:(NSString *)relName {
    static dispatch_once_t onceToken;
    static NSArray *sorts;
    dispatch_once(&onceToken, ^{
        sorts = [[NSArray alloc] initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"objectIDString" ascending:YES], nil];
    });
    return sorts;
}

- (id)objectInRelationship:(NSString *)relName atIndex:(NSUInteger)index {

    id relation = [self valueForKey:relName];
    
    if(![relation respondsToSelector:@selector(count)]) return relation;

    return [[relation sortedArrayUsingDescriptors:[self sortDescriptorsForRelationship:relName]] objectAtIndex:index];
}

- (NSManagedObject *)insertNewObjectForRelationship:(NSString *)relName {

    NSRelationshipDescription *relationship = [[[self entity] relationshipsByName] objectForKey:relName];
    
    NSEntityDescription *relatedEntity = [relationship destinationEntity];
    NSManagedObject *relatedObject = [NSClassFromString([relatedEntity managedObjectClassName]) insertObject];

    if([relationship isToMany])
        [[self mutableSetValueForKey:relName] addObject:relatedObject];
    else
        [self setValue:relatedObject forKey:relName];

    return relatedObject;
}

- (void)removeObjectFromRelationship:(NSString *)relName atIndex:(NSUInteger)index {
    [[self valueForKey:relName] removeObject:[self objectInRelationship:relName atIndex:index]];
}

- (NSString *)objectIDString {
	return [[[self objectID] URIRepresentation] absoluteString];
}

- (NSString *)objectIDAsFileName {
    NSURL *uri = [[self objectID] URIRepresentation];
    NSString *idString = [uri host] ? [[uri host] stringByAppendingPathComponent:[uri path]] : [uri path];
    return [idString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

- (NSString *)stringRepresentation {
    return [self description];
}

- (NSString *)listString {
    return [self description];
}

+ (NSString *)defaultSortKey {
    return nil;
}

+ (BOOL)defaultSortAscending {
    return YES;
}

+ (NSArray *)defaultSortDescriptors {
    
    NSString *key = [self defaultSortKey];
    
    if(!key) return nil;
    
    return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:[self defaultSortAscending]]];
}

+ (NSManagedObject *)insertObject {
	return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:BAActiveContext];
}

@end
