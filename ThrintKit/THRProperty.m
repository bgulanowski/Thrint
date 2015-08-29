//
//  THRPropertyList.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <ThrintKit/THRProperty.h>
#import <ThrintKit/NSObject+THRTableDataProviding.h>

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

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:[self tableViewCellReuseIdentifier]] ?: [self newCell];
}

- (void)configureTableViewCell:(UITableViewCell *)tableViewCell {
    
}

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
