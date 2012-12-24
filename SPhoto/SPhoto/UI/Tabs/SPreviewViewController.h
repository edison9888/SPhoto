//
//  SPreviewViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-9-16.
//
//

#import <QuartzCore/QuartzCore.h>

@interface SPreviewViewController : SViewController {

@private

UIView * _cardView;
UIImageView * _imageView;
CGFloat _lastScale;
CGPoint _lastPointCenter;
}

@property (nonatomic, strong) UIImage * image;


- (id) initWithImage:(UIImage *) image;

@end
