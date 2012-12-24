//
//  SUserViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-26.
//
//

#import "SUserViewController.h"

@interface SUserViewController ()

@property (nonatomic, strong) UITextView * userInfoTextView;
@property (nonatomic, copy) NSString * userLocationText;

@end

@implementation SUserViewController

- (id) init {
    self = [super init];
    if (self) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults valueForKey:kUserLocationKey]) {
            self.userLocationText = [userDefaults valueForKey:kUserLocationKey];
        } else {
            self.userLocationText = @"北京市朝阳区北三环东路静安中心";
        }
        
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithType:SButtonTypeDone target:self action:@selector(done:)];
    
	// Do any additional setup after loading the view.
    self.userInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, 280, 120)];
    self.userInfoTextView.layer.cornerRadius = 5.0f;
    self.userInfoTextView.layer.shadowColor = UIColorWithRGB(0xCCCCCC).CGColor;
    self.userInfoTextView.layer.masksToBounds = YES;
    self.userInfoTextView.text = self.userLocationText;
    [self.view addSubview:self.userInfoTextView];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.userInfoTextView = nil;
}

- (void) done:(id) sender {
    NSString * userLocationText = self.userInfoTextView.text;
    if (userLocationText.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:userLocationText forKey:kUserLocationKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
