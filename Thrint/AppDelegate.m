//
//  AppDelegate.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "AppDelegate.h"

#import "ListVC.h"
#import "DashboardVC.h"
#import "ThrintTableViewController.h"

#import "Component.h"
#import "Developer.h"
#import "Feature.h"
#import "Milestone.h"
#import "Product.h"
#import "ProductNote.h"
#import "Role.h"
#import "Team.h"

#import <BAFoundation/NSManagedObjectContext+BAAdditions.h>


@implementation AppDelegate

@synthesize thrint=_thrint;
@synthesize window = _window;

#pragma mark - Private
- (NSDictionary *)configuration {
    
    static dispatch_once_t onceToken;
    static __strong NSDictionary *configuration;
    
    dispatch_once(&onceToken, ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        
        configuration = [NSPropertyListSerialization propertyListWithData:fileData
                                                                  options:NSPropertyListImmutable
                                                                   format:NULL
                                                                    error:&error];
        if(!configuration)
            NSLog(@"Error %@", error);
        
    });
    
    return configuration;
}


#pragma mark - New
- (void)insertInitialObjects {
    
    NSManagedObjectContext *context = _thrint.context;
    
    Component *component = [context insertComponent];
    Developer *dev = [context insertDeveloper];
    Feature *feature = [context insertFeature];
    Milestone *milestone = [context insertMilestone];
    Product *product = [context insertProduct];
    Role *role = [context insertRole];
    Team *team = [context insertTeam];
    
    [dev addRolesObject:role];
    
    [team addRolesObject:role];
    
    product.team = team;
    component.product = product;
    feature.component = component;
    feature.milestone = milestone;
    
    [_thrint save];
}

- (void)setUpModel {
    
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath = [dirPath stringByAppendingPathComponent:@"thrint.sql"];
    NSArray *names = [[[self configuration] objectForKey:@"entity_tabs"] allKeys];
    
    self.thrint = [[Thrint alloc] initWithStoreURL:[NSURL fileURLWithPath:storePath] rootEntityNames:names];
    _thrint.delegate = self;
    
    if (![_thrint.context countOfEntity:[Team entityName]]) {
        [self insertInitialObjects];
    }
}

- (void)setUpViews {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_thrint installRootTabBarInWindow];
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self setUpModel];
    [self setUpViews];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_thrint.context save:NULL];
}


#pragma mark - BAApplicationDelegateAdditions
- (BACoreDataManager *)modelManager {
    return _thrint;
}


#pragma mark - ThrintDelegate
- (NSString *)titleForEntity:(NSString *)entityName {
    NSDictionary *tableSpec = [[self configuration] objectForKey:@"entity_tabs"];
    return [[tableSpec objectForKey:entityName] objectForKey:@"title"];
}

- (NSString *)imageNameForEntity:(NSString *)entityName {
    NSDictionary *tableSpec = [[self configuration] objectForKey:@"entity_tabs"];
    return [[tableSpec objectForKey:entityName] objectForKey:@"image_name"];
}

@end
