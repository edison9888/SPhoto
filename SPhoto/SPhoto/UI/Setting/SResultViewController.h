//
//  SResultViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-24.
//
//

#import "SViewController.h"
#import "SProgressHUD.h"
#import "ZBarSDK.h"

@interface SResultViewController : SViewController

- (id) initWithImage:(UIImage *) image;

- (id) initWithImage:(UIImage *) image symbolSet:(ZBarSymbolSet *) symbolSet;

@end
