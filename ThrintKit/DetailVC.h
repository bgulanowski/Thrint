//
//  DetailVC.h
//  Thrint
//
//  Created by Brent Gulanowski on 12-03-18.
//  Copyright (c) 2012 Bored Astronaut. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    ActionCancel = 10,
    ActionDelete = 11,
} ActionType;


typedef void (^EndEditingBlock)(void);


@class ListVC;

@interface DetailVC : UITableViewController<UIActionSheetDelegate>

@property (nonatomic, weak) UIViewController *container;

@property (nonatomic, strong) IBOutlet UIView *tableFooterView;
@property (nonatomic, strong) NSManagedObject *object;
@property (nonatomic, strong) NSArray *properties;

@property (nonatomic, copy) EndEditingBlock endEditingBlock;

@property (nonatomic) ActionType action;
@property (nonatomic) BOOL liveEditing; // defaults to NO
@property (nonatomic) BOOL editMode; // defaults to YES

- (id)initWithObject:(NSManagedObject *)object properties:(NSArray *)properties;

+ (DetailVC *)detailViewControllerWithObject:(NSManagedObject *)object properties:(NSArray *)properties;

//- (ListVC *)listViewControllerForProperty:(NSString *)property;

- (void)finalizeEditing;
- (void)cancelConfirmed;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)cancelEdits:(id)sender;
- (IBAction)saveEdits:(id)sender;
- (IBAction)deleteObject:(id)sender;

@end
