//
//  THRListViewController.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-23.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THRList;

@interface THRListViewController : UIViewController

@property (nonatomic, strong) THRList *list;

- (instancetype)initWithList:(THRList *)list NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithItems:(NSArray *)items;
+ (instancetype)listViewControllerWithList:(THRList *)list;

@end
