//
//  NSManagedObject+ViewAdditions.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "NSManagedObject+ViewAdditions.h"

#import "Product.h"
#import "Team.h"
#import "Developer.h"
#import "ObjectDetailVC.h"
#import "TextAttributeCell.h"
#import "BooleanAttributeCell.h"
#import "FloatAttributeCell.h"
#import "IntegerAttributeCell.h"
#import "NSManagedObject+BAAdditions.h"



@implementation NSAttributeDescription (ThrintAdditions)

+ (NSString *)cellIdentifierForAttributeType:(NSAttributeType)type {
    
    NSString *identifier = nil;
    
    switch (type) {
            
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
            identifier = NSStringFromClass([IntegerAttributeCell class]);
            break;
            
        case NSBooleanAttributeType:
            identifier = NSStringFromClass([BooleanAttributeCell class]);
            break;
            
        case NSDecimalAttributeType:
        case NSFloatAttributeType:
            identifier = NSStringFromClass([FloatAttributeCell class]);
            break;
            
        case NSStringAttributeType:
        case NSDateAttributeType: // TODO: make new cell for dates
            // TODO: check for a user info entry which specifies a transformer class
        case NSBinaryDataAttributeType:
            identifier = NSStringFromClass([TextAttributeCell class]);
            break;
            
        case NSUndefinedAttributeType:
        default:
            break;
    }
    
    return identifier;
}

- (NSString *)cellIdentifier {
    NSString *identifier = [NSAttributeDescription cellIdentifierForAttributeType:[self attributeType]];
    if(!identifier)
        identifier = [[self userInfo] objectForKey:@"cell_identifier"];
    return identifier;
}

- (NSString *)displayName {
    NSString *displayName = [[self userInfo] objectForKey:@""];
    if(!displayName)
        displayName = self.name;
    return displayName;
}

@end


@implementation NSManagedObject (ViewAdditions)

#pragma mark - Private
- (NSArray *)cellPrototypeIdentifiers {
    
    static NSArray *array;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        array = [[NSArray alloc] initWithObjects:
                 @"TextAttributeCell",
                 @"IntegerAttributeCell",
                 @"BooleanAttributeCell",
                 @"FloatAttributeCell",
                 // @"ImageAttributeCell"
                 // @"URLAttributeCell"
                 nil];
    });
    
    return array;
}

- (UIImage *)displayImage {
    
    if([self respondsToSelector:@selector(image)])
        return [self performSelector:@selector(image)];
    
    if([self respondsToSelector:@selector(imageData)])
        return [UIImage imageWithData:[self performSelector:@selector(imageData)]];
    
    return nil;
}

- (NSString *)displayTitle {
    
    NSString *title;
    
    if([self respondsToSelector:@selector(name)])
        title = [self performSelector:@selector(name)];
    else if([self respondsToSelector:@selector(title)])
        title = [self performSelector:@selector(title)];
    else
        // TODO: insert spaces before capital letters
        title = [[self entity] name];
    
    return [title capitalizedString];
}

- (NSString *)displaySubtitle { return @""; }

- (NSString *)displayDescription {

    NSString *sub = [self displaySubtitle];
    
    if([sub length])
        return [NSString stringWithFormat:@"%@ (%@)", [self displayTitle], sub];
    else
        return [self displayTitle];
}


+ (ObjectDetailVC *)detailViewController {

//    NSString *dvcClassName = [[[self entity] name] stringByAppendingString:@"DetailVC"];
//    Class customClass = NSClassFromString(dvcClassName) ?: [ObjectDetailVC class];
//    ObjectDetailVC *detailVC = [[customClass alloc] initWithStyle:UITableViewStyleGrouped];
      
    ObjectDetailVC *detailVC = nil;
    
    if(NSClassFromString(@"UIStoryboard")) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"EntityBrowser" bundle:nil];
        ObjectDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"object_detail"];
        
        // copy prototypes
//        for(NSString *identifier in [self cellPrototypeIdentifiers]) {
//            
//        }
        detailVC = vc;
    }
    
    return detailVC;
}

- (ObjectDetailVC *)detailViewController {
    
    ObjectDetailVC *detailVC = [[self class] detailViewController];
    
    detailVC.object = self;
    
    return detailVC;
}

+ (void)configureCell:(UITableViewCell *)cell {
    cell.textLabel.text = @"Add New…";
}

- (void)configureCell:(UITableViewCell *)cell {    
    cell.textLabel.text = [self displayTitle];
    cell.imageView.image = [self displayImage];
}

+ (UITableViewCell *)tableViewCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:NSStringFromClass(self)];
    [self configureCell:cell];
    return cell;
}

- (UITableViewCell *)tableViewCell {
    
    UITableViewCell *cell = [[self class] tableViewCell];
    
    [self configureCell:cell];
    
    return cell;
}

- (void)configureCell:(TextAttributeCell *)cell forAttribute:(NSAttributeDescription *)attribute {
    cell.representedObject = self;
    [cell configureWithValue:[self valueForKey:attribute.name] attribute:attribute];
}

- (void)configureAttributeCell:(TextAttributeCell *)cell {
    [self configureCell:cell forAttribute:[self attributeForName:cell.keyPath]];
}

- (void)updateForAttributeCell:(TextAttributeCell *)cell {
    [self setValue:[cell objectValue] forKey:cell.keyPath];
}

+ (NSPredicate *)safeAttributesPredicate {
    
    static __strong NSPredicate *predicate;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{

        NSAttributeType types[] = { NSInteger16AttributeType, NSInteger32AttributeType, NSInteger64AttributeType, NSStringAttributeType, NSFloatAttributeType, NSDoubleAttributeType, NSBooleanAttributeType, NSDecimalAttributeType };
        NSMutableArray *safeTypes = [NSMutableArray array];
        
        for(NSUInteger i=0; i< sizeof(types)/sizeof(NSAttributeType); ++i)
            [safeTypes addObject:[NSNumber numberWithInteger:types[i]]];

        predicate = [NSPredicate predicateWithFormat:@"type in %@", safeTypes];
    });
    
    return predicate;
}

- (NSArray *)detailViewAttributes {
    return [[[[self entity] attributesByName] allValues] filteredArrayUsingPredicate:[[self class] safeAttributesPredicate]];
}

- (NSArray *)detailViewKeyPaths {
    return [[self detailViewAttributes] valueForKey:@"name"];
}

- (NSString *)cellIdentifierForKeyPath:(NSString *)keyPath {
    return [[self attributeForKeyPath:keyPath] cellIdentifier];
}

- (TextAttributeCell *)cellForKeyPath:(NSString *)keyPath {
    
    NSString *identifier = [self cellIdentifierForKeyPath:keyPath];
    
    return (TextAttributeCell *)[[NSClassFromString(identifier) alloc] init];
}

@end
