//
//  SImageViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SImageViewController : UIViewController {
    
@private
    UIView * _cardView;
    UIImageView * _imageView;
    CGFloat _lastScale;
}

@property (nonatomic, strong) UIImage * image;


- (id) initWithImage:(UIImage *) image;

@end
