//
//  ListDataSource.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-28.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef BOOL (^DeletePreparation)(NSManagedObject *object);
typedef void (^InsertCompletion)(NSManagedObject *object);


@protocol ListDataSourceDelegate;

@interface ListDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy) InsertCompletion insertCompletion;
@property (nonatomic, copy) DeletePreparation deletePreparation;

@property (nonatomic, weak) UIViewController<ListDataSourceDelegate> *delegate;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id selection;

@property (nonatomic, strong) NSArray *content;
@property (nonatomic, copy) NSIndexPath *selectionPath;

@property (nonatomic, readonly) NSMutableArray *mutableContent;

@property (nonatomic) BOOL showSubtitle; // defaults to YES
@property (nonatomic, getter = isEditing) BOOL editing; // show the "add item" fake list item

- (id)objectAtIndexPath:(NSIndexPath *)path;
- (NSInteger)indexForInsertedObject:(id)object;
- (NSIndexPath *)indexPathForObject:(id)object inSection:(NSUInteger)section;

// default imps do nothing
- (void)reloadContent;
- (id)insertObject; // if delegate implements, will forward
- (BOOL)deleteObject:(id)object;

- (id)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView;

- (id)insertObjectAtIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView;
- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView;

- (id)initWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path;
+ (ListDataSource *)dataSourceWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path;

@end

@protocol ListDataSourceDelegate <NSObject>
- (void)listDataSourceDidReload:(ListDataSource *)dataSource;
- (BOOL)dataSourceAllowsEditing:(ListDataSource *)dataSource;
@optional
- (id)insertObject;
- (void)didInsertObject:(id)object;
@end
