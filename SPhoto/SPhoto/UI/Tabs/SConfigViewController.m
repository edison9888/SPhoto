//
//  SConfigViewController.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SConfigViewController.h"

@interface SConfigViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * configArray;

@end

@implementation SConfigViewController


- (id)init {
    self = [super init];
    if (self) {
        self.configArray = [NSMutableArray arrayWithCapacity:5];
        
        NSArray * basicArray = @[@"基本信息"];
        [self.configArray addObject:basicArray];
        
        NSArray * barArray = @[@"二维码", @"我的账号"];
        [self.configArray addObject:barArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 400) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView =  nil;
}

#pragma mark === TableView DataSource ===

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.configArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.configArray objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellName = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    NSString * title = [[self.configArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
