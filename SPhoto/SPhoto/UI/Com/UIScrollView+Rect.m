//
//  UIScrollView+Rect.m
//  SPhoto
//
//  Created by SunJiangting on 12-9-17.
//
//

#import "UIScrollView+Rect.h"

@implementation UIScrollView (Rect)

- (CGRect) visibleRect {
    CGRect rect;
    rect.origin = self.contentOffset;
    rect.size = self.bounds.size;
	return rect;
}

@end
