//
//  THRListViewController.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-23.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRListViewController.h"
#import "THRList.h"

@interface THRListViewController ()<UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@end

@implementation THRListViewController

#pragma mark - Initialization

- (instancetype)initWithList:(id<THRList>)list {
    if ((self = [super init])) {
        _list = list;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    return [self initWithList:[THRList listWithItems:items]];
}

+ (instancetype)listViewControllerWithList:(id<THRList>)list {
    return [[self alloc] initWithList:list];
}

#pragma mark - Accessors

- (UITableView *)tableView {
    return (UITableView *)self.view;
}

- (void)setTableView:(UITableView *)tableView {
    self.view = tableView;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    self.tableView.dataSource = self.list;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
