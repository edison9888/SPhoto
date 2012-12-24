//
//  SListView.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SListViewCell.h"
#import <QuartzCore/QuartzCore.h>

@class SListView;


@protocol SListViewDelegate <NSObject, UIScrollViewDelegate>

/**
 * @brief 当前列 被选中的事件
 * @param index  当前所在列
 */
- (void) listView:(SListView *) listView didSelectColumnAtIndex:(NSInteger) index;

@end

@protocol SListViewDataSource <NSObject>

@optional
/**
 * @brief 共有多少列
 * @param listView 当前所在的ListView
 */
- (NSInteger) numberOfColumnsInListView:(SListView *) listView;

/**
 * @brief 这一列有多宽，根据有多宽，算出需要加载多少个
 * @param index  当前所在列
 */
- (CGFloat) widthForColumnAtIndex:(NSInteger) index;

/**
 * @brief 每列 显示什么
 * @param listView 当前所在的ListView
 * @param index  当前所在列
 * @return  当前所要展示的页
 */
- (SListViewCell *) listView:(SListView *)listView viewForColumnAtIndex:(NSInteger) index;

@end
/// 参考 UITableView
@interface SListView : UIView <NSCoding, UIScrollViewDelegate> {
    /// ListCell 个数
    NSInteger _columns;
    /// scrollView
    UIScrollView * _scrollView;
    /// 每个SListViewCell 的高度
    CGFloat _height;
    /// 所有的SListViewCell 的frame
    NSMutableArray * _columnRects;
    /// 可见的column范围
    SRange _visibleRange;
    /// scrollView 的可见区域
    CGRect _visibleRect;
    /// 可见的SListViewCell;
    NSMutableArray * _visibleListCells;
    /// 可重用的ListCells {identifier:[cell1,cell2]}
    NSMutableDictionary * _reusableListCells;
}

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic,assign) id<SListViewDelegate> delegate;
@property (nonatomic,assign) id<SListViewDataSource> dataSource;

@property(nonatomic,retain) UIColor * separatorColor;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void) reloadData;

@end
