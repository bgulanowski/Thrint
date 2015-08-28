//
//  THRList+THRTableDataProviding.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-16.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import "THRList.h"

@protocol THRViewList <THRList, UITableViewDataSource>
@end


@interface THRList (THRTableDataProviding)<THRViewList>
@end
