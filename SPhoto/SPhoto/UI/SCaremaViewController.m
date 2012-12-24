//
//  SCaremaViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SCaremaViewController.h"


@implementation SCaremaViewController

- (void) dealloc {
    [_camera stopCameraCapture];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"正在拍照";
        titleLabel.textColor = kTitleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
        
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"正在拍照";
        titleLabel.textColor = kTitleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cameraView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 340)];
    _cameraView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_cameraView];
    
    _camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    SSwirlFilter * swirlFilter = [SSwirlFilter new];
    [_camera addTarget:swirlFilter];
    
//    SSphereRefractionFilter * refractionFilter = [SSphereRefractionFilter new];
//    [_camera addTarget:refractionFilter];
    
    SSketchFilter * sketchFilter = [SSketchFilter new];
    [_camera addTarget:sketchFilter];
    
    _filterPipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:@[swirlFilter,sketchFilter] input:_camera output:_cameraView];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(cameraAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;

}

- (void)viewDidUnload {
    [super viewDidUnload];
    _cameraView = nil;
    _camera = nil;
    _filterPipeline = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_camera startCameraCapture];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_camera stopCameraCapture];
}

- (void) cameraAction:(id) sender {
    UIImage * image = [_filterPipeline currentFilteredFrame];
    if(image) {
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

- (void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        SLog(@"保存照片到相册");
    }
}
@end
