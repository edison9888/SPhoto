//
//  STabBarController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#define kPortraitHeight 63.0
#define kLandscapeHeight 63.0

#define kButtonPortraitHeight 63.0
#define kButtonLandscapeHeight 63.0

#define kCoreButtonPortraitWidth 59.0
#define kCoreButtonPortraitHeight 59.0
#define kCoreButtonLandscapeWidth 59.0
#define kCoreButtonLandscapeHeight 59.0

#import "STabBarController.h"
#import "SNavigationController.h"
#import "SImageViewController.h"
#import "ShoppingViewController.h"
#import "SCaremaViewController.h"
#import "SConfigViewController.h"
#import "SMailViewController.h"


@implementation STabBarController

@synthesize tabBarHidden = _tabBarHidden;


- (id) init {
    self = [super init];
    if (self) {
        
        
        UIViewController * viewController1, * viewController2, *viewController4, * viewController5;
        SNavigationController * navigationBar1, * navigationBar2, * navigationBar4, * navigationBar5;
        
        
        viewController1 = [SImageViewController new];
        navigationBar1 = [[SNavigationController alloc] initWithRootViewController:viewController1];
        navigationBar1.delegate = self;
        
        viewController2 = [[ShoppingViewController alloc] init];
        navigationBar2 = [[SNavigationController alloc] initWithRootViewController:viewController2];
        navigationBar2.delegate = self;
        
        viewController4 = [[SConfigViewController alloc] init];
        navigationBar4 = [[SNavigationController alloc] initWithRootViewController:viewController4];
        navigationBar4.delegate = self;
        
        viewController5 = [[SMailViewController alloc] init];
        navigationBar5 = [[SNavigationController alloc] initWithRootViewController:viewController5];
        navigationBar5.delegate = self;
        
        self.viewControllers = [NSArray arrayWithObjects:navigationBar1, navigationBar2, navigationBar4, navigationBar5, nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 426, 320, 54)];
    _tabBarView.backgroundColor = [UIColor clearColor];
    
    UIImageView * bkgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar.png"]];
    bkgImageView.frame = CGRectMake(0, -20, 320, 72);
    [_tabBarView addSubview:bkgImageView];
    [self.view addSubview:_tabBarView];
    

    UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    imageBtn.frame = CGRectMake(0, 6, 64, 48);
    imageBtn.tag = 0;
    [imageBtn addTarget:self
               action:@selector(onClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:imageBtn];
    
    UIButton * shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopBtn setImage:[UIImage imageNamed:@"shop"] forState:UIControlStateNormal];
    shopBtn.frame = CGRectMake(64, 6,64 , 48);
    shopBtn.tag = 1;
    [shopBtn addTarget:self
                 action:@selector(onClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:shopBtn];
    
    UIButton * photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    photoBtn.frame = CGRectMake(128, -20, 64, 72);
    photoBtn.tag = 10;
    [photoBtn addTarget:self
                 action:@selector(onClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:photoBtn];
    
    UIButton * configBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [configBtn setImage:[UIImage imageNamed:@"config"] forState:UIControlStateNormal];
    configBtn.frame = CGRectMake(192, 6, 64, 48);
    configBtn.tag = 2;
    [configBtn addTarget:self
                 action:@selector(onClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:configBtn];
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(256, 6, 64, 48);
    sendBtn.tag = 3;
    [sendBtn addTarget:self
                 action:@selector(onClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:sendBtn];
    
    [self selectTab:0];
    self.selectedIndex = 0;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _tabBarView = nil;
}

- (void) selectTab : (int) index {
    self.selectedIndex = index;
}

- (void) onClicked : (id) sender {
    
    int tag = [sender tag];
    if (tag == 10) {
        [[SPhotoManager sharedPhotoManager] show];
        
//        SCaremaViewController * viewController = [SCaremaViewController new];
//        [self.selectedViewController presentModalViewController:viewController animated:YES];
        return;
    }
    if (self.selectedIndex == tag) {
        return;
    }
    
    [self selectTab :tag];
    
}

- (void) setTabBarHidden:(BOOL) tabBarHidden {
    [self setTabBarHidden:tabBarHidden animated:NO];
}

- (void) setTabBarHidden:(BOOL) tabBarHidden animated:(BOOL) animated {
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
    }
    self.tabBar.hidden = tabBarHidden;
    CGRect frame = _tabBarView.frame;
    CGFloat height;
    if(tabBarHidden)
        height = 480.0-frame.size.height+72;
    else
        height = 480.0-frame.size.height;
    frame.origin.y = height;
    
    _tabBarView.frame = frame;
    for (UIView * view in self.view.subviews) {
        CGRect frame = view.frame;
        if (frame.size.height>400) {
            frame.size.height = height;
            view.frame = frame;
        }
    }
    if(animated)
        [UIView commitAnimations];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.tabBar.hidden = YES;
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
    }
    
    CGRect frame = _tabBarView.frame;
    
    if(viewController.hidesBottomBarWhenPushed)
        frame.origin.y = 480.0-frame.size.height+70;
    else
        frame.origin.y = 480.0-frame.size.height;
    
    _tabBarView.frame = frame;
    
    if(animated)
        [UIView commitAnimations];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    self.tabBar.hidden = YES;
}




@end
