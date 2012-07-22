//
//  DateTransformer.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-29.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "DateTransformer.h"

@implementation DateTransformer

static NSDateFormatter *formatter;

+ (void)initialize {
    @autoreleasepool {
        if(self == [DateTransformer class]) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterLongStyle];
            [formatter setLenient:YES];
        }
    }
}

+ (BOOL)allowsReverseTransformation { return YES; }

+ (Class)transformedValueClass { return [NSDate class]; }

- (NSDate *)transformedValue:(NSString *)value { return [formatter dateFromString:value]; }

- (id)reverseTransformedValue:(id)value { return [formatter stringFromDate:value]; }

@end
