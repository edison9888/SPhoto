
//
//  SImageViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SImageViewController.h"

@implementation SImageViewController

@synthesize image = _image;


- (id) initWithImage:(UIImage *) image {
    self = [self initWithNibName:@"SImageViewController" bundle:nil];
    if (self) {
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"查看照片";
    titleLabel.textColor = kTitleColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(optionAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    

    
    _imageView = [[UIImageView alloc] initWithImage:_image];
//    _imageView.layer.cornerRadius = 5.0;
//    _imageView.layer.masksToBounds = YES;
    _imageView.frame = CGRectMake(20, 20, 280, 320);
    
    _cardView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 320)];
    _cardView.layer.borderWidth = 10.0f;
    _cardView.userInteractionEnabled = YES;
    
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

- (void) pinchGestureAction:(UIPinchGestureRecognizer*) sender {
        //当手指离开屏幕时,将lastscale设置为1.0
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        _lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0 - (_lastScale - [sender scale]);
    CGAffineTransform currentTransform = _imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [_imageView setTransform:newTransform];
    _lastScale = [sender scale];
}

- (void) panGestureAction:(UIPanGestureRecognizer *) sender {
    
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [sender translationInView:[_imageView superview]];
        
        [_imageView setCenter:CGPointMake([_imageView center].x + translation.x, [_imageView center].y + translation.y)];
        
    }
    
}

- (void) tapGestureAction:(UITapGestureRecognizer *) sender {
//    sender.
}

- (void) optionAction:(id) sender {
    
    UIViewController * viewController = [[UIViewController alloc] init ];
    [self.navigationController pushViewController:viewController animated:NO];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"flip";
    animation.subtype = kCATransitionFromRight;
    
    [[self.navigationController.view layer] addAnimation:animation forKey:@"animation"];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
