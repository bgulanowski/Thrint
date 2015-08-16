//
//  THRPropertyList+THRTableDataProviding.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <ThrintKit/ThrintKit.h>

@interface THRPropertyList (THRTableDataProviding)<UITableViewDataSource>
@end

@interface UITableViewCell (THRTableDataProviding)
- (void)configureWithProperty:(THRProperty *)property;
@end

@interface THRProperty (THRTableDataProviding)
@end
