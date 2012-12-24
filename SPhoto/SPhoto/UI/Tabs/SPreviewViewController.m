

//
//  SPreviewViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-9-16.
//
//

#import "SPreviewViewController.h"

@implementation SPreviewViewController

@synthesize image = _image;


- (id) initWithImage:(UIImage *) image {
    self = [self initWithNibName:@"SPreviewViewController" bundle:nil];
    if (self) {
        _image = image;
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.navigationItem.title = @"照片预览";
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(optionAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    _imageView = [[UIImageView alloc] initWithImage:_image];
    //    _imageView.layer.cornerRadius = 5.0;
    //    _imageView.layer.masksToBounds = YES;
    _imageView.frame = CGRectMake(0, 0, 320, 460);
    
    _cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    //    _cardView.layer.borderWidth = 10.0f;
    //    _cardView.userInteractionEnabled = YES;
    
    // 为 该 cardView 添加放大，缩小 手势.
    
    UIPinchGestureRecognizer * pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    [_cardView addGestureRecognizer:pinchGestureRecognizer];
    
    // 为 该 imageView 添加 移动手势
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [_cardView addGestureRecognizer:panGestureRecognizer];
    //
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    
    [tapGestureRecognizer setNumberOfTapsRequired:2];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [_cardView addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:_imageView];
    [self.view insertSubview:_cardView aboveSubview:_imageView];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.wantsFullScreenLayout = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CATransition * animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"flip";
    animation.subtype = kCATransitionFromRight;
    
    [[self.navigationController.view layer] addAnimation:animation forKey:@"animation"];

}

- (void) pinchGestureAction:(UIPinchGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0f;
    }
    
    CGFloat scale = 1.0 - (_lastScale - sender.scale);
    CGAffineTransform currentTransform = _imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    _imageView.transform = newTransform;
    _lastScale = [sender scale];
}

- (void) panGestureAction:(UIPanGestureRecognizer *) sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _lastPointCenter = _imageView.center;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [sender translationInView:[_imageView superview]];
        _imageView.center=CGPointMake(_lastPointCenter.x + translation.x,_lastPointCenter.y + translation.y);
    }
    
}

- (void) tapGestureAction:(UITapGestureRecognizer *) sender {
    //    sender.
    _imageView.center = _cardView.center;
    _imageView.transform = _cardView.transform;
}

@end
