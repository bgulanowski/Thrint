//
//  ThrintKit.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-07.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <ThrintKit/ThrintKit.h>

static NSString * const ThrintKitVersion = @"1.1.0";

static NSString * const ThrintKitProductName = @"ThrintKit";

@implementation ThrintKit

+ (NSString *)versionString {
    return ThrintKitVersion;
}

+ (NSBundle *)resourceBundle {
    
    NSBundle *thrintKitBundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [thrintKitBundle pathForResource:ThrintKitProductName ofType:@"bundle"];    
    return [NSBundle bundleWithPath:resourcePath];
}

@end
