
//
//  SImageViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SImageViewController.h"

@interface SImageViewController ()

@property (nonatomic, strong) SProgressHUD * hud;

@property (nonatomic, strong) NSMutableArray * photoArray;
@property (nonatomic, assign) BOOL more;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) SRequest * request;
@property (nonatomic, strong) SWaterStreamView * waterStreamView;

- (void) refresh;

@end

@implementation SImageViewController

- (id) init {
    self = [super init];
    if (self) {
        self.more = NO;
        self.page = 0;
        self.request = [SRequest requestWithMethod:@"photo/list"];
        [self.request setParam:@(self.page) forKey:@"page"];
        [self.request setParam:@(50) forKey:@"size"];
        self.photoArray = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.title = @"我的照片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithType:SButtonTypeRefresh target:self action:@selector(refresh)];
    
    self.waterStreamView = [[SWaterStreamView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height)];
    self.waterStreamView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.waterStreamView.delegate = self;
    self.waterStreamView.dataSource = self;
    self.waterStreamView.streamFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [self.view addSubview:self.waterStreamView];
    [self refresh];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void) refresh {
    [SProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    [self.request startWithHandler:^(id result, NSError *error) {
        NSDictionary * response = (NSDictionary *) result;
        self.more = [[response objectForKey:@"more"] boolValue];
        self.page = [[response objectForKey:@"page"] intValue];
        [self.photoArray removeAllObjects];
        NSArray * array = [response objectForKey:@"photos"];
        [self.photoArray addObjectsFromArray:array];
        
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
        
    }];
}

- (void) reload {
    [SProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    [self.waterStreamView reloadData];
}

- (NSInteger) numberOfWatersInStreamView:(SWaterStreamView *) streamView {
    return 2;
}

- (NSInteger) numberOfElementsInStreamView:(SWaterStreamView *) streamView {
    return self.photoArray.count;
}


- (CGFloat) streamView:(SWaterStreamView *) streamView
   heightForRowAtIndex:(NSInteger) index
            basedWidth:(CGFloat)width {
    NSDictionary * dict = [self.photoArray objectAtIndex:index];
    CGFloat originHeight = [[dict valueForKey:@"height"] floatValue];
    CGFloat originWidth = [[dict valueForKey:@"width"] floatValue];
    return originHeight * width / originWidth;
}

- (SWaterStreamViewCell *) streamView:(SWaterStreamView *)streamView cellForCellAtIndex:(int)index {
    static NSString * cellName = @"CELLNAME";
    SWaterStreamViewCell * cell = [streamView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[SWaterStreamViewCell alloc] initWithReuseIdentifier:cellName];
    }
    cell.photoDictionary = [self.photoArray objectAtIndex:index];
    return cell;
}


- (void) streamView:(SWaterStreamView *)streamView
didSelectStreamCell:(SWaterStreamViewCell *)streamCell
            atIndex:(NSInteger)index {
    NSLog(@"第[%d]个Cell%@",index,streamCell);
}

@end
