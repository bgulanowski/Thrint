//
//  FloatAttributeCell.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-06.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "FloatAttributeCell.h"
#import "NSManagedObject+BAAdditions.h"


@implementation FloatAttributeCell

@synthesize slider=_slider;

- (void)awakeFromNib {
    [_slider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureWithValue:(id)value attribute:(NSAttributeDescription *)attribute {
    [super configureWithValue:value attribute:attribute];
     _slider.value = [value floatValue];
    
    // This is kind of weak since we can't guarantee these are available
    // We should fall back to defaults if any are set
    // We can also adjust the minimums and maximums dynamically based on user text input
    id minimum = [[attribute userInfo] valueForKey:@"minimum"];
    id maximum = [[attribute userInfo] valueForKey:@"maximum"];
    
    if(minimum) _slider.minimumValue = [minimum floatValue];
    if(maximum) _slider.maximumValue = [maximum floatValue];
}

- (id)objectValue {
    return [NSNumber numberWithFloat:_slider.value];
}

- (void)update:(id)sender {
    if(sender == self.textField)
        _slider.value = [self.textField.text floatValue];
    else
        self.textField.text = [NSString stringWithFormat:@"%.2f", _slider.value];
    [super update:sender];
}

@end
