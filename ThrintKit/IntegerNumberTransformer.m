//
//  NSIntegerNumberTransformer.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-29.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "IntegerNumberTransformer.h"

@implementation IntegerNumberTransformer

+ (BOOL)allowsReverseTransformation { return YES; }

+ (Class)transformedValueClass { return [NSNumber class]; }

- (NSNumber *)transformedValue:(NSString *)value { return [NSNumber numberWithLongLong:[value longLongValue]]; }

- (id)reverseTransformedValue:(id)value { return [value stringValue]; }

@end
