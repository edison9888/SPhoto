//
//  NavigationBar.m
//  KXAlbum
//
//  Created by Louie on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationBar.h"


@implementation NavigationBar

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        _bshow = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        _bshow = NO;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    if(_bshow){
        [super drawRect:rect];
    }
    else{
        UIImage *backgroundImage = [UIImage imageNamed:@"header_bkg.png"];
        [backgroundImage drawInRect:self.bounds];
    }
}

-(void)showNaviSysColor:(BOOL)bshow{
    _bshow = bshow;
    [self setNeedsDisplay];
}
@end
