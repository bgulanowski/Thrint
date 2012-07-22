//
//  EntityListVC.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "ObjectListVC.h"

#import "Thrint.h"

#import "NSManagedObject+ViewAdditions.h"
#import "NSManagedObjectContext+BAAdditions.h"
#import "NSManagedObject+BAAdditions.h"


NSString *kManagedObjectContextRequestNotificationName = @"ManagedObjectContextRequest";


@implementation ObjectListVC {
    NSEntityDescription *_entity;
    Class _modelClass;
    BOOL _selectionCountChanged;
}

@synthesize context=_context, popOver=_popOver, content=_content, entityName=_entityName, selection=_selection;
@synthesize minSelection=_minSelection, maxSelection=_maxSelection, selectedIndex=_selectedIndex;


#pragma mark - Private
- (void)updateSelection {
    
    if([_selection count] > 0) {
        NSIndexSet *indexes = [_content indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [_selection containsObject:obj];
        }];
        
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];        
        }];
    }
    else if (nil == _selection) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)reloadContent {

    if(!_context || !_entityName) return;

    _modelClass = NSClassFromString(_entityName);
    
    if(!_modelClass)
        _modelClass = [NSManagedObject class];
    
    self.content = [_context objectsForEntityNamed:_entityName matchingPredicate:nil];
    
    if([_content count] > 0) [self updateSelection];
}

- (void)synchronizeDetailView:(NSIndexPath *)indexPath {
    
    ObjectDetailVC *dvc = (ObjectDetailVC *)[[[self.splitViewController viewControllers] lastObject] topViewController];

    if([_content count])
        dvc.object = [_content objectAtIndex:indexPath ? [indexPath row] : 0];
    
    [self.popOver dismissPopoverAnimated:YES];
}

// Updates the last selected row if it appeared in the detail view, since the values might have changed
- (void)synchronizeSelectionWithDetailView {
    
    ObjectDetailVC *dvc = (ObjectDetailVC *)[[[self.splitViewController viewControllers] lastObject] topViewController];
    
    if(![dvc isKindOfClass:[ObjectDetailVC class]]) return;
    
    NSManagedObject * model = dvc.object;
    
    if(!model) {
        
        NSUInteger row = [_content indexOfObject:model];
        
        if(NSNotFound != row) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}


#pragma mark - Accessors

- (void)setContent:(NSArray *)array {
    if(![_content isEqual:array]) {
        _content = [array mutableCopy];
        [self.tableView reloadData];
    }
}

- (void)setEntityName:(NSString *)entityName {
    if(![_entityName isEqualToString:entityName]) {
        _entityName = entityName;
        NSLog(@"%@ configured for %@", self, _entityName);
        [self reloadContent];
    }
}

- (void)setContext:(NSManagedObjectContext *)moc {
    if(![moc isEqual:_context]) {
        _context = moc;
        [self reloadContent];
    }
}


#pragma mark - UIViewController
- (id)init {
    self = [super init];
    if(self) {
        _minSelection = 0;
        _maxSelection = NSUIntegerMax;
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {
        _minSelection = 0;
        _maxSelection = NSUIntegerMax;
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _minSelection = 0;
        _maxSelection = NSUIntegerMax;
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        _minSelection = 0;
        _maxSelection = NSUIntegerMax;
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.editButtonItem.action = @selector(edit:);
    self.editButtonItem.target = self;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.contentSizeForViewInPopover = CGSizeMake(320, 640);
    
    [self synchronizeDetailView:nil];
    
    if(!_context)
        [[NSNotificationCenter defaultCenter] postNotificationName:kManagedObjectContextRequestNotificationName object:self];
}
        
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![_selection count])
        [self synchronizeSelectionWithDetailView];
}

- (void)viewDidAppear:(BOOL)animated {
    if(NSNotFound != _selectedIndex) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        _selectedIndex = NSNotFound;
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_content count] + (int)self.editing;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = indexPath.row < [_content count] ? [_content objectAtIndex:[indexPath row]] : nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_entityName];

    if (nil == cell) {
        if(nil == object)
            cell = [_modelClass tableViewCell];
        else
            cell = [object tableViewCell];
    }
    else
        if(nil == object)
            [_modelClass configureCell:cell];
        else
            [object configureCell:cell];

    
    if([_selection containsObject:object])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    else if(self.editing)
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSManagedObject *)insertObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = [[NSEntityDescription entityForName:self.entityName inManagedObjectContext:_context] managedObjectClassName];
    
    NSManagedObject *model = [NSClassFromString(className) insertObject];
    
    [_content insertObject:model atIndex:[indexPath row]];
    [_context save:NULL];
    
    return model;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == [_content count]) return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_context deleteObject:[_content objectAtIndex:[indexPath row]]];
        [_content removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self insertObjectAtIndexPath:indexPath];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }   
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This detail view update should only occur if our list view is in the master view controller
    // Currently, the fact we use to determine this is whether there is a selection
    // We can re-use the listVC as a selection menu for a to-one relationship, in which case selected should not be nil
    NSManagedObject *object = [_content objectAtIndex:[indexPath row]];
    BOOL wasSelected = [_selection containsObject:object];
    BOOL reload = NO;
    
    if(_selection) {
        if(wasSelected && [_selection count] > _minSelection) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [_selection removeObject:object];
            reload = YES;
        }
        else if(!wasSelected) {
            if(1 == _maxSelection) {
                [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
                [_selection removeAllObjects];
            }
            if([_selection count] < _maxSelection)
                [_selection addObject:object];
            reload = YES;
        }
        
        if(reload) {
            _selectionCountChanged = YES;
            [[[UIApplication sharedApplication] modelManager] scheduleSave];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

        ObjectDetailVC *dvc = [[UIStoryboard storyboardWithName:@"EntityBrowser" bundle:nil] instantiateViewControllerWithIdentifier:@"object_detail"];
        
        dvc.object = object;
        [[self navigationController] pushViewController:dvc animated:YES];
        
        _selectedIndex = [indexPath row];
    }
    else
        [self synchronizeDetailView:indexPath];
}


#pragma mark - ACtions
- (IBAction)edit:(id)sender {
    
    BOOL editing = !self.editing;
    
    [self.tableView beginUpdates];
    self.editing = editing;
    [self.tableView setEditing:self.editing animated:YES];    
    if(editing) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0]-1 inSection:0];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
}

@end
