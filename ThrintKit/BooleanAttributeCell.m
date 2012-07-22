//
//  BooleanAttributeCell.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-06.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "BooleanAttributeCell.h"
#import "NSManagedObject+BAAdditions.h"


@implementation BooleanAttributeCell

@synthesize flagSwitch=_switch;

- (void)awakeFromNib {
    [_switch addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
}

- (void)configure {
    [super configure];
    [_switch setOn:[[self.representedObject valueForKeyPath:self.propertyName] boolValue]];
}

- (id)objectValue {
    return [NSNumber numberWithBool:_switch.on];
}

@end
