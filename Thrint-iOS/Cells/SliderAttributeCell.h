//
//  SliderAttributeCell.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-02-06.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TextAttributeCell.h"

@interface SliderAttributeCell : TextAttributeCell

@property (nonatomic, weak) IBOutlet UISlider *slider;

@end
