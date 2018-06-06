//
//  ListVC.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-18.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EntityListDataSource.h"


// returning a view controller is optional; if provided, will be pushed onto navigation stack
typedef UIViewController * (^SelectionBlock)(id object);


@class ListDataSource, EntityListDataSource;

@interface ListVC : UITableViewController<ListDataSourceDelegate>

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, weak) id selection;

@property (nonatomic, strong) ListDataSource *dataSource;

@property (nonatomic, copy) SelectionBlock selectionBlock;

@property (nonatomic) BOOL allowEditing;

- (id)initWithDataSource:(ListDataSource *)dataSource;

- (UIViewController *)viewControllerForIndexPath:(NSIndexPath *)indexPath;
- (id)initWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path;

+ (ListVC *)listViewControllerWithDataSource:(ListDataSource *)dataSource;
+ (ListVC *)listViewControllerWithContent:(NSArray *)content selectionPath:(NSIndexPath *)path;

+ (NSString *)entityName;

+ (ListVC *)entityListWithPredicate:(NSPredicate *)predicate;
+ (ListVC *)entityList;

+ (EntityListDataSource *)dataSourceWithPredicate:(NSPredicate *)predicate;
+ (EntityListDataSource *)dataSource;

- (IBAction)edit:(id)sender;

@end
