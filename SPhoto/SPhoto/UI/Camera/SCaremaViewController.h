//
//  SCaremaViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

#import "SPhotoManager.h"

#import "SCaremaSDK.h"
#import "SListView.h"
#import "GPUImageView.h"
#import "SRequest.h"
#import "SProgressHUD.h"
#import "SPreviewViewController.h"

#import "GPUImageSketchFilter.h"
#import "GPUImagePinchDistortionFilter.h"
#import "GPUImageSepiaFilter.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageAlphaBlendFilter.h"
#import "GPUImageGlassSphereFilter.h"
#import "GPUImageColorInvertFilter.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageToonFilter.h"
#import "GPUImageHueFilter.h"

@interface SCaremaViewController : SViewController <GPUImageVideoCameraDelegate, SListViewDataSource, SListViewDelegate> {

    CGFloat _lastScale;
    
    NSArray * _sessionPresetArray;
}

@end
