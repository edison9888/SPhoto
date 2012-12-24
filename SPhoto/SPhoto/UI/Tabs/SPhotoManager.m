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
@property (nonatomic, strong) SCaremaViewController * rootViewController;

- (void) loadCaremaView;

- (void) caremaViewWillAppear;

- (void) caremaViewDidAppear;

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
    }
    return self;
}

- (SWindow *) window {
    if (!_window) {
        _window = [[SWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor clearColor];
        _window.windowLevel = UIWindowLevelStatusBar;
    }
    return _window;
}

- (SCaremaViewController *) rootViewController {
    if (!_rootViewController) {
        _rootViewController = [SCaremaViewController new];
    }
    return _rootViewController;
}

- (void) loadCaremaView {
    self.window.alpha = 0;
    self.window.rootViewController = self.rootViewController;
    [_window makeKeyAndVisible];
}

- (void) caremaViewWillAppear {
    self.window.alpha = 1.0f;
}

- (void) caremaViewDidAppear {
}

- (void) show {
    [self loadCaremaView];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = self.duration;
    animation.removedOnCompletion = YES;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cameraIris";
    [self.window.layer addAnimation:animation forKey:nil];
    [self performSelector:@selector(caremaViewWillAppear) withObject:nil afterDelay:self.duration/2];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self caremaViewDidAppear];
}

@end
