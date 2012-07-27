//
//  ListDataSource.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ListDataSourceDelegate;

@interface ListDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, assign) UIViewController<ListDataSourceDelegate> *delegate;
@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, copy) NSIndexPath *selectionPath;

@property (nonatomic, assign) id selection;
@property (nonatomic) BOOL showSubtitle; // defaults to YES
@property (nonatomic, getter = isEditing) BOOL editing; // show the "add item" fake list item

- (id)objectAtIndexPath:(NSIndexPath *)path;
- (NSInteger)indexForInsertedObject:(id)object;
- (NSIndexPath *)indexPathForObject:(id)object inSection:(NSUInteger)section;

// default imps do nothing
- (void)reloadContent;
- (id)insertObject; // if delegate implements, will forward
- (BOOL)deleteObject:(id)object;

- (void)insertObjectAtIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView;
- (void)insertObject:(id)object inSection:(NSUInteger)section updateTableView:(UITableView *)tableView;
- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView;
- (void)deleteObject:(id)object inSection:(NSUInteger)section updateTableView:(UITableView *)tableView;

- (id)initWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path;
+ (ListDataSource *)dataSourceWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path;

@end

@protocol ListDataSourceDelegate <NSObject>
- (void)listDataSourceDidReload:(ListDataSource *)dataSource;
- (BOOL)dataSourceAllowsEditing:(ListDataSource *)dataSource;
@optional
- (id)insertObject;
@end

@interface NSObject (ListRepresentation)
- (NSString *)listString;
- (UITableViewCell *)cellForTableView:(UITableView *)tableView;
@end