//
//  SListViewCell.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SListViewCell.h"

#define kMinListCellRect CGRectMake(0, 0, 50, 70)

@interface SListViewCell ()

@property (nonatomic, strong) UIView * selectedView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * filterImageView;

@end

@implementation SListViewCell


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = kMinListCellRect;
        self.reuseIdentifier = reuseIdentifier;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.selectedBackgroundView = nil;
        
        self.selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_selected_bkg.png"]];
        self.selectedView.hidden = YES;
        self.selectedView.frame = CGRectMake(4, 9, 42, 42);
//        self.selectedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.selectedView];
        
        self.filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
//        self.filterImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.filterImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 40, 15)];
//        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.font = UIFontWithName(kFontNameArialBold, 14.0f);
        self.titleLabel.textColor = UIColorWithRGB(0x8C8C8C);
        self.titleLabel.highlightedTextColor = UIColorWithRGB(0x8E8E8E);
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

- (void) setFilterDictionary:(NSDictionary *)filterDictionary {
    _filterDictionary = filterDictionary;
    NSString * title = [filterDictionary objectForKey:@"title"];
    NSString * image = [filterDictionary objectForKey:@"image"];
    self.titleLabel.text  = title;
    self.filterImageView.image = [UIImage imageNamed:image];
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedView.hidden = !selected;
}

@end
