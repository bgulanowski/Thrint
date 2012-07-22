//
//  SliderAttributeCell.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-06.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "SliderAttributeCell.h"
#import "NSManagedObject+BAAdditions.h"


@implementation SliderAttributeCell

@synthesize slider=_slider;

- (void)awakeFromNib {
    [_slider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
}

- (void)configure {
    [super configure];
    
    if(self.maximum > self.minimum) {
        _slider.minimumValue = self.minimum;
        _slider.maximumValue = self.maximum;
    }
    
    _slider.value = [[self.representedObject valueForKeyPath:self.propertyName] floatValue];
}

- (id)objectValue {
    if(NSFloatAttributeType == self.attributeType)
        return [NSNumber numberWithFloat:_slider.value];
    else
        return [NSNumber numberWithInteger:_slider.value];
}

- (void)update:(id)sender {
    if(sender == self.textField)
        _slider.value = [self.textField.text floatValue];
    else {
        if(NSFloatAttributeType == self.attributeType)
            self.textField.text = [NSString stringWithFormat:@"%.3f", _slider.value];
        else
            self.textField.text = [NSString stringWithFormat:@"%d", (NSInteger) _slider.value];
    }
    [super update:sender];
}

@end
