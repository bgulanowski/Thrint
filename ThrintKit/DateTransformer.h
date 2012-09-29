//
//  DateTransformer.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-29.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTransformer : NSValueTransformer

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

@end
