//
//  SButton.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-22.
//
//


#import "SButton.h"

@interface SButton ()

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, strong) UIColor * highlightColor;

@end

@implementation SButton

- (void) setColor:(UIColor *) color highlightColor:(UIColor *) highlightColor {
    self.backgroundColor = color;
    self.color = color;
    self.highlightColor = highlightColor;
}


- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted && self.highlightColor) {
        self.backgroundColor = self.highlightColor;
    } else if (!highlighted && self.color) {
        self.backgroundColor = self.color;
    }
    for (UIView * view in self.subviews) {
        [view setValue:@(highlighted) forKey:@"highlighted"];
    }
}

@end
