//
//  NavigationBar.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SNavigationBar.h"


@implementation SNavigationBar

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    UIImage *backgroundImage = [UIImage imageNamed:@"header.png"];
    [backgroundImage drawInRect:self.bounds];
}

@end
