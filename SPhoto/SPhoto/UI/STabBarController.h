//
//  STabBarController.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STabBarController : UITabBarController <UINavigationControllerDelegate> {
    UIView * _tabBarView;
}

@property (nonatomic, assign, getter = isTabBarHidden) BOOL tabBarHidden;


@end
