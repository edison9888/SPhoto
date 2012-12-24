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
    
    SPostImageItem * imageItem = [SPostImageItem new];
    imageItem.field = @"postcard";
    NSDate * date = [NSDate date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    imageItem.name = [format stringFromDate:date];
    imageItem.image = _imageView.image;
    
    NSDictionary * params = @{
    @"description": @"我的图片真好看",
    @"image":imageItem
    };
    
    [SProgressHUD showWithView:self.view status:@"正在上传" animated:YES];
    SRequest * request = [SRequest requestWithMethod:@"photo/upload.do/" params:params type:SRequestMethodPost];
    [request startWithHandler:^(id result, NSError *error) {
        BOOL success = [[result objectForKey:@"result"] boolValue];
        if (success) {
            SLog(@"上传成功");
        } else {
            SLog(@"上传失败");
        }
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
    }];
}

- (void) hideHud {
    [SProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"上传照片";
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
