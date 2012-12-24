//
//  STableViewController.h
//  RenrenVoice
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#define kSRefreshHeight 76.0f

#import "SViewController.h"


/// 下拉刷新的状态
typedef enum SRefreshViewState : NSInteger {
    SRefreshViewStateBeforePull = 0,           // 未刷新
    SRefreshViewStatePullCanRefresh = 1,       // 显示 下拉可以刷新 字样
    SRefreshViewStateRefreshing = 2,           // 正在刷新
    SRefreshViewStateReleaseToRefresh = 3,     // 显示 释放可以刷新 字样
    SRefreshViewStateFinishRefresh = 4         // 刷新之后，恢复
} SRefreshViewState;                           // 下拉刷新的状态

/**
 * @brief 显示下拉刷新的View\n
 * 里面包含刷新状态，更新时间，左边小箭头，和小菊花
 */
@interface SRefreshView : UIView {
    /// @enum SRefreshViewState 下拉刷新目前的状态
    UILabel * _stateLabel;          // 下拉刷新的状态
    /// 最后一次更新时间，刷新完毕后会显示最后更新时间，然后会被保存
    UILabel * _updateTimeLabel;     // 最后更新时间
    /// 左边的箭头
    UIImageView * _arrowImageView;  // 左边的箭头
    /// 刷新时左边出现的小菊花
    UIActivityIndicatorView * _refreshIndicator;    // 刷新时出现的小菊花
}

/**
 * @brief 当下拉刷新状态变更时，该方法会被调用
 * @param state  下拉刷新目前所处的状态 参见 SRefreshViewState
 * @param status 该状态下所需要显示的文字，包括下拉可以刷新，松开...等等
 * @note 无需手动调用此方法
 * @see STableViewController
 */
- (void) didWhenStateChanged:(SRefreshViewState) state status:(NSString *)status;

@end

/**
 * @brief 该委托充当下拉刷新SRefreshView和STableViewController的Controller\n
 *
 */
@protocol STableViewRefreshDelegate <NSObject>

/// 一些协议
@optional

/**
 * @brief 该协议主要获取各个状态下SRefreshView需要显示的文字
 * @param tableView  触发该协议的tableView
 * @param state  该tableView 的下拉刷新所处的状态
 * @return 返回该状态(state)下需要展示在SRefreshView上的状态字符串
 * @note 如果您需要使用下拉刷新功能，并且不适用默认的下拉可以刷新等状态可以实现委托中的此方法
 */
- (NSString *) stringFromTableView:(UITableView *) tableView state : (SRefreshViewState) state;

/**
 * @brief 当开始刷新时该协议会被调用
 * @param tableView 触发该协议的tableView
 */
- (void) didStartRefreshTableView:(UITableView *) tableView;

/**
 * @brief 当结束刷新时该协议会被调用
 * @param tableView 触发该协议的tableView
 */
- (void) didEndRefreshTableView:(UITableView *) tableView;

@end

/**
 * @brief 基类，主要封装TableView的下拉刷新的加载更多控件
 * 默认会填充一个充满view的tableview，该tableview为透明。
 */
@interface STableViewController : SViewController <UITableViewDelegate,UITableViewDataSource,STableViewRefreshDelegate> {
    /// 下拉刷新的界面
    SRefreshView * _refreshView;       // 下拉刷新的界面
}
/// STableViewController 内填充的 tableView
@property (nonatomic, readonly) UITableView * tableView;        // 内置的tableView
/// tableView 的样式
@property (nonatomic, readonly) UITableViewStyle tableViewStyle;        // tableView 风格
/// TableView当前所处的下拉刷新的状态 参见SRefreshViewState
@property (nonatomic, readonly) SRefreshViewState refreshViewState;        // tableView当前状态
/// 下拉刷新时的状态监听 参见 STableViewRefreshDelegate
@property (nonatomic, assign) id<STableViewRefreshDelegate> refreshDelegate;   // 下拉刷新状态
/// 是否开启下拉刷新功能。默认不开启
@property (nonatomic, assign) BOOL pullRefresh;     // 是否下拉刷新

/**
 * @brief 初始化 STableViewController
 * @param style tableView的风格，参见 UITableViewStyle
 * @return 如果创建成功，则返回STableViewController实例，否则返回SModelViewController实例
 */
- (id)initWithStyle:(UITableViewStyle) style;

@end
