//
//  SWindow.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-23.
//
//

#import "SWindow.h"

@implementation SWindow

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) makeKeyAndVisible {
    [super makeKeyAndVisible];
    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate.window makeKeyAndVisible];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
