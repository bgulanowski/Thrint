//
//  NSManagedObject+ViewAdditions.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-18.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "NSManagedObject+ViewAdditions.h"

#import "DetailVC.h"
#import "ListVC.h"

#import "TextAttributeCell.h"
#import "BooleanAttributeCell.h"
#import "SliderAttributeCell.h"
#import "DateAttributeCell.h"
#import <BAFoundation/BACoreDataManager.h>

#import <BAFoundation/NSManagedObject+BAAdditions.h>

@interface NSObject (ViewAdditions)
- (UIImage *)image;
- (NSData *)imageData;
@end

@implementation NSManagedObject (ViewAdditions)

- (UIImage *)displayImage {
    
    if([self respondsToSelector:@selector(image)])
        return [self performSelector:@selector(image)];
    
    if([self respondsToSelector:@selector(imageData)])
        return [UIImage imageWithData:[self performSelector:@selector(imageData)]];
    
    return nil;
}

- (NSString *)displayTitle {
    return [[self valueForKey:[[self class] defaultSortKey]] capitalizedString];
}

- (NSString *)displaySubtitle { return @""; }

- (NSString *)displayDescription {
    
    NSString *sub = [self displaySubtitle];
    
    if([sub length])
        return [NSString stringWithFormat:@"%@ (%@)", [self displayTitle], sub];
    else
        return [self displayTitle];
}

- (NSArray *)displayPropertyNames {
#if 1
    return [self attributeNames];
#else
    NSArray *attributeNames = [self attributeNames];
    NSArray *relationshipNames = [self relationshipNames];
    
    return [attributeNames arrayByAddingObjectsFromArray:relationshipNames];
#endif
}

- (DetailVC *)detailViewController {
    
    NSString *className = [[[self entity] name] stringByAppendingString:@"DetailVC"];
    Class class = NSClassFromString(className) ?: [DetailVC class];
    NSManagedObjectContext *editor = [UIApplication modelManager].editingContext;
    NSManagedObject *scratch = [editor objectWithID:[self objectID]];
    
    DetailVC *dvc = [class detailViewControllerWithObject:scratch properties:[self displayPropertyNames]];
    
    dvc.hidesBottomBarWhenPushed = YES;
    
    return dvc;
}

+ (ListVC *)listViewController {
    
    NSString *className = [[self entityName] stringByAppendingString:@"ListVC"];
    Class class = NSClassFromString(className) ?: [ListVC class];
    
    ListVC * lvc = [class entityList];
    
    if(class == [ListVC class])
        [(EntityListDataSource *)lvc.dataSource setEntityName:[self entityName]];
    
    return lvc;
}

- (ListVC *)listViewControllerForRelationship:(NSString *)relationshipName {
    
    NSManagedObject *relation = [self valueForKeyPath:relationshipName];
    Class relationClass = [relation class];
    
    if(!relationClass) {
        NSRelationshipDescription *rd = [self relationshipForName:relationshipName];
        relationClass = NSClassFromString([[rd destinationEntity] managedObjectClassName]);
    }
    
    ListVC *entityListVC = [relationClass listViewController];
    
    [(EntityListDataSource *)entityListVC.dataSource setContext:self.managedObjectContext];
    entityListVC.dataSource.selection = relation;
    entityListVC.dataSource.showSubtitle = NO;
    
    return entityListVC;
}

- (TextAttributeCell *)cellForRelationship:(NSString *)relationshipName /*index:(NSUInteger)index*/ {
    
    TextAttributeCell *cell = [TextAttributeCell cell];
    
#if 1
    cell.representedObject = self;
    cell.propertyName = relationshipName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textField.enabled = NO;
    
    [cell configure];
    
#else
    id relValue = [self valueForKey:relationshipName];
    UITableViewCellAccessoryType type = UITableViewCellAccessoryNone;
    
    // Support for to-many relationships
    if([relValue respondsToSelector:@selector(count)]) {
        
#if 1
        [NSException raise:NSInternalInconsistencyException format:@"Can't handle to-many relationships!"];
#else   
        if(index < [relValue count]) {
            cell.detailTextLabel.text = [[self objectInRelationship:relationshipName atIndex:index] displayTitle];
            type = UITableViewCellAccessoryDetailDisclosureButton;
        }
        else
            cell.detailTextLabel.text = @"Choose…";
#endif
    }
    else {
        cell.label.text = NSLocalizedStringFromTable(relationshipName, self.entity.name, @"Display name for relationship");
        if(relValue) {
            cell.detailTextLabel.text = [relValue displayTitle];
            type = UITableViewCellAccessoryDetailDisclosureButton;
        }
        else
            cell.detailTextLabel.text = @"Choose…";
    }
    
    cell.accessoryType = type;
#endif
    
    return cell;
}

