//
//  THRListViewController.h
//  Thrint
//
//  Created by Brent Gulanowski on 2015-08-23.
//  Copyright (c) 2015 Lichen Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THRViewList;

@interface THRListViewController : UIViewController

@property (nonatomic, strong) NSObject<THRViewList> *list;

- (instancetype)initWithList:(NSObject<THRViewList> *)list NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithItems:(NSArray *)items;
+ (instancetype)listViewControllerWithList:(NSObject<THRViewList> *)list;

@end
