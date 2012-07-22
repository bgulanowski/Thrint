//
//  ObjectDetailVC.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "ObjectDetailVC.h"

#import "TextAttributeCell.h"
//#import "BooleanAttributeCell.h"
//#import "FloatAttributeCell.h"
//#import "IntegerAttributeCell.h"
#import "ObjectListVC.h"

#import "NSManagedObject+ViewAdditions.h"
#import "NSManagedObject+BAAdditions.h"


static NSString *AttributeIdentifier = @"AttributeCell";
static NSString *CustomAttributeIdentifier = @"CustomAttributeCell";
static NSString *RelationshipIdentifier = @"RelationshipCell";

const NSUInteger kAttributeCellLabelTag = 20;
const NSUInteger kAttributeCellTextFieldTag = 21;


@interface ObjectDetailVC ()
@property (nonatomic, strong) NSTimer *saveTimer;
@property (nonatomic, strong) NSIndexPath *editedPath;
@end


@implementation ObjectDetailVC {
    NSInteger _relationCount;
}

@synthesize relatedList=_relatedList;
@synthesize object=_object, activeTextField=_activeTextField, attributeKeyPaths=_attributeKeyPaths, relationships=_relationships;
@synthesize saveTimer=_saveTimer, editedPath=_editedPath;


#pragma mark - Accessors
- (void)setObject:(NSManagedObject *)model {
    if(_object != model) {
        [[_object managedObjectContext] save:NULL];
        _object = model;
        self.relationships = [model relationshipNames];
        self.attributeKeyPaths = [model detailViewKeyPaths];
        self.navigationItem.title = [_object displayTitle];
        [self.tableView reloadData];
        NSLog(@"%@ Got object %@", self, [_object displayTitle]);
    }
}


#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/* Why do we need editing mode? We're always in editing mode!
 * bring it back as an option, and define editing mode very specifically:
 *  - disable text fields outside of edit mode
 *  - add rows for adding new objects to relationships
*/
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.allowsSelectionDuringEditing = YES;
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(_relationCount != [_relatedList.selection count])
        [self.tableView reloadData];
    else if(nil != _editedPath)
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_editedPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.editedPath = nil;
    self.relatedList = nil;
    _relationCount = NSNotFound;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.activeTextField resignFirstResponder];
    [super viewWillDisappear:animated];
}


#pragma mark - UITableViewDataSource
/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    NSLog(@"%@ %@ editing for %@", self, editing ? @"Starting" : @"Ending", [_object displayTitle]);
    [super setEditing:editing animated:animated];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    int i = 1;
    
    // For each to-many relationship, add two rows to allow selecting or adding a new relation
    // For each to-one relationship with a NULL value, add one row
    for(NSString *relName in _relationships) {
        
        id relation = [_object valueForKey:relName];
        NSUInteger count = [relation respondsToSelector:@selector(count)] ? [relation count] : (relation ? 1 : 0);
            
        [indexPaths addObject:[NSIndexPath indexPathForRow:count inSection:i]];   // Choose… item
//        [indexPaths addObject:[NSIndexPath indexPathForRow:count+1 inSection:i]]; // Add New… item
        i++;
    }
    

    [self.tableView beginUpdates];
    
    if(editing)
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    else
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
}
 */

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // add a disclosure indicator to all relationship cells
    UITableView *tv = self.tableView;
    NSUInteger sections = [tv numberOfSections];
    UITableViewCellAccessoryType accessoryType = editing ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryDetailDisclosureButton;
    
    [tv beginUpdates];
    for(NSUInteger i=1; i<sections; ++i) {
        NSUInteger rows = [tv numberOfRowsInSection:i];
        for(NSUInteger j=0; j<rows; ++j) {
            [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]].accessoryType = accessoryType;
        }
    }
    [tv endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_object relationshipNames] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger count;
//    NSString *sectionName;

    if(0 == section) {
//        sectionName = @"attributes";
        count = [_attributeKeyPaths count];
    }
    else {
        NSString *relName = [_relationships objectAtIndex:section-1];
        
        id relation = [_object valueForKey:relName];
        
        if([relation respondsToSelector:@selector(count)])
            count = [relation count] > 0 ? [relation count] : 1; // + (self.editing ? 1 : 0);
        else
            count = 1;
//        sectionName = relName;
    }
    
//    NSLog(@"Got %u rows for section %d (%@; %@ mode)", count, section, sectionName, self.editing ? @"Editing" : @"Normal");
    
    return count;
}

