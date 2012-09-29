//
//  ListDataSource.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "ListDataSource.h"

#import "TextAttributeCell.h"
#import "NSManagedObject+ViewAdditions.h"
#import "NSObject+ThrintAdditions.h"


@interface ListDataSource ()
@property (nonatomic) BOOL delegateInserts;
@end


@implementation ListDataSource

@synthesize delegate=_delegate;
@synthesize content=_content;
@synthesize selectionPath=_selectionPath;
@synthesize delegateInserts=_delegateInserts;
@synthesize showSubtitle=_showSubtitle;
@synthesize editing = _editing;

#pragma mark - Accessors
- (void)setContent:(NSArray *)array {
    if(![_content isEqual:array]) {
        _content = [array mutableCopy];
        if(_content)
            [_delegate listDataSourceDidReload:self];
    }
}

- (NSMutableArray *)content {
    if (!_content)
        [self reloadContent];
    return _content;
}

- (void)setDelegate:(UIViewController<ListDataSourceDelegate> *)delegate {
    if(![delegate isEqual:_delegate]) {
        _delegate = delegate;
        _delegateInserts = [delegate respondsToSelector:@selector(insertObject)];
    }
}

- (id)selection {
    return _selectionPath ? [self objectAtIndexPath:_selectionPath] : nil;
}

- (void)setSelection:(id)selection {
    NSUInteger index = [self.content indexOfObject:selection];
    self.selectionPath = (NSNotFound == index) ? nil : [NSIndexPath indexPathForRow:index inSection:0];
}


#pragma mark - Designated Initializer
- (id)initWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path {
    self = [self init];
    if(self) {
        self.content = [NSMutableArray arrayWithArray:content];
        self.selectionPath = path;
    }
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content count] + (int)(self.editing && [self.delegate dataSourceAllowsEditing:self]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];    
    UITableViewCell *cell;
    
    if(row < [self.content count]) {
        
        id object = [self.content objectAtIndex:row];

        cell = _showSubtitle ? [object subtitleCellForTableView:tableView] :[object cellForTableView:tableView];
        if(_selectionPath) {
            if([indexPath isEqual:_selectionPath])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = NSLocalizedString(@"add_new_", @"");
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [_delegate dataSourceAllowsEditing:self];
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert)
        [self insertObjectAtIndexPath:indexPath updateTableView:tableView];
    else if (editingStyle == UITableViewCellEditingStyleDelete)
        [self deleteObjectAtIndexPath:indexPath updateTableView:tableView];
}


#pragma mark - New

- (void)reloadContent {}
- (id)insertObject { return _delegateInserts ? [_delegate insertObject] : nil; }
- (BOOL)deleteObject:(id)object { return NO; }

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView {
    
    // Index path might change, so track the object and update index path later
    id selection = [self selection];
    
    [tableView beginUpdates];
    [_content insertObject:object atIndex:[indexPath row]];
    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
    
    
    if(selection) {
        
        NSIndexPath *pathForOldSelection = [self indexPathForObject:selection inSection:[indexPath section]];
        
        // They should ALWAYS be different
        if(![pathForOldSelection isEqual:indexPath]) {
            
            NSArray *selections = [NSArray arrayWithObjects:[self indexPathForObject:selection inSection:[indexPath section]], indexPath, nil];
            
            self.selectionPath = indexPath;
            [tableView reloadRowsAtIndexPaths:selections withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)insertObjectAtIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView {
    [self insertObject:[self insertObject] atIndexPath:indexPath updateTableView:tableView];
}

- (void)insertObject:(id)object inSection:(NSUInteger)section updateTableView:(UITableView *)tableView {
    [self insertObject:object atIndexPath:[self indexPathForObject:object inSection:section] updateTableView:tableView];
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView {
    
    NSUInteger row = [indexPath row];
    
    if(![self deleteObject:[_content objectAtIndex:row]]) return;
    
    [_content removeObjectAtIndex:row];

    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (void)deleteObject:(id)object inSection:(NSUInteger)section updateTableView:(UITableView *)tableView {
    [self deleteObjectAtIndexPath:[self indexPathForObject:object inSection:section] updateTableView:tableView];
}

- (id)objectAtIndexPath:(NSIndexPath *)path {
    return [_content objectAtIndex:[path row]];
}

- (NSInteger)indexForInsertedObject:(id)object {
    return [_content count];
}

- (NSIndexPath *)indexPathForObject:(id)object inSection:(NSUInteger)section {

    NSUInteger index = [_content indexOfObject:object];
    
    if(NSNotFound == index) index = [self indexForInsertedObject:object];
    
    return [NSIndexPath indexPathForRow:index inSection:section];
}

+ (ListDataSource *)dataSourceWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path {
    return [[self alloc] initWithContent:content selectionPath:path];
}

@end
