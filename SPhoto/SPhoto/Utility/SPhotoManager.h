//
//  SPhotoManager.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-23.
//
//

#import "SWindow.h"
#import "SCaremaViewController.h"
#import "SNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface SPhotoManager : NSObject

@property (nonatomic, assign) BOOL visible;

+ (id) sharedPhotoManager;

- (void) show;

- (void) hide;
@end
