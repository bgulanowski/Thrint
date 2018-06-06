//
//  Thrint.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "THRDataManager.h"

#import "ListVC.h"
#import "ThrintKit.h"
#import "ThrintTableViewController.h"

#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>


@implementation THRDataManager {
    dispatch_once_t _thrintStoryBoardToken;
}

#pragma mark - Accessors
- (void)setDelegate:(id<ThrintDelegate>)delegate {
    if(delegate != _delegate) {
        _delegate = delegate;
        _delegateTitles = [delegate respondsToSelector:@selector(titleForEntity:)];
        _delegateImages = [delegate respondsToSelector:@selector(imageNameForEntity:)];
    }
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    UIViewController *detail = [(UINavigationController *)[svc.viewControllers lastObject] topViewController];
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        detail.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }
    else if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        detail.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - New

- (id)initWithStoreURL:(NSURL *)url rootEntityNames:(NSArray *)entityNames {
    self = [super initWithStoreURL:url];
    if(self) {
        _rootEntityNames = entityNames ?: self.context.entityNames;
        NSBundle *bundle = [NSBundle bundleForClass:[THRDataManager class]];
        _thrintStoryboard = [UIStoryboard storyboardWithName:[[self class] storyboardName] bundle:bundle];
        [self.context makeActive];
    }
    return self;
}

- (id)initWithStoreURL:(NSURL *)url {
    return [self initWithStoreURL:url rootEntityNames:nil];
}

- (ListVC *)configureListViewController:(ListVC *)listVC forEntityNamed:(NSString *)entityName {
    
    NSString *title = [self titleForEntityNamed:entityName];
    UIImage *image = [self imageForEntityNamed:entityName];
    
    listVC.navigationItem.title = title;
    listVC.allowEditing = YES;
    listVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:101 + [_rootEntityNames indexOfObject:entityName]];
    listVC.dataSource = [[EntityListDataSource alloc] initWithManagedObjectContext:self.context entityName:entityName predicate:nil];

    return listVC;
}

- (NSString *)titleForEntityNamed:(NSString *)entityName {
    return [self delegateTitleForEntityNamed:entityName] ?: entityName;
}

- (NSString *)delegateTitleForEntityNamed:(NSString *)entityName {
    return _delegateTitles ? [_delegate titleForEntity:entityName] : entityName;
}

- (UIImage *)imageForEntityNamed:(NSString *)entityName {
    return _delegateImages ? [UIImage imageNamed:[_delegate imageNameForEntity:entityName]] : nil;;
}

- (UISplitViewController *)splitViewControllerForEntityNamed:(NSString *)entityName {
    
    UISplitViewController *svc = (UISplitViewController *)[self.thrintStoryboard instantiateInitialViewController];
    UINavigationController *nav = (UINavigationController *)[svc viewControllers][0];
    
    ListVC *listVC = (ListVC *)[nav topViewController];
    [self configureListViewController:listVC forEntityNamed:entityName];
    
    if (svc.displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        UIViewController *secondary = [(UINavigationController *)svc.viewControllers[1] topViewController];
        secondary.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }

    svc.tabBarItem = listVC.tabBarItem;
    listVC.tabBarItem = nil;
    
    svc.delegate = self;
    
    return svc;
}

- (ListVC *)listViewControllerForEntityNamed:(NSString *)entityName {
    
    NSString *className = [entityName stringByAppendingString:@"ListVC"];
    Class listVCClass = NSClassFromString(className) ?: [ListVC class];
    
    ListVC *listVC = [[listVCClass alloc] initWithDataSource:[self dataSourceForEntityNamed:entityName]];
    
    return [self configureListViewController:listVC forEntityNamed:entityName];
}

- (EntityListDataSource *)dataSourceForEntityNamed:(NSString *)entityName {
    return [[EntityListDataSource alloc] initWithManagedObjectContext:self.context entityName:entityName predicate:nil];
}

- (UITabBarController *)rootTabBarController {
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    BOOL iPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    
    for(NSString *entityName in _rootEntityNames) {
        
        UIViewController *vc;
        
        if(iPhone)
            vc = [[UINavigationController alloc] initWithRootViewController:[self listViewControllerForEntityNamed:entityName]];
        else
            vc = [self splitViewControllerForEntityNamed:entityName];
        [tbc addChildViewController:vc];
    }
    
    return tbc;
}

- (void)installRootTabBarInWindow {
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *rvc = [window rootViewController];
    UITabBarController *tbc;
    
    if([rvc isKindOfClass:[UITabBarController class]])
        tbc = (UITabBarController *)rvc;
    else
        tbc = [self rootTabBarController];
    
    window.rootViewController = tbc;
}

- (UITableViewController *)rootTableViewController {
    
    ThrintTableViewController *vc = [[ThrintTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    vc.thrint = self;
    vc.entityNames = _rootEntityNames;
    vc.navigationItem.title = @"Entities";
    
    return vc;
}

- (UIViewController *)rootViewController {
    if([_rootEntityNames count] < 5)
        return [self rootTabBarController];
    
    return [[UINavigationController alloc] initWithRootViewController:[self rootTableViewController]];
}

+ (NSString *)fileSuffixForDevice {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? @"ipad" : @"iphone";
}

+ (NSString *)storyboardName {
    return [NSString stringWithFormat:@"EntityBrowser~%@", [self fileSuffixForDevice]];
}

@end
