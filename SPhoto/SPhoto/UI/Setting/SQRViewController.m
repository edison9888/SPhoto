//
//  SQRViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-24.
//
//

#import "SQRViewController.h"

@interface SQRViewController ()

@property (nonatomic, copy) NSString * address;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImage * qrImage;

@end


@implementation SQRViewController


- (id) init {
    self = [super init];
    if (self) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults valueForKey:kUserLocationKey]) {
            self.address = [userDefaults valueForKey:kUserLocationKey];
        } else {
            self.address = @"北京市朝阳区北三环东路8号静安中心";
        }
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码名片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithType:SButtonTypeMore target:self action:@selector(moreAction:)];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 30)];
    self.addressLabel.backgroundColor = [UIColor clearColor];
    self.addressLabel.font = UIFontWithName(kFontNameArialBold, 16.0f);
    self.addressLabel.textColor = UIColorWithRGB(0xCCCCCC);
    self.addressLabel.textAlignment = UITextAlignmentCenter;
    self.addressLabel.text = self.address;
    [self.view addSubview:self.addressLabel];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 60, 260, 260)];
    [self.view addSubview:self.imageView];
    
    self.qrImage = [QRCodeGenerator qrImageForString:self.address imageSize:260.0f];
    self.imageView.image = self.qrImage;
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.addressLabel = nil;
    self.imageView = nil;
    self.qrImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showPickerWithSourceType:(UIImagePickerControllerSourceType) sourceType {
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = sourceType;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        ZBarReaderViewController * reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = reader.scanner;
        
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        [self presentModalViewController: reader
                                animated: YES];

    }
}

- (void) moreAction:(id) sender {
    SActionSheet * actionSheet = [[SActionSheet alloc] initWithTitle:nil delegate:nil cancelSheetItemType:SheetButtonCancel otherSheetItemTypes:SheetButtonCamera,SheetButtonPhoto, nil];
    [actionSheet showWithDismissHandler:^(SActionSheet *actionSheet, int dismissedIndex) {
        switch (dismissedIndex) {
            case 0:
                [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
                
            default:
                break;
        }
    }];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    SResultViewController * controller;
    if ([picker isKindOfClass:[ZBarReaderViewController class]]) {
        ZBarSymbolSet * symbolSet = [info objectForKey: ZBarReaderControllerResults];
        controller = [[SResultViewController alloc] initWithImage:image symbolSet:symbolSet];
    } else {
        controller = [[SResultViewController alloc] initWithImage:image];   
    }
    [self.navigationController pushViewController:controller animated:YES];
}


@end
