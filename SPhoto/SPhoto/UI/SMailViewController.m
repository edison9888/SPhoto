//
//  SMailViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SMailViewController.h"
#import "SRequest.h"
#import "SProgressHUD.h"

@implementation SMailViewController

@synthesize imageView = _imageView, uploadButton = _uploadButton;


-(IBAction) uploadPhotoAction :(id)sender {
    
    NSData * data = UIImagePNGRepresentation(_imageView.image);
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:data, @"image", nil];
    [SProgressHUD showWithView:self.view status:@"正在上传" animated:YES];
    
    SRequest * request = [SRequest requestWithPath:@"open/photo/upload.action" dict:dict method:@"POST"];
    //    SRequest * request = [SRequest postWithImage:_imageView.image description:nil];
    [request startWithCompleteHandler:^(id result, NSError *error) {
        //
        SLog(@"%@",result);
        [SProgressHUD hideHUDForView:self.view animated:YES];
    } ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"上传照片";
    titleLabel.textColor = kTitleColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
