//
//  THRList+THRTableDataProviding.m
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRList+THRTableDataProviding.h"

#import "NSObject+ThrintAdditions.h"

@implementation THRList (THRTableDataProviding)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self countOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self objectInItemsAtIndex:indexPath.row] cellForTableView:tableView];
}

@end
