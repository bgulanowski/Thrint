//
//  NSDecimalNumberTransformer.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-29.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "DecimalNumberTransformer.h"

@implementation DecimalNumberTransformer

+ (BOOL)allowsReverseTransformation { return YES; }

+ (Class)transformedValueClass { return [NSNumber class]; }

- (id)transformedValue:(NSString *)value { return [NSDecimalNumber decimalNumberWithString:value]; }

- (id)reverseTransformedValue:(NSDecimalNumber *)value { return [value stringValue]; }

@end
