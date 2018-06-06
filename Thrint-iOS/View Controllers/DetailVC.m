//
//  DetailVC.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-18.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "DetailVC.h"

#import "THRDataManager.h"
#import "ListVC.h"
#import "TextAttributeCell.h"
#import "EntityListDataSource.h"

#import "NSManagedObject+ViewAdditions.h"

#import <BAFoundation/BACoreDataManager.h>
#import <BAFoundation/NSManagedObject+BAAdditions.h>
#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>

@interface DetailVC ()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation DetailVC

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

- (void)confirmDiscardChanges {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"discard_changes", @"")
                                                                   message:NSLocalizedString(@"discard_message", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *discardAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"discard", @"")
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                              [self applyCancelEdits];
                                                          }];
    
    [alert addAction:discardAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)confirmDeleteObject {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"delete_entry_title", @"")
                                                                   message:NSLocalizedString(@"delete_entry_message", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", @"")
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self applyDelete];
                                                   }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Accessors

- (UINavigationController *)navigationController {
    
    UINavigationController *nav = [super navigationController];
    if(!nav && _container) {
        nav = _container.navigationController;
    }
    return nav;
}

- (void)setLiveEditing:(BOOL)liveEditing {
    if(_liveEditing != liveEditing) {
        _liveEditing = liveEditing;
        if(_liveEditing) {
            [[UIApplication modelManager] endEditing];
        }
        else {
            [[UIApplication modelManager] startEditing];
        }
        [self updateForLiveEditingState];
    }
}

- (void)setObject:(NSManagedObject *)model {
    if(_object != model) {
        [[_object managedObjectContext] save:NULL];
        if([_object class] != [model class]) {
            self.properties = nil;
        }
        _object = model;
        self.navigationItem.title = [_object displayTitle];
        [self.tableView reloadData];
        NSLog(@"%@ Got object %@", self, [_object displayTitle]);
    }
}

- (NSArray *)properties {
    if(!_properties) {
        _properties = [_object displayPropertyNames];
    }
    return _properties;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];

    gr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gr];

    if(_showDeleteButton && _tableFooterView) {
        self.tableView.tableFooterView = self.tableFooterView;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

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
        __weak typeof (self) weakSelf = self;
        ListVC *weakListVC = listVC;
        listVC.selectionBlock = ^(id object) {
            weakListVC.dataSource.selection = object;
            // I *could* trust this to the cell itself; it's partially implemented; not sure
            if(NSInteger16AttributeType == type) {
                object = @([weakListVC.dataSource.selectionPath row] + 1);
            }
            [weakSelf.object setValue:object forKeyPath:propertyName];
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

#pragma mark - DetailVC

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[UIApplication modelManager] startEditing]; // _liveEditing is NO
    }
    return self;
}

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
    return [[(THRDataManager *)[UIApplication modelManager] thrintStoryboard] detailViewControllerWithObject:object properties:properties] ?: [[self alloc] initWithObject:object properties:properties];
}

//- (ListVC *)listViewControllerForProperty:(NSString *)property {
//    
//}

- (void)finalizeEditing {
    [self.view endEditing:YES];
    if(!_liveEditing) {
        [[UIApplication modelManager] endEditing];
    }
    if(_endEditingBlock) {
         _endEditingBlock();
    }
}

- (void)dismissSelf {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Actions

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)cancelEdits:(id)sender {
    
    [self.view endEditing:YES];
    
    if([[_object changedValues] count] < 1) {
        [[UIApplication modelManager] endEditing];
        [self dismissSelf];
    }
    else {
        [self confirmDiscardChanges];
    }
}

- (IBAction)saveEdits:(id)sender {
    [self finalizeEditing];
    [self dismissSelf];
}

- (IBAction)deleteObject:(id)sender {
    [self confirmDeleteObject];
}

#pragma mark - DetailVC

- (void)applyCancelEdits {
    // ???: necessary?
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    if([self.object isInserted]) {
        [self.object.managedObjectContext deleteObject:self.object];
        self.object = nil;
    }
    else {
        [self.object.managedObjectContext refreshObject:self.object mergeChanges:NO];
    }
    [[UIApplication modelManager] cancelEdits];
    [self dismissSelf];
}

- (void)applyDelete {
    [self.view endEditing:YES];
    [self.object.managedObjectContext deleteObject:self.object];
    [[UIApplication modelManager] endEditing];
    [[UIApplication modelManager] save];
}

@end

@implementation UIStoryboard (ThrintDetail)

- (DetailVC *)detailViewControllerWithObject:(NSManagedObject *)object properties:(NSArray *)properties {
    DetailVC *dvc = [self instantiateViewControllerWithIdentifier:@"object_detail"];
    dvc.object = object;
    dvc.properties = properties;
    return dvc;
}

@end
