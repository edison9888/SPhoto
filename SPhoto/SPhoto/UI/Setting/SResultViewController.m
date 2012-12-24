//
//  SResultViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-24.
//
//

#import "SResultViewController.h"

@interface SResultViewController ()
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UITextView * resultTextView;

@property (nonatomic, strong) ZBarImageScanner * zbarImageScanner;
@property (nonatomic, strong) ZBarSymbolSet * symbolSet;

@end

@implementation SResultViewController


- (id) initWithImage:(UIImage *) image {
    self = [super init];
    if (self) {
        self.image = image;
        self.hidesBottomBarWhenPushed = YES;
        self.zbarImageScanner = [ZBarImageScanner new];
    }
    return self;
}


- (id) initWithImage:(UIImage *) image symbolSet:(ZBarSymbolSet *) symbolSet {
    self = [super init];
    if (self) {
        self.image = image;
        self.hidesBottomBarWhenPushed = YES;
        self.symbolSet = symbolSet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫描结果";
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.frame = CGRectMake(30, 20, 260, 260);
    [self.view addSubview:self.imageView];
    
    self.resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 290, 300, 100)];
    self.resultTextView.textColor = UIColorWithRGB(0x666666);
    self.resultTextView.backgroundColor = [UIColor clearColor];
    self.resultTextView.font = UIFontWithName(kFontNameHelvetica, 14.0f);
    self.resultTextView.editable = NO;
    [self.view addSubview:self.resultTextView];
    
    if (self.symbolSet) {
        [self dealWithStatus:1];
    } else {
        [SProgressHUD showHUDAddedTo:self.view animated:NO];
        [self performSelector:@selector(scannerImage) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    }
}

- (void) scannerImage {
    ZBarImage * zbarImage = [[ZBarImage alloc] initWithCGImage:self.image.CGImage];
    int status = [self.zbarImageScanner scanImage:zbarImage];
    self.symbolSet = self.zbarImageScanner.results;
    [SProgressHUD hideHUDForView:self.view animated:NO];
    [self dealWithStatus:status];
}

- (NSString *) dealWithStatus:(int) status{
    NSMutableString * result = [NSMutableString stringWithCapacity:20];
    if (status == 0) {
        [result appendString:@"亲，扫描失败"];
    } else {
        [result appendFormat:@"共扫描到:%d 条记录\n", self.symbolSet.count];
        int i = 1;
        for (ZBarSymbol * symbol in self.symbolSet) {
            [result appendFormat:@"第 %d 条记录:\n\t%@\n",i,symbol.data];
            i ++;
        }
    }
    self.resultTextView.text = result;
    SLog(@"%@",result);
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
