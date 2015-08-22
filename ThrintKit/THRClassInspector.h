//
//  THRClassInspector.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-17.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THRClassInspector : NSObject

@property (assign, readonly) Class targetClass;

@property (strong, readonly) NSArray *ancestors;
@property (strong, readonly) NSArray *subclasses;
@property (strong, readonly) NSArray *ivars;
@property (strong, readonly) NSArray *properties;
@property (strong, readonly) NSArray *methods;

- (instancetype)initWithTargetClass:(Class)targetClass;
+ (instancetype)inspectorWithTargetClass:(Class)targetClass;

@end

@interface NSObject (THRIntrospecting)

+ (THRClassInspector *)classInspector;

@end
