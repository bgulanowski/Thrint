//
//  DetailVC.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-18.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "DetailVC.h"

#import "ListVC.h"
#import "TextAttributeCell.h"
#import "EntityListDataSource.h"
#import <BAFoundation/BACoreDataManager.h>

#import "NSManagedObject+ViewAdditions.h"
#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>
#import "NSManagedObject+ViewAdditions.h"


@implementation DetailVC

@synthesize endEditingBlock=_endEditingBlock;
@synthesize container=_container;
@synthesize tableFooterView = _tableFooterView;
@synthesize object=_object;
@synthesize properties=_properties;
@synthesize action=_action;
@synthesize liveEditing=_liveEditing, editMode = _showDeleteButton;

#pragma mark - Private
- (void)updateForLiveEditingState {
    if(_liveEditing) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancelEdits:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(saveEdits:)];
    }
}

- (void)confirmCancel {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"discard_changes_", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                         destructiveButtonTitle:NSLocalizedString(@"discard", @"")
                                              otherButtonTitles:nil];
    self.action = ActionCancel;
    
    if(self.tabBarController)
        [sheet showFromTabBar:self.tabBarController.tabBar];
    else
        [sheet showInView:self.view];
}


#pragma mark - Accessors
- (UINavigationController *)navigationController {
    
    UINavigationController *nav = [super navigationController];
    if(!nav && _container)
        nav = _container.navigationController;
    
    return nav;
}

- (void)setLiveEditing:(BOOL)liveEditing {
    if(_liveEditing != liveEditing) {
        _liveEditing = liveEditing;
        if(_liveEditing)
            [[UIApplication modelManager] endEditing];
        else
            [[UIApplication modelManager] startEditing];
        [self updateForLiveEditingState];
    }
}

#pragma mark - Accessors
- (void)setObject:(NSManagedObject *)model {
    if(_object != model) {
        [[_object managedObjectContext] save:NULL];
        if([_object class] != [model class])
            self.properties = nil;
        _object = model;
        self.navigationItem.title = [_object displayTitle];
        [self.tableView reloadData];
        NSLog(@"%@ Got object %@", self, [_object displayTitle]);
    }
}

- (NSArray *)properties {
    if(!_properties)
        _properties = [_object displayPropertyNames];
    return _properties;
}


#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];

    gr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gr];

    if(_showDeleteButton && _tableFooterView)
        self.tableView.tableFooterView = self.tableFooterView;
}

- (void)viewDidUnload {
    self.tableFooterView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


// We don't need to do this here if the cancel/done buttons are working properly
//- (void)viewDidDisappear:(BOOL)animated {
//    if(![[self.navigationController viewControllers] containsObject:self]) {
//        // we got popped
//        if(_endEditingBlock) _endEditingBlock();
//        if(!_liveEditing) [[UIApplication modelManager] endEditing];
//    }
//    [super viewDidDisappear:animated];
//}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *propertyName = [_properties objectAtIndex:[indexPath row]];
    NSAttributeType type = [_object attributeTypeForProperty:propertyName];
    ListVC *listVC = nil;
    
    if(type == RELATIONSHIP_PROPERTY_TYPE) {
        listVC = [_object listViewControllerForRelationship:propertyName];
    }
    else if(NSInteger16AttributeType == type) {
        
        TextAttributeCell *cell = (TextAttributeCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSArray *enums = [cell enumerations];
        
        NSAssert([enums count], @"enumerated property type with no enumerations");
        
        // property enums start at 1 (0 means "undefined")
        NSInteger index = [[self.object valueForKeyPath:propertyName] integerValue] - 1;
        NSIndexPath *listSelectionPath = [NSIndexPath indexPathForRow:index inSection:0];
        ListDataSource *dataSource = [ListDataSource dataSourceWithContent:enums selectionPath:listSelectionPath];

        listVC = [ListVC listViewControllerWithDataSource:dataSource];
    }
    
    if(listVC) {
        ListVC *weakListVC = listVC;
        listVC.selectionBlock = ^(id object) {
            weakListVC.dataSource.selection = object;
            // I *could* trust this to the cell itself; it's partially implemented; not sure
            if(NSInteger16AttributeType == type)
                object = [NSNumber numberWithInt:[weakListVC.dataSource.selectionPath row] + 1];
            [_object setValue:object forKeyPath:propertyName];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return (UIViewController *)nil;
        };
        [self.navigationController pushViewController:listVC animated:YES];
    }
}


#if 0
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // It's a relationship, so get the related object and push a detail view controller -- don't need this right now
    UIViewController *child = [[_content objectAtIndex:[indexPath row]] detailViewController];
    if(child)
        [self.navigationController pushViewController:child animated:YES];
}
#endif

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.properties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *property = [[self properties] objectAtIndex:[indexPath row]];
    TextAttributeCell *cell = [_object cellForProperty:property tableView:tableView];
    
    NSAssert(cell, @"No cell created!");
    
    cell.liveEditing = _liveEditing;
    return cell;
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if([actionSheet cancelButtonIndex] == buttonIndex) return;
    
    [self.view endEditing:YES];
    
    if(_action == ActionCancel) {
        if([self.object isInserted]) {
            [self.object.managedObjectContext deleteObject:self.object];
            self.object = nil;
        }
        else {
            [self.object.managedObjectContext refreshObject:self.object mergeChanges:NO];
        }
        [[UIApplication modelManager] cancelEdits];
    }
    else if(_action == ActionDelete) {
        [self.object.managedObjectContext deleteObject:self.object];
        [[UIApplication modelManager] endEditing];
        [[UIApplication modelManager] save];
    }
    
    [self cancelConfirmed];
}


#pragma mark - New
- (id)initWithObject:(NSManagedObject *)object properties:(NSArray *)properties {
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self) {
        self.object = object;
        self.properties = properties;
        self.editMode = YES;
        [[UIApplication modelManager] startEditing]; // _liveEditing is NO
        [self updateForLiveEditingState];
    }
    return self;
}

+ (DetailVC *)detailViewControllerWithObject:(NSManagedObject *)object properties:(NSArray *)properties {
    return [[self alloc] initWithObject:object properties:properties];
}

//- (ListVC *)listViewControllerForProperty:(NSString *)property {
//    
//}

- (void)cancelConfirmed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finalizeEditing {
    [self.view endEditing:YES];
    if(!_liveEditing)
        [[UIApplication modelManager] endEditing];
    if(_endEditingBlock) _endEditingBlock();
}


#pragma mark - Actions
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)cancelEdits:(id)sender {
    
    [self.view endEditing:YES];
    
    if([[_object changedValues] count] < 1) {
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication modelManager] endEditing];
    }
    else {
        [self confirmCancel];
    }
}

- (IBAction)saveEdits:(id)sender {
    [self finalizeEditing];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteObject:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"delete_log_", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                         destructiveButtonTitle:NSLocalizedString(@"delete", @"")
                                              otherButtonTitles:nil];
    self.action = ActionDelete;
    
    if(self.tabBarController)
        [sheet showFromTabBar:self.tabBarController.tabBar];
    else
        [sheet showInView:self.view];
}

@end
