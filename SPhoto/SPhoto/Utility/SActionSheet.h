//
//  SActionSheet.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-22.
//
//


#import "SButton.h"
#import "SWindow.h"

#define kSheetTopHeight 5.0f
#define kSheetTopShadowHeight 3.0f
#define kSheetButtonWidth 320.0f
#define kSheetButtonHeight 50.0f
#define kSheetButtonSepartorHeight 1.0f

#define kSheetButtonIconRect CGRectMake(25,15,20,20)

/**
 * @brief 枚举出部分SheetItem的样式
 */
typedef enum _SheetButtonType:NSInteger {
    /// 删除。左边删除图标，右边文字Delete
    RVSheetButtonDelete       = 1 << 1,
    /// 刷新。
    RVSheetButtonRefrsh       = 1 << 2,
    /// 相册
    RVSheetButtonPhoto        = 1 << 3,
    /// 照相机
    RVSheetButtonCamera       = 1 << 4,
    
    /// 取消按钮
    RVSheetButtonCancel       = 1 << 10,
    
} SheetButtonType;

/**
 * @brief SheetItem中的Item
 */
@interface SheetItemView : UIView
/// sheetItem的背景按钮
@property (nonatomic, strong) SButton * sheetButton;
/// sheetItem的图标区域
@property (nonatomic, strong) UIImageView * iconImageView;
/// sheetItem的文字区域
@property (nonatomic, strong) UILabel * textLabel;

/**
 * @brief 设置当前的按钮类型
 *
 * @param sheetType 参见RVSheetButtonType
 */
- (void) setSheetButtonType:(SheetButtonType) sheetType;

@end

@protocol SActionSheetDelegate;
@class SActionSheet;

/**
 * @brief ActionSheet的回调
 *
 * @param actionSheet 当前点击按钮的actionSheet
 * @param dismissedIndex 当前点击按钮的序号。从 顶向下 分别为 0,1,2,3,4
 */
typedef void (^SActionSheetHandler)(SActionSheet * actionSheet,int dismissedIndex);

/**
 * @brief ActionSheet 弹出式组建。参见系统的UIActionSheet
 *
 * eg.
 * RVActionSheet * actionSheet = [[RVActionSheet alloc] initWithTitle:nil delegate:self cancelSheetItemType:RVSheetButtonCancel otherSheetItemTypes:RVSheetButtonCamera,RVSheetButtonPhoto, nil];
 * [actionSheet show]; // or [actionSheet showWithDismissHandler:handler];
 */
@interface SActionSheet : UIView

/// 当前ActionSheet的标题
@property (nonatomic, copy) NSString * title;
/// 当前ActionSheet共有多少个按钮。不包括cancel按钮
@property (nonatomic, assign) NSInteger numberOfSheetButtons;
/// 当前ActionSheet所选中的按钮。选中之后即将dismiss
@property (nonatomic, assign) NSInteger selectedIndex;
/// 取消按钮
@property (nonatomic, strong) SheetItemView * cancelSheetButton;
/// 取消按钮上面的所有按钮
@property (nonatomic, strong) NSMutableArray * sheetButtonArray;
/// 是否为模态框
@property (nonatomic, assign) BOOL modalSheet;


/**
 * @brief 构造标题为title按钮为XXX的ActionSheet。目前ActionSheet中的所有按钮类型均在枚举 RVSheetButtonType中。请参见 RVSheetButtonType
 *
 * @param title 该ActionSheet的标题，会显示在最上面
 * @param delegate 该ActionSheet点击事件的委托。参见RVActionSheetDelegate
 * @param cancelSheetItemType   取消按钮类型（目前不需要设置其他类型。设置RVSheetButtonCancel即可，如果不需要，则设置0）
 * @param aSheetItemType 其它按钮类型，中间用,隔开，将从上之下排列在该ActionSheet上
 */
- (id)initWithTitle:(NSString *) title
           delegate:(id<SActionSheetDelegate>)delegate
    cancelSheetItemType:(SheetButtonType) cancelSheetItemType
    otherSheetItemTypes:(SheetButtonType) aSheetItemType, ...__attribute__((sentinel(0,1)));

/**
 * @brief 显示当前ActionSheet，会在点击任意按钮之后dismiss。
 */
- (void) show;

/**
 * @brief 显示ActionSheet。
 *
 * @param dismissHandler  按钮点击之后该ActionSheet会消失，消失的过程中会调用此方法
 */
- (void) showWithDismissHandler:(SActionSheetHandler) dismissHandler;

@end


/**
 * @brief RVActionSheet 所产生的毁掉方法
 */
@protocol SActionSheetDelegate <NSObject>

@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(SActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(SActionSheet *)actionSheet;

- (void)willPresentActionSheet:(SActionSheet *)actionSheet;  // before animation and showing view

- (void)didPresentActionSheet:(SActionSheet *)actionSheet;  // after animation

- (void)actionSheet:(SActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)actionSheet:(SActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end


