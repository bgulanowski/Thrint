//
//  ObjectAttributeCell.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-28.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "TextAttributeCell.h"

#import <ThrintKit/ThrintKit.h>
#import "NSManagedObject+ViewAdditions.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>


@interface UINib (NibLocating)
+ (instancetype)nibForName:(NSString *)name;
@end

@interface NSBundle (NibLocating)
+ (instancetype)bundleForNibName:(NSString *)name;
@end

@implementation TextAttributeCell

@synthesize label=_label, textField=_textField;
@synthesize enumerations=_enumerations, propertyName=_propertyName, suffix=_suffix;
@synthesize representedObject=_representedObject;
@synthesize enumerationIndex=_enumerationIndex;
@synthesize attributeType=_attributeType, liveEditing=_liveEditing;
@synthesize maximum=_maximum, minimum=_minimum;

#pragma mark - Private
- (void)updateAttributeType {
    if(_representedObject && _propertyName)
        _attributeType = [_representedObject attributeTypeForProperty:_propertyName];
}

#pragma mark - Accessors
- (void)setPropertyName:(NSString *)propertyName {
    if(![propertyName isEqualToString:_propertyName]) {
        _propertyName = [propertyName copy];
        [self updateAttributeType];
    }
}

- (void)setRepresentedObject:(NSManagedObject *)representedObject {
    if(representedObject != _representedObject) {
        _representedObject = representedObject;
        [self updateAttributeType];
    }
}

- (void)setSuffix:(NSString *)suffix {
    if(![_suffix isEqualToString:_suffix]) {
        _suffix = suffix;
        self.textField.text = [self textValue];
    }
}


- (id)init {
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:NSStringFromClass([self class])];
    if(self)
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}


#pragma mark - NSNibAwaking
- (void)awakeFromNib {
    [_textField addTarget:self action:@selector(update:) forControlEvents:UIControlEventEditingDidEnd];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([_suffix length])
        textField.text = [[_representedObject stringValueForProperty:_propertyName] capitalizedString];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([_suffix length])
        textField.text = [textField.text stringByAppendingFormat:@" %@", _suffix];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(_minimum < _maximum) {
        
        if(NSStringAttributeType == _attributeType) {
            
            NSInteger newLength = [textField.text length] + [string length] - range.length;
            
            if(newLength > _maximum || newLength < _minimum) return NO;
        }
        else {
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            CGFloat value = [newString floatValue];
            
            if(value < _minimum || value > _maximum) return NO;
        }
    }
    
    return YES;
}


#pragma mark - New
- (id)valueForEnumeration:(NSInteger)enumeration {
    if([_enumerations isKindOfClass:[NSDictionary class]]) {
        return [_enumerations objectForKey:[NSNumber numberWithInteger:enumeration]];
    }
    else {
        return [_enumerations objectAtIndex:enumeration];
    }
}

- (NSInteger)enumerationForValue:(id)value {
    if([_enumerations isKindOfClass:[NSDictionary class]]) {
        return [[[_enumerations allKeys] objectAtIndex:[[_enumerations allValues] indexOfObject:value]] integerValue];
    }
    else {
        return [_enumerations indexOfObject:value];
    }
}

- (NSString *)textValue {
    
    NSString *text = [_representedObject stringValueForProperty:_propertyName];
    
    return _suffix ? [text stringByAppendingFormat:@" %@", _suffix] : text;
}

- (void)configure {
    
    NSAssert(_representedObject, @"Cannot configure cell without source object");
    
    if([[self enumerations] count])
        _textField.text = [self valueForEnumeration:_enumerationIndex];
    else
        _textField.text = [self textValue];
    
    self.label.text = [_propertyName capitalizedString];

    
    if(NSInteger32AttributeType == _attributeType || NSFloatAttributeType == _attributeType) {

        NSAttributeDescription *attribute = [self.representedObject attributeForKeyPath:self.propertyName];
        
        if(attribute) {
            _minimum = [[[attribute userInfo] valueForKey:@"minimum"] floatValue];
            _maximum = [[[attribute userInfo] valueForKey:@"maximum"] floatValue];
        }
        
        _textField.keyboardType = (_minimum < 0) ? UIKeyboardTypeNumbersAndPunctuation : UIKeyboardTypeNumberPad;
    }
}

- (id)objectValue {
    id value = nil;
    if([_enumerations count]) {
        value = [self valueForEnumeration:_enumerationIndex];
    }
    else {
        value = [NSManagedObject transformedValueForString:_textField.text attributeType:_attributeType];
    }
    return value;
}

//- (void)setBackgroundView:(UIView *)backgroundView {
//    // do nothing
//}

- (IBAction)update:(id)sender {
    [_textField resignFirstResponder];
    [_representedObject setValue:[self objectValue] forKeyPath:_propertyName];
    if(_liveEditing)
        [[UIApplication modelManager] scheduleSave];
}

+ (TextAttributeCell *)cellFromNib {
    
    static NSMutableDictionary *nibs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nibs = [[NSMutableDictionary alloc] init];
    });
    
    NSString *nibFileName = [NSString stringWithFormat:@"%@~%@", NSStringFromClass(self), [Thrint fileSuffixForDevice]];
    UINib *nib = [nibs objectForKey:nibFileName];
    
    if(!nib) {
        nib = [UINib nibForName:nibFileName];
        if (nib) {
            [nibs setObject:nib forKey:nibFileName];
        }
    }
    
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

+ (TextAttributeCell *)cellForEnumerations:(id)enumerations {
    
    TextAttributeCell *cell = [self cellFromNib];
    
    cell.textField.enabled = NO;
    cell.enumerations = enumerations;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

+ (TextAttributeCell *)cellWithObject:(NSManagedObject *)object property:(NSString *)propertyName {
    
    NSAttributeType attributeType = [object attributeTypeForProperty:propertyName];
    TextAttributeCell *cell = nil;
    
    if(NSInteger16AttributeType == attributeType) {
        cell = [self cellForEnumerations:[object enumerationStringsForProperty:propertyName]];
        cell.enumerationIndex = [[object valueForKeyPath:propertyName] integerValue] - 1;
    }
    else
        cell = [self cellFromNib];
    
    return cell;
}

@end

@implementation NSBundle (NibLocating)

+ (NSBundle *)bundleForNibName:(NSString *)name
{
    for (NSBundle *bundle in [NSBundle allBundles]) {
        if ([bundle pathForResource:name ofType:@"nib"]) {
            return bundle;
        }
    }
    return nil;
}

@end

@implementation UINib (NibLocating)

+ (instancetype)nibForName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleForNibName:name];
    return bundle ? [self nibWithNibName:name bundle:bundle] : nil;
}

@end
