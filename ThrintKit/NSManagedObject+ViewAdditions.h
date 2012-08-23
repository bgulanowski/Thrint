//
//  NSManagedObject+ViewAdditions.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-18.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <CoreData/CoreData.h>


@class DetailVC, ListVC, TextAttributeCell;

@interface NSManagedObject (ViewAdditions)

- (NSString *)displayTitle;
- (NSString *)displaySubtitle;
- (NSString *)displayDescription;
- (UIImage *)displayImage;

- (NSArray *)displayPropertyNames; // attributes, relationships or keypaths
- (DetailVC *)detailViewController;
+ (ListVC *)listViewController;
- (ListVC *)listViewControllerForRelationship:(NSString *)relationshipName;

- (TextAttributeCell *)cellForRelationship:(NSString *)relationshipName /* index:(NSUInteger)index*/; // index is only relevant for to-many relationships
- (Class)cellClassForProperty:(NSString *)propertyName;
- (TextAttributeCell *)cellForProperty:(NSString *)propertyName;
- (TextAttributeCell *)cellForProperty:(NSString *)property tableView:(UITableView *)tableView;

- (UITableViewCell *)subtitleCellForTableView:(UITableView *)tableView;

// Subclasses must override for any enumerated types (NSInteger16AttributeType)
- (NSArray *)enumerationStringsForProperty:(NSString *)propertyName;

+ (NSString *)localizedString:(NSString *)string;
+ (NSArray *)localizedStrings:(NSArray *)strings;

- (NSString *)localizedString:(NSString *)string;
- (NSArray *)localizedStrings:(NSArray *)strings;

@end
