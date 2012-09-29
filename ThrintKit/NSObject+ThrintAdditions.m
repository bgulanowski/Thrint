//
//  NSObject+ThrintAdditions.m
//  Thrint
//
//  Created by Brent Gulanowski on 12-09-29.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import "NSObject+ThrintAdditions.h"

@implementation NSObject (ThrintAdditions)

- (NSString *)listString {
    return [self description];
}

- (NSString *)stringRepresentation {
    return [self description];
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
    
    static NSString *CellIdentifier = @"ListDataSourceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [self listString];
    
    return cell;
}

@end
