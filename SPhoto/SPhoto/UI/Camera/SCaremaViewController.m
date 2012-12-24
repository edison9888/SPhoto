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
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView * functionView;
@property (nonatomic, strong) UIImageView * areaImageView;
@property (nonatomic, assign) BOOL functionVisible;
@property (nonatomic, strong) GPUImageFilter * currentFilter;
@property (nonatomic, strong) UISlider * valueSlider;
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
    UITapGestureRecognizer * cameraGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFunction:)];
    cameraGesture.numberOfTapsRequired = 1;
    cameraGesture.numberOfTouchesRequired = 1;
    [self.cameraView addGestureRecognizer:cameraGesture];
    [self.view addSubview:self.cameraView];
    
    self.functionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)];
    self.origin = CGPointMake(160, 175);
    
    UITapGestureRecognizer * functionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFunction:)];
    functionGesture.numberOfTapsRequired = 1;
    functionGesture.numberOfTouchesRequired = 1;
    [self.functionView addGestureRecognizer:functionGesture];
    self.functionVisible = YES;
    [self.view addSubview:self.functionView];
    
    self.areaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    self.areaImageView.center = CGPointMake(160, 175);
    self.areaImageView.userInteractionEnabled = YES;
    self.areaImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.areaImageView.image = [UIImage imageNamed:@"circle.png"];
    
    UIPinchGestureRecognizer * pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(areaSizeChanged:)];
    [self.areaImageView addGestureRecognizer:pinchGesture];
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(areaCenterChanged:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    [self.areaImageView addGestureRecognizer:panGesture];
    
    [self.functionView addSubview:self.areaImageView];
    
    self.valueSlider = [[UISlider alloc] initWithFrame:CGRectMake(185, 160, 240, 40)];
    UIImage * sliderImage = [[UIImage imageNamed:@"slider_bkg.png"]
                            stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    [self.valueSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    [self.valueSlider setMinimumTrackImage:sliderImage forState:UIControlStateNormal];
    [self.valueSlider setMaximumTrackImage:sliderImage forState:UIControlStateNormal];
    self.valueSlider.transform = CGAffineTransformMakeRotation(- M_PI * 0.5);
    self.valueSlider.hidden = YES;
    [self.valueSlider addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.functionView addSubview:self.valueSlider];
    
    
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
    self.faceButton.frame = CGRectMake(245, 15, 30, 45);
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
    self.valueSlider.hidden = YES;
    self.areaImageView.hidden = YES;
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
            self.areaImageView.hidden = NO;
            [filter setValue:@(-0.95) forKey:@"scale"];
            self.valueSlider.hidden = NO;
            self.valueSlider.minimumValue = -2.0f;
            self.valueSlider.maximumValue = 2.0f;
            self.valueSlider.value = -0.95;
            break;
        case 3:
            filter =[[GPUImageGlassSphereFilter alloc] init];
            self.areaImageView.hidden = NO;
            [filter setValue:@(0.3f) forKey:@"radius"];
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
            self.valueSlider.hidden = NO;
            self.valueSlider.minimumValue = 1;
            self.valueSlider.maximumValue = 360;
            self.valueSlider.value = 90;
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
    self.currentFilter = nil;
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
        self.currentFilter = filter;
    }

}

- (void) showFunction:(id) sender {
    if (self.functionVisible) {
        // TODO:隐藏
        self.functionView.hidden = NO;
        self.functionVisible = NO;
    } else {
        // TODO:显示
        self.functionView.hidden = YES;
        self.functionVisible = YES;
    }
}

- (void) areaSizeChanged:(UIPinchGestureRecognizer *) sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0f;
    }
    
    CGFloat scale = 1.0 - (_lastScale - sender.scale);
    CGFloat maxScale = 320 / self.areaImageView.width;
    CGFloat minScale = 140 / self.areaImageView.width;
    
    if (scale < minScale) {
        scale = minScale;
    }
    
    if (scale > maxScale) {
        scale = maxScale;
    }
    
    CGAffineTransform currentTransform = self.areaImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    self.areaImageView.transform = newTransform;
    _lastScale = [sender scale];
    scale = self.areaImageView.width / self.functionView.width;
//    [self.currentFilter setFloat:scale forUniformName:@"radius"];

}

- (void) areaCenterChanged:(UIPanGestureRecognizer *) sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.origin = self.areaImageView.center;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.functionView];
        CGPoint center = CGPointMake(self.origin.x + translation.x,self.origin.y + translation.y);
        if (center.x < 0) {
            center.x = 0;
        }
        if (center.y < 0) {
            center.y = 0;
        }
        if (center.x > self.functionView.width) {
            center.x = self.functionView.width;
        }
        if (center.y > self.functionView.height) {
            center.y = self.functionView.height;
        }
        self.areaImageView.center = center;
        CGPoint centerRate = CGPointMake(center.y/self.functionView.height, center.x/self.functionView.width);
        [self.currentFilter setPoint:centerRate forUniformName:@"center"];
    }
}
- (void) filterValueChanged:(id) sender {
    [self.currentFilter setFloat:self.valueSlider.value forUniformName:@"scale"];
    [self.currentFilter setFloat:self.valueSlider.value forUniformName:@"hueAdjust"];
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
            
            
            SPostImageItem * imageItem = [SPostImageItem new];
            imageItem.field = @"postcard";
            NSDate * date = [NSDate date];
            NSDateFormatter * format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
            imageItem.name = [format stringFromDate:date];
            imageItem.image = image;
            
            NSDictionary * params = @{
            @"description": @"我的图片真好看",
            @"image":imageItem
            };
            
            [SProgressHUD showWithView:self.view status:@"正在上传" animated:YES];
            SRequest * request = [SRequest requestWithMethod:@"photo/upload.do/" params:params type:SRequestMethodPost];
            [request startWithHandler:^(id result, NSError *error) {
                BOOL success = [[result objectForKey:@"result"] boolValue];
                if (success) {
                    SLog(@"上传成功");
                } else {
                    SLog(@"上传失败");
                }
                [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
            }];
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

- (void) hideHud {
    [SProgressHUD hideHUDForView:self.navigationController.view animated:NO];
}
@end
