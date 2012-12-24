//
//  STableViewController.m
//  RenrenVoice
//
//  Created by SunJiangting on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "STableViewController.h"

#pragma mark === SRefreshView === 
/**
 * @brief 显示下拉刷新的View\n
 * 里面包含刷新状态，更新时间，左边小箭头，和小菊花
 */
@implementation SRefreshView

#pragma mark === SRefreshView init ===
/// 初始化SRefreshView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 左边的箭头
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 10, 14, 40)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [self addSubview:_arrowImageView];
        
        // 加载时左边的小菊花
        _refreshIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(34, 15, 20, 20)];
        _refreshIndicator.center = _arrowImageView.center;
        _refreshIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_refreshIndicator];
        
        // 上面所显示的文字信息
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, 180, 24)];
        _stateLabel.textAlignment = UITextAlignmentCenter;
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.font = [UIFont systemFontOfSize:13.0f];
        _stateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_stateLabel];
        
        // 最后更新时间
        _updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 180, 24)];
        _updateTimeLabel.textAlignment = UITextAlignmentCenter;
        _updateTimeLabel.textColor = [UIColor grayColor];
        _updateTimeLabel.backgroundColor = [UIColor clearColor];
        _updateTimeLabel.font = [UIFont systemFontOfSize:13.0f];
        _updateTimeLabel.text = @"上次更新:10分钟前";
        [self addSubview:_updateTimeLabel];
    }
    return self;
}


#pragma mark === SRefreshView 状态变更回调 ===
/**
 * @brief 当下拉刷新状态变更时，该方法会被调用
 * @param state  下拉刷新目前所处的状态 参见 SRefreshViewState
 * @param status 该状态下所需要显示的文字，包括下拉可以刷新，松开...等等
 * @note 无需手动调用此方法
 * @see STableViewController
 */
