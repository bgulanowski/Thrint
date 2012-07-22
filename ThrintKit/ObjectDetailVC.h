//
//  ObjectDetailVC.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TextAttributeCell, ObjectListVC;


@interface ObjectDetailVC : UITableViewController

@property (nonatomic, strong) ObjectListVC *relatedList;

@property (nonatomic, strong) NSManagedObject *object;
@property (nonatomic, weak)   UITextField *activeTextField;
@property (nonatomic, strong) NSArray *attributeKeyPaths;
@property (nonatomic, strong) NSArray *relationships;

@end

@interface UITableView (ThrintAdditions)
- (TextAttributeCell *)dequeueReusableCellForObject:(id)object keyPath:(NSString *)keyPath;
@end
