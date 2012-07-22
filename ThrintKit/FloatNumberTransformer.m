//
//  NSFloatNumberTransformer.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-29.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "FloatNumberTransformer.h"

@implementation FloatNumberTransformer

+ (BOOL)allowsReverseTransformation { return YES; }

+ (Class)transformedValueClass { return [NSNumber class]; }

- (id)transformedValue:(NSString *)value { return [NSNumber numberWithFloat:[value floatValue]]; }

- (id)reverseTransformedValue:(NSNumber *)value { return [value stringValue]; }

@end
