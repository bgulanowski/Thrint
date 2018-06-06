//
//  Thrint.h
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BAFoundation/BACoreDataManager.h>

#import <Thrint/ListVC.h>
#import <Thrint/DetailVC.h>
#import <Thrint/ThrintTableViewController.h>


@protocol ThrintDelegate <NSObject>

@optional
- (NSString *)titleForEntity:(NSString *)entityName;
- (NSString *)imageNameForEntity:(NSString *)entityName;

@end


@interface Thrint : BACoreDataManager<UISplitViewControllerDelegate> {
    BOOL _delegateTitles;
    BOOL _delegateImages;
}

@property (nonatomic, weak) id<ThrintDelegate> delegate;

@property (nonatomic, strong) NSArray *rootEntityNames;
@property (nonatomic, strong) UIStoryboard *thrintStoryboard;
@property (nonatomic, readonly) UIViewController *rootViewController;

- (UIViewController *)listViewControllerForEntityNamed:(NSString *)entityName;
- (UISplitViewController *)splitViewControllerForEntityNamed:(NSString *)entityName;

+ (NSString *)fileSuffixForDevice;
+ (NSString *)storyboardName;

// if entityNames is nil/empty, uses all entity names found in the model
- (id)initWithStoreURL:(NSURL *)url rootEntityNames:(NSArray *)entityNames;
- (id)initWithStoreURL:(NSURL *)url;

- (UITabBarController *)rootTabBarController;
- (UITableViewController *)rootTableViewController;
- (UIViewController *)rootViewController;

- (void)installRootTabBarInWindow;

@end
