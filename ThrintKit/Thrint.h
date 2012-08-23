//
//  Thrint.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ThrintKit/NSManagedObject+BAAdditions.h>
#import <ThrintKit/NSManagedObjectContext+BAAdditions.h>
#import <ThrintKit/NSManagedObject+ViewAdditions.h>

#import <ThrintKit/BACoreDataManager.h>
#import <ThrintKit/ListVC.h>
#import <ThrintKit/DetailVC.h>
#import <ThrintKit/ThrintTableViewController.h>


@protocol ThrintDelegate <NSObject>

@optional
- (NSString *)titleForEntity:(NSString *)entityName;
- (NSString *)imageNameForEntity:(NSString *)entityName;

@end


@interface Thrint : BACoreDataManager<UISplitViewControllerDelegate> {
    BOOL _delegateTitles;
    BOOL _delegateImages;
}

@property (nonatomic, assign) id<ThrintDelegate> delegate;

@property (nonatomic, retain) NSArray *rootEntityNames;
@property (nonatomic, readonly) UIViewController *rootViewController;

- (UIViewController *)listViewControllerForEntityNamed:(NSString *)entityName;
- (UISplitViewController *)splitViewControllerForEntityNamed:(NSString *)entityName;

+ (UIStoryboard *)splitViewStoryboard;

// if entityNames is nil/empty, uses all entity names found in the model
- (id)initWithStoreURL:(NSURL *)url rootEntityNames:(NSArray *)entityNames;
- (id)initWithStoreURL:(NSURL *)url;

- (UITabBarController *)rootTabBarController;
- (UITableViewController *)rootTableViewController;
- (UIViewController *)rootViewController;

- (void)installRootTabBarInWindow;

@end
