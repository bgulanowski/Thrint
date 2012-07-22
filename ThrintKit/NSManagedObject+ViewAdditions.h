//
//  NSManagedObject+ViewAdditions.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//


@class ObjectDetailVC, TextAttributeCell;

@interface NSAttributeDescription (ThrintAdditions)
+ (NSString *)cellIdentifierForAttributeType:(NSAttributeType)type;
- (NSString *)displayName;
@end

@interface NSManagedObject (ViewAdditions)

@property (nonatomic, readonly) UIImage *displayImage;
@property (nonatomic, readonly) NSString *displayTitle;
@property (nonatomic, readonly) NSString *displaySubtitle;
@property (nonatomic, readonly) NSString *displayDescription;

+ (ObjectDetailVC *)detailViewController;
- (ObjectDetailVC *)detailViewController;
+ (void)configureCell:(UITableViewCell *)cell;
- (void)configureCell:(UITableViewCell *)cell;
+ (UITableViewCell *)tableViewCell;
- (UITableViewCell *)tableViewCell;

- (void)configureAttributeCell:(TextAttributeCell *)cell;
- (void)updateForAttributeCell:(TextAttributeCell *)cell;

- (NSArray *)detailViewAttributes;
// Subclasses can override to add more key paths; all key paths must map to an attribute on a destination entity
// OR classes must override -cellIdentifierForKeyPath: to return a suitable identifier, and/or -cellForKeyPath:
- (NSArray *)detailViewKeyPaths;

// default returns an appropriate Thrint attribute cell class name for standard types on known attributes
- (NSString *)cellIdentifierForKeyPath:(NSString *)keyPath;
// default returns nil; subclasses should override for custom key paths
- (TextAttributeCell *)cellForKeyPath:(NSString *)keyPath;

@end
