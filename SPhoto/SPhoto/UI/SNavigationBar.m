//
//  NavigationBar.m
//  KXAlbum
//
//  Created by Louie on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
