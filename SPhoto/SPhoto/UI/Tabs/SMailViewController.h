//
//  SMailViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//
//

#import <QuartzCore/QuartzCore.h>

@interface SMailViewController : SViewController


@property (nonatomic, strong) IBOutlet UIImageView * imageView;

@property (nonatomic, strong) IBOutlet UIButton * uploadButton;

-(IBAction) uploadPhotoAction :(id)sender;

@end
