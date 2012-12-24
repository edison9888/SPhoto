//
//  SPhotoManager.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-23.
//
//

#import "SWindow.h"
#import "SCaremaViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SPhotoManager : NSObject

+ (id) sharedPhotoManager;

- (void) show;

@end
