//
//  SCaremaViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCaremaViewController.h"

@interface SCaremaViewController ()

@property (nonatomic, strong) NSMutableArray * filterSampleArray;

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) GPUImageView * cameraView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * photoToolView;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * photoButton;
@property (nonatomic, strong) UIButton * faceButton;


@property (nonatomic, strong) SListView * filterListView;
@property (nonatomic, strong) UIView * filterBkgView;

@property (nonatomic, strong) GPUImageVideoCamera * camera;
@property (nonatomic, strong) GPUImageFilterPipeline * filterPipeline;

@property (nonatomic, strong) NSMutableArray * filterArray;


@end

@implementation SCaremaViewController

- (void) dealloc {
    [_camera stopCameraCapture];
}
- (id) init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        self.filterArray = [NSMutableArray arrayWithCapacity:5];
        self.filterSampleArray = [NSMutableArray arrayWithCapacity:5];
        NSDictionary * normal = @{@"title":@"常规",@"image":@"filter_normal.png"};
        [self.filterSampleArray addObject:normal];
        NSDictionary * sketch = @{@"title":@"素描",@"image":@"filter_sketch.png"};
        [self.filterSampleArray addObject:sketch];
        NSDictionary * pinch = @{@"title":@"胖胖",@"image":@"filter_pinch.png"};
        [self.filterSampleArray addObject:pinch];
        NSDictionary * glass = @{@"title":@"球球",@"image":@"filter_glass.png"};
        [self.filterSampleArray addObject:glass];
        NSDictionary * invert = @{@"title":@"反色",@"image":@"filter_normal.png"};
        [self.filterSampleArray addObject:invert];
        NSDictionary * toon = @{@"title":@"彩绘",@"image":@"filter_sketch.png"};
        [self.filterSampleArray addObject:toon];
        NSDictionary * hue = @{@"title":@"变色",@"image":@"filter_pinch.png"};
        [self.filterSampleArray addObject:hue];
    }
    
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.cameraView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)];
    self.cameraView.fillMode = kGPUImageFillModeStretch;
    [self.view addSubview:self.cameraView];
    
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, 320, 130)];
    [self.view addSubview:self.bottomView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_bkg.png" ]];
    imageView.frame = CGRectMake(0, 0, 320, 130);
    [self.bottomView addSubview:imageView];
    
    self.filterListView = [[SListView alloc] initWithFrame:CGRectMake(0, 0, 320, 82)];
    self.filterListView.delegate = self;
    self.filterListView.dataSource = self;
    [self.bottomView addSubview:self.filterListView];
    [self.filterListView reloadData];
    self.filterListView.selectedIndex = 0;
    
    self.photoToolView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 320, 60)];
    [self.bottomView addSubview:self.photoToolView];
    
    UIImageView * toolBkgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_toolbar.png"]];
    toolBkgImageView.frame = CGRectMake(0, -10, 320, 70);
    [self.photoToolView addSubview:toolBkgImageView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(20, 15, 60, 45);
    [self.cancelButton setImage:[UIImage imageNamed:@"photo_toolbar_cancel.png"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoToolView addSubview:self.cancelButton];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.photoButton setImage:[UIImage imageNamed:@"photo_toolbar_photo.png"] forState:UIControlStateNormal];
    [self.photoButton addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    self.photoButton.contentEdgeInsets = UIEdgeInsetsZero;
    self.photoButton.frame = CGRectMake(130, -14, 60, 70);
    [self.photoToolView addSubview:self.photoButton];
    
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceButton.frame = CGRectMake(250, 15, 40, 45);
    [self.faceButton setImage:[UIImage imageNamed:@"photo_toolbar_change.png"] forState:UIControlStateNormal];
    [self.faceButton addTarget:self action:@selector(changeFaceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoToolView addSubview:self.faceButton];
    
    self.camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    self.filterPipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:@[] input:self.camera output:self.cameraView];

}
- (void) viewDidUnload{
    [super viewDidUnload];
    [_camera stopCameraCapture];
    self.bottomView = nil;
    self.filterBkgView = nil;
    self.filterListView = nil;
    self.photoToolView = nil;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_camera startCameraCapture];
    });
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_camera stopCameraCapture];
}

#pragma mark === SListView DataSource ===