- (void)configureCell:(UITableViewCell*) cell forRelationship:(NSString *)relName index:(NSUInteger)index {
    
    id relValue = [_object valueForKey:relName];
    UITableViewCellAccessoryType type = UITableViewCellAccessoryNone;
    
    if([relValue respondsToSelector:@selector(count)]) {
        
        NSUInteger count = [relValue count];
        if(index < count) {
            cell.textLabel.text = [[_object objectInRelationship:relName atIndex:index] displayTitle];
            type = UITableViewCellAccessoryDetailDisclosureButton;
        }
        else // if(index == count)
            cell.textLabel.text = @"Choose…";
//        else
//            cell.textLabel.text = @"Add new…";
    }
    else {
        if(relValue) {
            cell.textLabel.text = [relValue displayTitle];
            type = UITableViewCellAccessoryDetailDisclosureButton;
        }
        else
            cell.textLabel.text = @"Choose…";
    }
    
    cell.accessoryType = type;

//    if(self.editing)
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSAttributeDescription *)attributeForIndex:(NSUInteger)index {
    
    NSAttributeDescription *attribute = nil;
    
    attribute = [_object attributeForKeyPath:[_attributeKeyPaths objectAtIndex:index]];
    
    return attribute;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TextAttributeCell *cell = nil;
    
    if(0 == [indexPath section]) {
        NSString *keyPath = [_attributeKeyPaths objectAtIndex:[indexPath row]];
        cell = [tableView dequeueReusableCellForObject:_object keyPath:keyPath];
    }
    else {
        // TODO: follow a similar strategy as used for attributes (above)
        cell = [tableView dequeueReusableCellWithIdentifier:RelationshipIdentifier];
        [self configureCell:cell forRelationship:[_relationships objectAtIndex:[indexPath section]-1] index:[indexPath row]];
    }
    
    NSAssert(nil != cell, @"blah");

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] != 0;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath section] > 0) {
        
        id relation = [_object valueForKey:[_relationships objectAtIndex:[indexPath section]-1]];
        BOOL isToMany = [relation respondsToSelector:@selector(count)];
        NSUInteger count = isToMany ? [relation count] : (NSUInteger) (relation != nil);
        
        if([indexPath row] == count) return UITableViewCellEditingStyleNone;
        if([indexPath row] > count) return UITableViewCellEditingStyleInsert;
        
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *relName = [_relationships objectAtIndex:[indexPath section]-1];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_object removeObjectFromRelationship:relName atIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [_object insertNewObjectForRelationship:relName];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [[_object managedObjectContext] save:NULL];
}


#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(0 == section) return @"Attributes";
    return [_relationships objectAtIndex:section-1];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == 0)
        return nil;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
        
    NSString *relName = [_relationships objectAtIndex:[indexPath section]-1];
    NSManagedObject *object = [_object objectInRelationship:relName atIndex:[indexPath row]];
    ObjectDetailVC *dvc = [object detailViewController];
    
    [self.navigationController pushViewController:dvc animated:YES]; 
    
    self.editedPath = indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *relName = [_relationships objectAtIndex:[indexPath section]-1];
    NSRelationshipDescription *rel = [[[_object entity] relationshipsByName] objectForKey:relName];
    NSEntityDescription *targetEntity = [[rel inverseRelationship] entity];
    
    id relation = [_object valueForKey:[_relationships objectAtIndex:[indexPath section]-1]];
    BOOL isToMany = [relation respondsToSelector:@selector(count)];

    if(relation && (!isToMany || [indexPath row] <= [relation count])) {
        
        // push new list controller for the appropriate entity to choose entries
        // selection is a to-one relationship; push new list controller for the appropriate entity
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"EntityBrowser" bundle:nil];
        ObjectListVC *lvc = [sb instantiateViewControllerWithIdentifier:@"entities_list"];
        
        if(isToMany)
            lvc.selection = [_object mutableSetValueForKey:relName];
        else
            lvc.selection = [NSMutableSet setWithObject:relation];

        lvc.entityName = [targetEntity name];
        lvc.context = [_object managedObjectContext];
        lvc.maxSelection = isToMany ? NSUIntegerMax : 1; // This should use the model predicates
        lvc.navigationItem.title = [NSString stringWithFormat:@"%@'s %@", [_object displayTitle], relName];
        
        self.editedPath = indexPath;
        _relationCount = [lvc.selection count];
        self.relatedList = lvc;
        
        [self.navigationController pushViewController:lvc animated:YES];
    }
    else {
        
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:targetEntity.name inManagedObjectContext:_object.managedObjectContext];

        if(isToMany)
            [relation addObject:new];
        else
            [_object setValue:new forKey:relName];
  
        // Don't need to do this because there is already a dummy row saying "Choose…", which will be replaced
//        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    self.editedPath = indexPath;
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}


#pragma mark - Actions
- (void)saveTimerDidFire:(NSTimer *)timer {
    [[timer userInfo] save:NULL];
    [timer invalidate];
    self.saveTimer = nil;
}

@end

@implementation UITableView (ThrintAdditions)

- (TextAttributeCell *)dequeueReusableCellForObject:(id)object keyPath:(NSString *)keyPath {

    TextAttributeCell *cell = [self dequeueReusableCellWithIdentifier:[object cellIdentifierForKeyPath:keyPath]];
    
    if(nil == cell) {
        cell = [object cellForKeyPath:keyPath];
    }
    
    cell.keyPath = keyPath;
    [object configureAttributeCell:cell];
    
    return cell;
}

@end