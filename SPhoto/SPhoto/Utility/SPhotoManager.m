//
//  SPhotoManager.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-23.
//
//

#import "SPhotoManager.h"

@interface SPhotoManager ()
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, strong) SWindow * window;
@property (nonatomic, strong) UIViewController * rootViewController;

@property (nonatomic, strong) CATransition * transition;

- (void) loadCameraView;

- (void) cameraViewWillAppear;

- (void) cameraViewDidAppear;

- (void) unloadCameraView;

- (void) cameraViewWillDisappear;

- (void) cameraViewDidDisappear;

@end

static SPhotoManager * _sharedPhotoManager;

@implementation SPhotoManager

+ (id) sharedPhotoManager {
    @synchronized(_sharedPhotoManager){
        if (!_sharedPhotoManager) {
            _sharedPhotoManager = [SPhotoManager new];
        }
        return _sharedPhotoManager;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        self.duration = 1.0f;
        self.visible = NO;
    }
    return self;
}

- (SWindow *) window {
    if (!_window) {
        _window = [[SWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor blackColor];
        _window.windowLevel = UIWindowLevelStatusBar;
        [self.window makeKeyAndVisible];
    }
    return _window;
}

- (UIViewController *) rootViewController {
    if (!_rootViewController) {
        UIViewController * cameraViewController = [SCaremaViewController new];
        cameraViewController.wantsFullScreenLayout = YES;
        _rootViewController = [[SNavigationController alloc] initWithRootViewController:cameraViewController];
        _rootViewController.wantsFullScreenLayout = YES;
        self.window.rootViewController = _rootViewController;
    }
    return _rootViewController;
}

- (void) loadCameraView {
    self.window.alpha = 0.0f;
    self.rootViewController.view.alpha = 0.0f;
}

- (void) cameraViewWillAppear {
    self.window.alpha = 1.0f;
    self.rootViewController.view.alpha = 1.0f;
    self.visible = YES;
}

- (void) cameraViewDidAppear {
}

- (void) show {
    [self loadCameraView];
    self.transition = [CATransition animation];
    self.transition.delegate = self;
    self.transition.duration = self.duration;
    self.transition.removedOnCompletion = YES;
    self.transition.timingFunction = UIViewAnimationCurveEaseInOut;
    self.transition.type = @"cameraIris";
    [self.window.layer addAnimation:self.transition forKey:nil];
    [self performSelector:@selector(cameraViewWillAppear) withObject:nil afterDelay:self.duration/2];
}


- (void) unloadCameraView {
    self.window.alpha = 1.0f;
    self.rootViewController.view.alpha = 1.0f;
}

- (void) cameraViewWillDisappear {
    self.window.alpha = 0.0f;
    self.rootViewController.view.alpha = 0.0f;
    self.visible = NO;
}

- (void) cameraViewDidDisappear {
    self.rootViewController = nil;
    self.window.rootViewController = nil;
    self.window = nil;
    self.transition = nil;
    self.transition = nil;
}

- (void) hide {
    
    [self unloadCameraView];
    self.transition = [CATransition animation];
    
    self.transition.delegate = self;
    self.transition.duration = self.duration;
    self.transition.removedOnCompletion = YES;
    self.transition.timingFunction = UIViewAnimationCurveEaseInOut;
    self.transition.type = @"cameraIris";
    [self.window.layer addAnimation:self.transition forKey:nil];
    [self performSelector:@selector(cameraViewWillDisappear) withObject:nil afterDelay:self.duration/2];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.visible) {
        [self cameraViewDidAppear];
    } else {
        [self cameraViewDidDisappear];
    }
}

@end
