//
//  ObjectAttributeCell.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-28.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface TextAttributeCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, assign) IBOutlet UITextField *textField;

@property (nonatomic, weak) NSManagedObject *representedObject;
@property (nonatomic, copy) NSString *propertyName;
@property (nonatomic, copy) NSString *suffix;
@property (nonatomic, strong) id enumerations; // either an array for 0->n-1 enum names, or a dictionary n->name

@property (nonatomic) NSAttributeType attributeType;

@property (nonatomic) NSInteger enumerationIndex;
@property (nonatomic) CGFloat maximum;
@property (nonatomic) CGFloat minimum;
@property (nonatomic) BOOL liveEditing;

- (NSString *)textValue;
- (void)configure;
- (id)objectValue;

- (IBAction)update:(id)sender;

+ (TextAttributeCell *)cellFromNib;
+ (TextAttributeCell *)cellForEnumerations:(id)enumerations;
+ (TextAttributeCell *)cellWithObject:(NSManagedObject *)object property:(NSString *)propertyName;

@end
