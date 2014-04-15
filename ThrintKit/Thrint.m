//
//  Thrint.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "Thrint.h"
#import "ListVC.h"
#import "ThrintTableViewController.h"

#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>


@implementation Thrint

@synthesize rootEntityNames=_rootEntityNames, delegate=_delegate;

#pragma mark - Accessors
- (void)setDelegate:(id<ThrintDelegate>)delegate {
    if(delegate != _delegate) {
        _delegate = delegate;
        _delegateTitles = [delegate respondsToSelector:@selector(titleForEntity:)];
        _delegateImages = [delegate respondsToSelector:@selector(imageNameForEntity:)];
    }
}

#pragma mark - UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController*)svc
     willHideViewController:(UINavigationController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem
       forPopoverController:(UIPopoverController*)pc {
    
    UINavigationController *nav = [[svc viewControllers] lastObject];
    
    barButtonItem.title = [aViewController valueForKeyPath:@"topViewController.navigationItem.title"];
    [nav topViewController].navigationItem.leftBarButtonItem = barButtonItem;
    
    [(ListVC *)aViewController.topViewController setPopOver:pc];
}

- (void)splitViewController: (UISplitViewController*)svc
     willShowViewController:(UINavigationController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    UINavigationController *nav = [[svc viewControllers] lastObject];
    
    [nav topViewController].navigationItem.leftBarButtonItem = nil;
    [(ListVC *)aViewController.topViewController setPopOver:nil];
}


#pragma mark - New
- (id)initWithStoreURL:(NSURL *)url rootEntityNames:(NSArray *)entityNames {
    self = [super initWithStoreURL:url];
    if(self) {
        [self.context makeActive];
        self.rootEntityNames = entityNames;
        if(![entityNames count])
            self.rootEntityNames = [[[[self.context persistentStoreCoordinator] managedObjectModel] entitiesByName] allKeys];
    }
    return self;
}

- (id)initWithStoreURL:(NSURL *)url {
    return [self initWithStoreURL:url rootEntityNames:nil];
}

- (ListVC *)configureListViewController:(ListVC *)listVC forEntityNamed:(NSString *)entityName {
    
    NSString *title = _delegateTitles ? [_delegate titleForEntity:entityName] ?: entityName : entityName;
    UIImage *image = _delegateImages ? [UIImage imageNamed:[_delegate imageNameForEntity:entityName]] : nil;
    
    EntityListDataSource *datasource = (EntityListDataSource *)listVC.dataSource;

    datasource.context = self.context;
    datasource.entityName = entityName;
    
    listVC.navigationItem.title = title;
    listVC.allowEditing = YES;
    listVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:101 + [_rootEntityNames indexOfObject:entityName]];
    
    return listVC;
}

- (UISplitViewController *)splitViewControllerForEntityNamed:(NSString *)entityName {
    
    UIStoryboard *storyboard = [[self class] splitViewStoryboard];
    UISplitViewController *svc = (UISplitViewController *)[storyboard instantiateInitialViewController];
    UINavigationController *nav = (UINavigationController *)[[svc viewControllers] objectAtIndex:0];
    ListVC *listVC = (ListVC *)[nav topViewController];
    
    [self configureListViewController:listVC forEntityNamed:entityName];

    svc.tabBarItem = listVC.tabBarItem;
    listVC.tabBarItem = nil;
    
    svc.delegate = self;
    
    return svc;
}

- (ListVC *)listViewControllerForEntityNamed:(NSString *)entityName {
    
    NSString *className = [entityName stringByAppendingString:@"ListVC"];
    Class listVCClass = NSClassFromString(className) ?: [ListVC class];
    ListVC *listVC = [[listVCClass alloc] init];
    
    return [self configureListViewController:listVC forEntityNamed:entityName];
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

+ (UIStoryboard *)splitViewStoryboard {
    
    static UIStoryboard *storyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storyboard = [UIStoryboard storyboardWithName:@"EntityBrowser" bundle:nil];
    });
    
    return storyboard;
}

//
//#pragma mark - NSNotification handlers
//- (void)contextRequestNotification:(NSNotification *)note {
//    [[note object] setContext:self.context];
//}
//
@end
