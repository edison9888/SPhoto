//
//  SCaremaViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "../Utility/SProgressHUD.h"
#import "SCaremaSDK.h"
// =========== filters
#import "../Filter/SSwirlFilter.h"
#import "../Filter/SSphereRefractionFilter.h"
#import "../Filter/SSketchFilter.h"


@interface SCaremaViewController : UIViewController<GPUImageVideoCameraDelegate> {
    GPUImageView * _cameraView;
//    SSwirlFilter * _swirlFilter;
    GPUImageVideoCamera * _camera;
    GPUImageFilterPipeline * _filterPipeline;
}
@end
