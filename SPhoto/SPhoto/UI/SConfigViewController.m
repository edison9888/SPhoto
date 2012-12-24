//
//  SConfigViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SConfigViewController.h"

@implementation SConfigViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"设置页面";
    titleLabel.textColor = kTitleColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
