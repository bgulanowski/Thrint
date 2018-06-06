//
//  IntegerAttributeCell.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-06.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "TextAttributeCell.h"


@interface IntegerAttributeCell : TextAttributeCell

@property (nonatomic, weak) IBOutlet UIStepper *stepper;

@end
