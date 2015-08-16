//
//  ListVC.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-18.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "ListVC.h"
#import "DetailVC.h"
#import <BAFoundation/BACoreDataManager.h>

#import "NSManagedObject+ViewAdditions.h"


@implementation ListVC

@synthesize dataSource=_dataSource;
@synthesize container=_container;
@synthesize popOver=_popOver;
@synthesize selectionBlock=_selectionBlock;
@synthesize selection=_selection;
@synthesize allowEditing=_allowEditing;

#pragma mark - Private
// Updates the last selected row if it appeared in the detail view, since the values might have changed
- (void)synchronizeSelectionWithDetailView {
    
    DetailVC *dvc = (DetailVC *)[[[self.splitViewController viewControllers] lastObject] topViewController];
    
    if(![dvc isKindOfClass:[DetailVC class]]) return;
    
    NSManagedObject * model = dvc.object;
    
    if(!model) {
        
        NSUInteger row = [self.dataSource indexPathForObject:model inSection:0].row;
        
        if(NSNotFound != row) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)synchronizeDetailView:(NSIndexPath *)indexPath {
    
    DetailVC *dvc = (DetailVC *)[[[self.splitViewController viewControllers] lastObject] topViewController];
    
    if([self.dataSource.content count])
        dvc.object = [self.dataSource objectAtIndexPath:indexPath];
    
    [self.popOver dismissPopoverAnimated:YES];
}


#pragma mark - Accessors
- (void)setDataSource:(ListDataSource *)dataSource {
    if(![dataSource isEqual:_dataSource]) {
        _dataSource.delegate = nil;
        _dataSource = dataSource;
        _dataSource.delegate = self;
    }
}
- (UINavigationController *)navigationController {
    
    UINavigationController *nav = [super navigationController];
    if(!nav && _container)
        nav = _container.navigationController;
    
    return nav;
}


#pragma mark - NSObject
- (id)init {
    return [self initWithDataSource:[[self class] dataSource]];
}


#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.dataSource = [[self class] dataSource];
        _allowEditing = YES;
    }
    return self;
}


#pragma mark - UIViewController
- (void)viewDidLoad {
    self.tableView.dataSource = _dataSource;
    _dataSource.tableView = self.tableView;
    if(_allowEditing && !_dataSource.selectionPath) {
        self.editButtonItem.action = @selector(edit:);
        self.editButtonItem.target = self;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;

        if(iPad) {
            self.preferredContentSize = CGSizeMake(320, 640);
            
            [self synchronizeDetailView:nil];
        }
    }
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    
    BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    
    if(iPad && self.dataSource.selection)
        [self synchronizeSelectionWithDetailView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - UITableViewDelegate
- (UIViewController *)viewControllerForIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = [_dataSource objectAtIndexPath:indexPath];
    UIViewController *vc;
    
    if(_selectionBlock) {
        vc = _selectionBlock(object);
    }
    else {

        DetailVC *dvc = [object detailViewController];
        
        dvc.endEditingBlock = ^{
            [[UIApplication modelManager] save];
        };
        vc = dvc;
    }

    return vc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *old = _dataSource.selectionPath;
    
    if([old isEqual:indexPath]) return;
        
    UIViewController *vc = [self viewControllerForIndexPath:indexPath];
    BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;

    if(vc)
        if(iPad)
            [self synchronizeDetailView:indexPath];
        else
            [self.navigationController pushViewController:vc animated:YES];
    
    if(old)
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, old, nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    id object = [_dataSource objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[object detailViewController] animated:YES];
}


#pragma mark - UITableViewDelegate editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == [_dataSource.content count]) return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - ListDataSourceDelegate
- (void)listDataSourceDidReload:(ListDataSource *)dataSource {
    if(_selection)
        dataSource.selection = _selection;
    if([self isViewLoaded] && dataSource.content && !self.editing)
        [self.tableView reloadData];
}

- (BOOL)dataSourceAllowsEditing:(ListDataSource *)dataSource {
    return _allowEditing;
}


#pragma mark - New
- (id)initWithDataSource:(ListDataSource *)dataSource {
    self = [self initWithStyle:UITableViewStylePlain];
    if(self) {
        self.dataSource = dataSource;
        _allowEditing = YES;
    }
    return self;
}

- (id)initWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path {
    return [self initWithDataSource:[ListDataSource dataSourceWithContent:content selectionPath:path]];
}

+ (ListVC *)listViewControllerWithDataSource:(ListDataSource *)dataSource {
    return [[self alloc] initWithDataSource:dataSource];
}

+ (ListVC *)listViewControllerWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path {
    return [[self alloc] initWithDataSource:[ListDataSource dataSourceWithContent:content selectionPath:path]];
}

+ (EntityListDataSource *)dataSourceWithPredicate:(NSPredicate *)predicate {
    return [[EntityListDataSource alloc] initWithManagedObjectContext:[UIApplication modelManager].context
                                                           entityName:[self entityName]
                                                            predicate:predicate];
}

+ (EntityListDataSource *)dataSource {
    return [self dataSourceWithPredicate:nil];
}

+ (ListVC *)entityListWithPredicate:(NSPredicate *)predicate {

    ListVC *list = [self listViewControllerWithDataSource:[self dataSourceWithPredicate:predicate]];

    // a default detail view controller will not be properly configured
//    list.selectionBlock = ^(NSManagedObject *object) {
//        return [object detailViewController];
//    };
    
    return list;
}

+ (ListVC *)entityList {
    return [self entityListWithPredicate:nil];
}

+ (NSString *)entityName { return nil; }


#pragma mark - Actions
- (IBAction)edit:(id)sender {
    
    BOOL editing = !self.editing;
    
    self.editing = editing;
    self.dataSource.editing = editing;

    [self.tableView beginUpdates];
    [self.tableView setEditing:editing animated:YES];
    
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