- (Class)cellClassForProperty:(NSString *)propertyName {
    
    NSAttributeType attributeType = [self attributeTypeForProperty:propertyName];
    Class class = Nil;

    switch (attributeType) {
        case NSUndefinedAttributeType:
            [NSException raise:NSInternalInconsistencyException format:@"Cannot support NSUndefinedAttributeType"];
            return nil;
            
        case NSDecimalAttributeType:
            [NSException raise:NSInternalInconsistencyException format:@"Cannot support NSDecimalAttributeType"];
            break;
            
        case NSDoubleAttributeType:
        case NSFloatAttributeType:
            class = [SliderAttributeCell class];
            break;
            
        case NSBooleanAttributeType:
            class = [BooleanAttributeCell class];
            break;
            
        case NSBinaryDataAttributeType:
            [NSException raise:NSInternalInconsistencyException format:@"Cannot support NSBinaryDataAttributeType"];
            break;
            
        case NSTransformableAttributeType:
            [NSException raise:NSInternalInconsistencyException format:@"Cannot support NSTransformableAttributeType"];
            break;
            
        case NSObjectIDAttributeType:
            [NSException raise:NSInternalInconsistencyException format:@"Cannot support NSObjectIDAttributeType"];
            break;
            
        case NSStringAttributeType:
        case NSInteger32AttributeType:
        case NSInteger16AttributeType:
        case NSDateAttributeType:
        default:
            class = [TextAttributeCell class];
            break;
    }
    
    return class;
}

- (TextAttributeCell *)cellForProperty:(NSString *)propertyName {
    
    NSAttributeType attributeType = [self attributeTypeForProperty:propertyName];
    
    if(RELATIONSHIP_PROPERTY_TYPE == attributeType) {
        // Ignoring to-manys for now -- each custom table should solve that problem on its own
        return [self cellForRelationship:propertyName  /* index:0*/];
    }
    
    return [[self cellClassForProperty:propertyName] cellWithObject:self property:propertyName];
}

- (TextAttributeCell *)cellForProperty:(NSString *)property tableView:(UITableView *)tableView {
        
    NSString *identifier = NSStringFromClass([self cellClassForProperty:property]);
    TextAttributeCell *cell = nil;
    
    if(identifier)
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
        cell = [self cellForProperty:property];

    if(cell) {
        cell.propertyName = property;
        cell.attributeType = [self attributeTypeForProperty:property];
        cell.representedObject = self;
        [cell configure];
    }
    
    return cell;
}

- (UITableViewCell *)subtitleCellForTableView:(UITableView *)tableView {
    
    static NSString *CellIdentifier = @"EntityListDataSourceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self displayTitle];
    cell.detailTextLabel.text = [self displaySubtitle];
    
    return cell;
}

- (NSArray *)enumerationStringsForProperty:(NSString *)propertyName {
    return [NSArray array];
}

+ (NSString *)localizedString:(NSString *)string {
    return NSLocalizedStringFromTable(string, [[self class] entityName], @"");
}

- (NSString *)localizedString:(NSString *)string {
    return [[self class] localizedString:string];
}

+ (NSArray *)localizedStrings:(NSArray *)strings {

    NSString *entityName = [[self class] entityName];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[strings count]];
    
    for(NSString *string in strings)
        [result addObject:NSLocalizedStringFromTable(string, entityName, @"")];
         
    return result;
}

- (NSArray *)localizedStrings:(NSArray *)strings {
    return [[self class] localizedStrings:strings];
}

@end
