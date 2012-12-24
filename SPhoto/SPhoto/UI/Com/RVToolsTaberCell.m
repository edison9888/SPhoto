//
//  RVToolsTaberCell.m
//  RenrenVoice
//
//  Created by wang lei on 12-8-21.
//  Copyright (c) 2012年 Renren Inc. All rights reserved.
//

#import "RVToolsTaberCell.h"

@implementation RVToolsTaberCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame Button:(UIButton*)button buttonPostionInfo:(NSDictionary*)info{
    self = [super initWithFrame:frame];
    if (self) {
        if (!info) {
            [self config];
        }
        else{
            topPadding = [info objectForKey:@"topPadding"]?[[info objectForKey:@"topPadding"]floatValue]:5.0f;
            leftPadding = [info objectForKey:@"leftPadding"]?[[info objectForKey:@"leftPadding"]floatValue]:5.0f;
            rightPadding = [info objectForKey:@"rightPadding"]?[[info objectForKey:@"rightPadding"]floatValue]:10.0f;
            bottomPadding = [info objectForKey:@"bottomPadding"]?[[info objectForKey:@"bottomPadding"]floatValue]:0.0f;
        }
        button.frame = CGRectMake(leftPadding, topPadding, frame.size.width-(leftPadding+rightPadding), frame.size.height-(topPadding+bottomPadding));
        [self addSubview:button];

    }
    return self;
}


-(void)config{
    topPadding    = 5.0f;
    bottomPadding = 5.0f;
    leftPadding   = 10.0f;
    rightPadding  = 0.0f;
    buttonHeight  = 46.0f;
    descriptionHeight = 10.0f;
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
