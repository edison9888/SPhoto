//
//  SViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SViewController.h"


@implementation STitleLabel

- (void) setText:(NSString *) text {
    [super setText:text];
    [super sizeToFit];
    if (self.width > 204) {
        self.width = 204;
    }
}

@end

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
    _titleLabel = [[STitleLabel alloc] initWithFrame:CGRectMake(58, 0, 204, 46)];
    _titleLabel.font = UIFontWithName(kFontNameHelveticaBold, 18.0f);
    _titleLabel.textColor = UIColorWithRGB(0x1D7FBB);
    _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = _titleLabel;

}

- (void)viewDidUnload {
    [super viewDidUnload];
    _titleLabel = nil;
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated {
    if (!self.titleLabel.text) {
        self.titleLabel.text = self.navigationItem.title;
    }
}
- (void) layoutWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientatio {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