- (void) didWhenStateChanged:(SRefreshViewState) state status:(NSString *)status {
    // 如果传入status，则设置状态
    if (status) {
        _stateLabel.text = status;
    }
    switch (state) {
            // 如果状态为下拉可以刷新或者已经刷新完毕，则停止刷新
        case SRefreshViewStatePullCanRefresh:
        case SRefreshViewStateFinishRefresh:
        {
            // 如果小菊花在转，则停止小菊花
            if (_refreshIndicator.isAnimating) {
                [_refreshIndicator stopAnimating];
                // 隐藏小菊花
                _refreshIndicator.hidden = YES;
                // 将箭头显示出来
                _arrowImageView.hidden = NO;
            }
            // 将箭头转会原方位，箭头朝下
            [UIView animateWithDuration:0.25 animations:^{
                _arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
            // 如果状态为 正在刷新，则转动小菊花，并且隐藏箭头
        case SRefreshViewStateRefreshing:
            // 隐藏箭头
            _arrowImageView.hidden = YES;
            // 显示小菊花并且开始转动
            _refreshIndicator.hidden = NO;
            [_refreshIndicator startAnimating];
            break;
            // 如果状态为释放可以刷新
        case SRefreshViewStateReleaseToRefresh:
        {
            // 则将箭头转上去，箭头朝上
            [UIView animateWithDuration:0.25 animations:^{
                _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
            break;
        default:
            break;
    }
}

@end

/**
 * @brief 基类，主要封装TableView的下拉刷新的加载更多控件
 * 默认会填充一个充满view的tableview，该tableview为透明。
 */
@implementation STableViewController

/**
 * @brief 如果没有传入tableView的样式\n
 * 则返回样式为UITableViewStylePlain的STableViewController
 */
- (id) init {
    return [self initWithStyle:UITableViewStylePlain];
}

/**
 * @brief 初始化 STableViewController
 * @param style tableView的风格，参见 UITableViewStyle
 * @return 如果创建成功，则返回STableViewController实例，否则返回SModelViewController实例
 */
- (id) initWithStyle:(UITableViewStyle) style {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tableViewStyle = style;
        
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView = [[UITableView alloc] initWithFrame:frame style:_tableViewStyle];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _refreshDelegate = self;        // 是否需要下拉刷新功能
    if (_pullRefresh) {
        _refreshView = [[SRefreshView alloc] initWithFrame:CGRectMake(0, -kSRefreshHeight, 320, kSRefreshHeight)];
        [_tableView insertSubview:_refreshView atIndex:0];
    }
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

/**
 * @brief 设置是否下拉刷新
 * @param pullRefresh 是否需要下拉刷新
 */
- (void) setPullRefresh:(BOOL)pullRefresh {
    // 如果需要下拉刷新
    if (pullRefresh) {
        // 如果没有创建refreshView，则创建
        if (!_refreshView) {
            _refreshView = [[SRefreshView alloc] initWithFrame:CGRectMake(0, -kSRefreshHeight, 320, kSRefreshHeight)];
            [_tableView insertSubview:_refreshView atIndex:0];
        }
    }
    // 如果不需要下拉刷新
    else {
        // 如果已经创建了下拉刷新控件，则销毁并且置为空
        if (_refreshView) {
            [_refreshView removeFromSuperview];
            _refreshView = nil;
        }
    }
    // 设置下拉刷新
    _pullRefresh = pullRefresh;
}


/// 下拉刷新TableView，或者刷新
- (void) refresh {
    if (_tableView.contentOffset.y != -kSRefreshHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.contentOffset = CGPointMake(0, -kSRefreshHeight);
            _tableView.contentInset = UIEdgeInsetsMake(kSRefreshHeight, 0, 0, 0);
        }];
    }

    if (_refreshViewState != SRefreshViewStateRefreshing) {
        [self startLoading];
    }
    else if (_refreshViewState == SRefreshViewStateRefreshing) {
        SLog(@"已经在刷新啦，亲");
        
    }
}


/// 当加载完毕之后界面做处理
- (void) reload {
    // do reloadData
    if (_pullRefresh) {
        [self finishLoading];
    }
    if ([_refreshDelegate respondsToSelector:@selector(didEndRefreshTableView:)]) {
        [_refreshDelegate didEndRefreshTableView:self.tableView];
    }
    [self.tableView reloadData];
}
/// 显示下拉刷洗空间
- (void) showLoading:(BOOL)show {
    if (show) {
        // 显示下拉刷新控件
        [self startLoading];
    }else {
        // 关闭下拉刷新控件
        [self finishLoading];
    }
}
/// 如果有错误。则关闭刷新，完成刷新
- (void)showError:(BOOL)show{
    // TODO: by subclass
    if (show) {
        [self finishLoading];
    }
}

#pragma mark === 私有方法 ===

/// 开始刷新，显示下拉刷新控件
- (void) startLoading {
    if (_pullRefresh) { // 如果启用下拉刷新
        // 修改当前状态为 正在刷新
        _refreshViewState = SRefreshViewStateRefreshing;
        // 通知 已经开始刷新啦。
        if ([_refreshDelegate respondsToSelector:@selector(didStartRefreshTableView:)]) {
            [_refreshDelegate didStartRefreshTableView : self.tableView];
        }
        // 通知 刷新组建要显示什么文字
        NSString * status = @"正在刷新...";
        if ([_refreshDelegate respondsToSelector:@selector(stringFromTableView:state:)]) {
            status = [_refreshDelegate stringFromTableView:self.tableView state:_refreshViewState];
        }
        [_refreshView didWhenStateChanged:_refreshViewState status:status];
    }
}

/// 完成刷新
- (void) finishLoading {
    if (!_pullRefresh) {
        return;
    }
    /// 1s以后隐藏下拉刷新控件
    [self performSelector:@selector(hideRefreshView) withObject:nil afterDelay:1];
}
/// 隐藏下拉刷新控件
- (void) hideRefreshView {
    // 修改刷新状态为已完成刷新
    _refreshViewState = SRefreshViewStateFinishRefresh;
    [_refreshView didWhenStateChanged:_refreshViewState status:nil];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        _tableView.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark === TableView DataSource ===
/// 默认没有任何数据，子类需重写
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
/// 默认没有任何数据，子类需重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark === 监听滑动至顶部 ===
/// 当滑动至顶部时按情况显示下拉刷新组建
- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
    // 如果未启动下拉刷新组建
    if (scrollView != _tableView || !_pullRefresh) {
        return;
    }
    // 得到下拉超出了多少
    CGPoint contentOffset = scrollView.contentOffset;
    NSString * status;
    if (_refreshViewState == SRefreshViewStateRefreshing) {
        if (contentOffset.y > 0) {
            _tableView.contentInset = UIEdgeInsetsZero;
        } else if (contentOffset.y >= -kSRefreshHeight) {
            _tableView.contentInset = UIEdgeInsetsMake(-contentOffset.y, 0, 0, 0);
        }
    } else if (contentOffset.y < 0) {
        if (contentOffset.y <= -kSRefreshHeight) {
            _refreshViewState = SRefreshViewStateReleaseToRefresh;
        } else {
            _refreshViewState = SRefreshViewStatePullCanRefresh;
        }
        if ([_refreshDelegate respondsToSelector:@selector(stringFromTableView:state:)]) {
            status = [_refreshDelegate stringFromTableView:self.tableView state:_refreshViewState];
        }
        [_refreshView didWhenStateChanged:_refreshViewState status:status];
    }
}
/// 结束刷新时 的动作
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 如果未启动下拉刷新组建
    if (!_pullRefresh || scrollView != _tableView) {
        return;
    }
    switch (_refreshViewState) {
            // 如果状态为 下拉可以刷新，则返回原处，不刷新
        case SRefreshViewStatePullCanRefresh:
            _refreshViewState = SRefreshViewStateBeforePull;
            break;
            // 如果状态为释放可以刷新，则开始刷新
        case SRefreshViewStateReleaseToRefresh:
            // 刷新
            [self refresh];
            break;
        default:
            break;
    }
}

#pragma mark === 下拉刷新的文字 ===

/**
 * @brief 该协议主要获取各个状态下SRefreshView需要显示的文字
 * @param tableView  触发该协议的tableView
 * @param state  该tableView 的下拉刷新所处的状态
 * @return 返回该状态(state)下需要展示在SRefreshView上的状态字符串
 * @note 如果您需要使用下拉刷新功能，并且不适用默认的下拉可以刷新等状态可以实现委托中的此方法
 */
- (NSString *) stringFromTableView:(UITableView *)tableView state:(SRefreshViewState)state {
    NSString * status;
    switch (state) {
        case SRefreshViewStatePullCanRefresh:
            status = @"下拉可以更新";
            break;
        case SRefreshViewStateRefreshing:
            status = @"正在刷新...";
            break;
        case SRefreshViewStateReleaseToRefresh:
            status = @"松开可以刷新";
            break;
        default:
            break;
    }
    return status;
}

@end
