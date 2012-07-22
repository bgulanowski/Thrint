//
//  EntityListVC.h
//  

//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ObjectDetailVC.h"


extern NSString *kManagedObjectContextRequestNotificationName;


@interface ObjectListVC : UITableViewController {
    NSMutableArray *_content;
}

@property (nonatomic, weak)   UIPopoverController *popOver;

@property (nonatomic, weak)   NSManagedObjectContext *context;

@property (nonatomic, strong) NSMutableSet *selection;
@property (nonatomic, copy)   NSArray *content;
@property (nonatomic, strong) NSString *entityName;

@property (nonatomic) NSUInteger minSelection;
@property (nonatomic) NSUInteger maxSelection;
@property (nonatomic) NSUInteger selectedIndex;

- (NSManagedObject *)insertObjectAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)edit:(id)sender;

@end
