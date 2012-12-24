//
//  SListView.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SListView.h"

@implementation SListView

- (id)initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = frame.size;
        _height = size.height;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _scrollView.contentOffset = CGPointZero;
        _scrollView.delegate = self;
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidTap:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:tapGestureRecognizer];
        
        [self addSubview:_scrollView];
        [self bringSubviewToFront:_scrollView];
        
        
        _columnRects = [NSMutableArray arrayWithCapacity:5];
        
        _selectedIndex = -1;
        _separatorColor = [UIColor grayColor];
        
    }
    return self;
}

- (void) setDataSource:(id<SListViewDataSource>)dataSource {
    _dataSource = dataSource;
}

- (void) reloadData {
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInListView:)]) {
        _columns = [_dataSource numberOfColumnsInListView:self];
    }
    
    if (_columns <= 0) {
        return;
    }
    CGFloat left = 0;
    _visibleRange = SRangeMake(0, 0);
    for (int index = 0; index < _columns; index ++) {
        CGFloat width = _height;
        if ([_dataSource respondsToSelector:@selector(widthForColumnAtIndex:)]) {
            width = [_dataSource widthForColumnAtIndex:index];
        }
        
        CGRect rect = CGRectMake(left, 0, width, _height);
        
        [_columnRects addObject:NSStringFromCGRect(rect)];
        left += width;
    }
    
    _scrollView.contentSize = CGSizeMake(left, _height);

    if (!_visibleListCells) {
        _visibleListCells = [NSMutableArray arrayWithCapacity:5];
    }
    left = 0;
    __block NSUInteger end;
    [_columnRects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect frame = CGRectFromString(obj);
        if (CGRectIntersectsRect(frame, _scrollView.visibleRect)) {
            [self requestCellWithIndex:idx direction:SDirectionTypeLeft];
        } else {
            end = idx;
            *stop = YES;
        }
    }];
    end = MIN(end, _columns);
    _visibleRange.end = end;
}

- (SListViewCell *) requestCellWithIndex:(NSInteger) index direction:(SDirectionType) direction {
    CGRect frame = CGRectFromString([_columnRects objectAtIndex:index]);
    SListViewCell * cell = [_dataSource listView:self viewForColumnAtIndex:index];
    cell.frame = frame;
    cell.tag = index;
    if (_selectedIndex == index) {
        cell.selected = YES;
    }
    [_scrollView addSubview:cell];
    if (direction == SDirectionTypeLeft) {
        [_visibleListCells addObject:cell];
    }else if(direction == SDirectionTypeRight) {
        [_visibleListCells insertObject:cell atIndex:0];
    }
    return cell;
}

- (void) reLayoutSubViewsWithOffset:(CGFloat) offset {
    int start = _visibleRange.start;
    start = MAX(0, start);
    int end = _visibleRange.end;
    end = MIN(_columns-1, end);
    CGRect frame = CGRectFromString([_columnRects objectAtIndex:start]);
    CGRect frame1 = CGRectFromString([_columnRects objectAtIndex:end]);
    // 向左滑动
    if (offset > 0) {
        // 判断如果 可见区域的第一个移除区域外，则放进 可复用池里面。允许可复用
        if ((_visibleRect.origin.x) >= (frame.origin.x + frame.size.width)) {
            SListViewCell * cell = (SListViewCell *) [_visibleListCells objectAtIndex:0];
            [self inqueueReusableWithView:cell];
            start += 1;
            _visibleRange.start = start;
        }
        // 如果最后一个的末尾被滚进区域，则加载下一个
        if ((_visibleRect.origin.x + _visibleRect.size.width) >= (frame1.origin.x + frame1.size.width)) {
            end += 1;
            if (end < _columns) {
                [self requestCellWithIndex:end direction:SDirectionTypeLeft];
                _visibleRange.end = end;
            }
        }
    }
    // 向右滑动
    else {
        // 判断如果 可见区域的最后一个移除区域外，则放进 可复用池里面。允许可复用
        if ( frame1.origin.x >= (_visibleRect.origin.x + _visibleRect.size.width) ) {
            SListViewCell * cell = (SListViewCell *) [_visibleListCells lastObject];
            [self inqueueReusableWithView:cell];
            end -= 1;
            _visibleRange.end = end;
            
        }
        if (frame.origin.x >= _visibleRect.origin.x) {
            start -= 1;
            if (start >= 0) {
                [self requestCellWithIndex:start direction:SDirectionTypeRight];
                _visibleRange.start = start;
            }
        }
    }
}

/// Cell 的复用
- (id) dequeueReusableCellWithIdentifier:(NSString *)identifier {
    SListViewCell * cell = nil;
    NSMutableArray * reuseCells = [_reusableListCells objectForKey:identifier];
    if ([reuseCells count] > 0) {
        cell = [reuseCells objectAtIndex:0];
        [reuseCells removeObject:cell];
    }
    return cell;
}

- (void) inqueueReusableWithView:(SListViewCell *) reuseView {
    NSString * identifier = reuseView.reuseIdentifier;
    if (!_reusableListCells) {
        _reusableListCells = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    NSMutableArray * cells = [_reusableListCells valueForKey:identifier];
    if (!cells) {
        cells  = [[NSMutableArray alloc] initWithCapacity:5];
        [_reusableListCells setValue:cells forKey:identifier];
    }
    reuseView.selected = NO;
    [cells addObject:reuseView];
    [_visibleListCells removeObject:reuseView];
    [reuseView removeFromSuperview];
}

- (void) setSelectedIndex:(NSInteger)selectedIndex {
    
    if (_selectedIndex == selectedIndex) {
        return;
    }
    // 如果 前一个选中的cell在可视区域内，则取消选中
    if (InRange(_visibleRange, _selectedIndex)) {
        int i = _selectedIndex - _visibleRange.start;
        SListViewCell * cell = [_visibleListCells objectAtIndex:i];
        [cell setSelected:NO];
    }
    // 如果Cell在可是区域内
    _selectedIndex = selectedIndex;
    if (InRange(_visibleRange, selectedIndex)) {
        int i = _selectedIndex - _visibleRange.start;
        SListViewCell * cell = [_visibleListCells objectAtIndex:i];
        [cell setSelected:YES];
    }
    if ([_delegate respondsToSelector:@selector(listView:didSelectColumnAtIndex:)]) {
        [_delegate listView:self didSelectColumnAtIndex:selectedIndex];
    }
}
#pragma mark === ScrollView Delegate ===

- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
    CGRect tempRect = [scrollView visibleRect];
    CGFloat offsetX = tempRect.origin.x - _visibleRect.origin.x;
    _visibleRect = tempRect;
    [self reLayoutSubViewsWithOffset:offsetX];
}

- (void) scrollViewDidTap:(UITapGestureRecognizer *) sender {
    // 得到点击的区域
    CGPoint touchPoint = [sender locationInView:_scrollView];
    // 根据点击区域的坐标，算出当前所在的列
    // 遍历所有 可见区域的 Cell
    for (SListViewCell * cell in _visibleListCells) {
        CGRect frame = cell.frame;
        // 如果 frame.origin.x < touchPoint.x <= frame.origin.x + frame.size.width
        if (touchPoint.x > frame.origin.x  &&  touchPoint.x <= frame.origin.x + frame.size.width) {
            [self didSelectedCell:cell index:cell.tag];
            break;
        }
    }
}

- (void) didSelectedCell:(SListViewCell *) cell index:(NSInteger) index {
    //            SLog(@"selected %d",cell.tag);
    self.selectedIndex = index;
}

@end
