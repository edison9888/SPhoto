//
//  SViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SViewController.h"

@interface SViewController ()

@end

@implementation SViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) layoutWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientatio {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end