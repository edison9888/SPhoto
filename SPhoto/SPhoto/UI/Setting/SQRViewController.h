//
//  SQRViewController.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-24.
//
//

#import "SViewController.h"
#import "QRCodeGenerator.h"
#import "SActionSheet.h"
#import "SResultViewController.h"

@interface SQRViewController : SViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZBarReaderDelegate>

@end
