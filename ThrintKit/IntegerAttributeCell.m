//
//  IntegerAttributeCell.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-06.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "IntegerAttributeCell.h"
#import <BAFoundation/NSManagedObject+BAAdditions.h>


@implementation IntegerAttributeCell

@synthesize stepper=_stepper;

- (void)awakeFromNib {
    [_stepper addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    [super awakeFromNib];
}

- (id)objectValue {
    return [NSNumber numberWithDouble:_stepper.value];
}

- (IBAction)update:(id)sender {
    if(sender == self.textField)
        _stepper.value = [self.textField.text doubleValue];
    else
        self.textField.text = [NSString stringWithFormat:@"%d", (int)_stepper.value];
    [super update:sender];
}

@end
