//
//  THRClassInspector.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-17.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRClassInspector.h"

#import <BAFoundation/NSObject+BAIntrospection.h>
#import <MAObjcRuntime_iOS/RTIvar.h>
#import <MAObjcRuntime_iOS/RTProperty.h>
#import <MAObjcRuntime_iOS/RTMethod.h>
#import <MAObjcRuntime_iOS/MARTNSObject.h>

#define SelectorString(_selector) NSStringFromSelector( @selector(_selector) )

@interface THRClassInspector ()

@property (readwrite) dispatch_queue_t queue;

@end

@implementation THRClassInspector

@synthesize targetClass=_targetClass;
@synthesize ancestors=_ancestors;
@synthesize subclasses=_subclasses;
@synthesize ivars=_ivars;
@synthesize properties=_properties;
@synthesize methods=_methods;

- (instancetype)initWithTargetClass:(Class)targetClass {
    self = [super init];
    if (self) {
        _targetClass = targetClass;
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"ClassInspector<%p>:%@", self, [_targetClass publicClassName]] UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (instancetype)inspectorWithTargetClass:(Class)targetClass {
    return [[self alloc] initWithTargetClass:targetClass];
}

#pragma mark - Accessors

typedef id (^THRGetterBlock)(void);

#define LAZY_ASSIGNMENT(ivarName, getterBlock) do { \
    if (!ivarName) { \
        dispatch_sync(_queue, ^{ \
            if (!ivarName) { \
                ivarName = getterBlock(); \
            } \
        }); \
    } \
} while(0)


- (NSArray *)ancestors {
    LAZY_ASSIGNMENT(_ancestors, ^{ return [_targetClass ancestors]; });
    return _ancestors;
}

- (NSArray *)subclasses {
    LAZY_ASSIGNMENT(_subclasses, ^{ return [_targetClass rt_subclasses]; });
    return _subclasses;
}

- (NSArray *)ivars {
    LAZY_ASSIGNMENT(_ivars, ^{ return [_targetClass rt_ivars]; });
    return _ivars;
}

- (NSArray *)properties {
    LAZY_ASSIGNMENT(_properties, ^{ return [_targetClass rt_properties]; });
    return _properties;
}

- (NSArray *)methods {
    LAZY_ASSIGNMENT(_methods, ^{ return [_targetClass rt_methods]; } );
    return _methods;
}

#pragma mark - NSObject

- (NSString *)debugDescription {
    return [[[[self dictionaryWithValuesForKeys:@[
                                                  SelectorString(ancestors),
                                                  SelectorString(subclasses),
                                                  SelectorString(ivars),
                                                  SelectorString(properties),
                                                  SelectorString(methods)
                                                  ]] allValues] valueForKey:SelectorString(debugDescription)] componentsJoinedByString:@"\n"];
}

@end

@implementation NSObject (THRIntrospecting)

+ (THRClassInspector *)classInspector {
    return [THRClassInspector inspectorWithTargetClass:self];
}

@end
