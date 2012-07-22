//
//  DashboardVC.m
//  Thrint
//
//  Created by Brent Gulanowski on 11-11-22.
//  Copyright (c) 2011 Bored Astronaut. All rights reserved.
//

#import "DashboardVC.h"

@implementation DashboardVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)loadView {
    
    CGRect frame = [self.navigationController.view bounds];
    CGSize navBarSize = self.navigationController.navigationBar.frame.size;
    
    frame.size.height -= navBarSize.height;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.opaque = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    frame = CGRectInset(frame, 16, 16);
    
    UIFont *font = [UIFont boldSystemFontOfSize:24];
    NSString *text = @"Dashboard";
        
    frame = CGRectOffset(frame, frame.size.width*0.5f, frame.size.height*0.5f);
    frame.size = [text sizeWithFont:font];
    frame = CGRectOffset(frame, -ceilf((frame.size.width+1)*0.5f), -ceilf((frame.size.height+1)*0.5f));
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;

    [self.view addSubview:label];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