/**
 * @brief 共有多少列
 * @param listView 当前所在的ListView
 */
- (NSInteger) numberOfColumnsInListView:(SListView *) listView {
    return self.filterSampleArray.count;
}

/**
 * @brief 这一列有多宽，根据有多宽，算出需要加载多少个
 * @param index  当前所在列
 */
- (CGFloat) widthForColumnAtIndex:(NSInteger) index {
    return 50.0;
}

/**
 * @brief 每列 显示什么
 * @param listView 当前所在的ListView
 * @param index  当前所在列
 * @return  当前所要展示的页
 */
- (SListViewCell *) listView:(SListView *)listView viewForColumnAtIndex:(NSInteger) index {
    static NSString * listName = @"List_Name";
    SListViewCell * cell = [listView dequeueReusableCellWithIdentifier:listName];
    if (!cell) {
        cell = [[SListViewCell alloc] initWithReuseIdentifier:listName];
    }
    NSDictionary * filter = [self.filterSampleArray objectAtIndex:index];
    cell.filterDictionary = filter;
    return  cell;
}


/**
 * @brief 当前列 被选中的事件
 * @param index  当前所在列
 */
- (void) listView:(SListView *) listView didSelectColumnAtIndex:(NSInteger) index {
    // 选中了某一个滤镜
    GPUImageFilter * filter;
    switch (index) {
        case 0:
            filter = [[GPUImageSaturationFilter alloc] init];
            [filter setValue:@(1.0f) forKey:@"saturation"];
            break;
        case 1:
            filter = [[GPUImageSketchFilter alloc] init];
            break;
        case 2:
            filter = [[GPUImagePinchDistortionFilter alloc] init];
            [filter setValue:@(-0.95) forKey:@"scale"];
            break;
        case 3:
            filter =[[GPUImageGlassSphereFilter alloc] init];
            [filter setValue:@(0.25) forKey:@"radius"];
            break;
        case 4:
            filter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 5:
            filter = [[GPUImageToonFilter alloc] init];
            [filter setValue:@(0.6) forKey:@"threshold"];
            break;
        case 6:
            filter = [[GPUImageHueFilter alloc] init];
            [filter setValue:@(90) forKey:@"hue"];
            break;
        case 7:
            filter = [[GPUImageSaturationFilter alloc] init];
            break;
        default:
            break;
    }
    if (!filter) {
        return;
    }
    [self.camera removeAllTargets];
    [self.filterPipeline removeAllFilters];
    if (filter) {
        [self.filterPipeline addFilter:filter];
        if (index == 3) {
            GPUImageGaussianBlurFilter *gaussianBlur = [[GPUImageGaussianBlurFilter alloc] init];
            [self.camera addTarget:gaussianBlur];
            gaussianBlur.blurSize = 2.0;
            
            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
            blendFilter.mix = 1.0;
            [gaussianBlur addTarget:blendFilter];
            [filter addTarget:blendFilter];
            [blendFilter addTarget:self.cameraView];
        }
    }

}

#pragma mark === Button 点击事件 ===

- (void) changeFaceAction:(id)sender {
    self.faceButton.enabled = NO;
    [UIView transitionWithView:self.cameraView duration:0.45 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        [_camera rotateCamera];
        self.faceButton.enabled = YES;
    }];
}


- (void) cancelAction:(id)sender {
    [[SPhotoManager sharedPhotoManager] hide];
}

- (void) takePhotoAction:(id)sender {
    UIButton * btn = (UIButton *) sender;
    runOnMainQueueWithoutDeadlocking(^{
        btn.enabled = NO;
        UIImage * image = [_filterPipeline currentFilteredFrame];
        if(image) {
            UIImageWriteToSavedPhotosAlbum(image, self,
                                           @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
        btn.enabled = YES;
        
        SPreviewViewController * viewController = [[SPreviewViewController alloc] initWithImage:image];
        [self.navigationController pushViewController:viewController animated:NO];
        
        CATransition * animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        
        animation.type = @"flip";
        animation.subtype = kCATransitionFromRight;
        
        [[viewController.navigationController.view layer] addAnimation:animation forKey:@"animation"];

    });
}

- (void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        SLog(@"保存照片到相册");
    }
}

@end
