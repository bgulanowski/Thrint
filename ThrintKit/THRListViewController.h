//
//  THRListViewController.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-23.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THRList;

@interface THRListViewController : UIViewController

@property (nonatomic, strong) id<THRList> list;

- (instancetype)initWithList:(id<THRList>)list NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithItems:(NSArray *)items;
+ (instancetype)listViewControllerWithList:(id<THRList>)list;

@end
