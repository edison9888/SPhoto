//
//  SMailViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMailViewController : UIViewController


@property (nonatomic, strong) IBOutlet UIImageView * imageView;

@property (nonatomic, strong) IBOutlet UIButton * uploadButton;

-(IBAction) uploadPhotoAction :(id)sender;

@end
