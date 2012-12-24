//
//  SUIExtensions.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-22.
//
//


#import "SActionSheet.h"

@interface SheetItemView ()

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, strong) UIColor * highlightColor;


@property (nonatomic, assign) SheetButtonType sheetItemType;

@end

@implementation SheetItemView

- (id) init {
    CGRect rect = CGRectMake(0, 0, kSheetButtonWidth, kSheetButtonHeight);
    self = [super initWithFrame:CGRectMake(0, 0, kSheetButtonWidth, kSheetButtonHeight)];
    if (self) {
        self.sheetButton = [SButton buttonWithType:UIButtonTypeCustom];
        self.sheetButton.frame = rect;
        [self addSubview:self.sheetButton];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:kSheetButtonIconRect];
        [self.sheetButton addSubview:self.iconImageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 0, kSheetButtonWidth-60.0f, kSheetButtonHeight)];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = UIFontWithName(kFontNameHelvetica, 15.0f);
        self.textLabel.textColor = UIColorWithRGB(0x666666);
        self.textLabel.highlightedTextColor = UIColorWithRGB(0xFFFFFF);
        [self.sheetButton addSubview:self.textLabel];

    }
    return self;
}

- (void) setSheetButtonType:(SheetButtonType) sheetType {
    [self.sheetButton setColor:UIColorWithRGB(0xF3F3F3) highlightColor:UIColorWithRGB(0xCB553B)];
    switch (sheetType) {
        case SheetButtonCancel:
            self.iconImageView.image = [UIImage imageNamed:@"actionsheet_icon_cancel_normal.png"];
            self.iconImageView.highlightedImage = [UIImage imageNamed:@"actionsheet_icon_cancel_highlight.png"];
            self.textLabel.text = @"Cancel";
            self.textLabel.textColor = UIColorWithRGB(0xCB553B);
            break;
        case SheetButtonDelete:
            self.iconImageView.image = [UIImage imageNamed:@"actionsheet_icon_delete_normal.png"];
            self.iconImageView.highlightedImage = [UIImage imageNamed:@"actionsheet_icon_delete_highlight.png"];
            self.textLabel.text = @"Delete";
            break;
        case SheetButtonRefrsh:
            self.iconImageView.image = [UIImage imageNamed:@"actionsheet_icon_refresh_normal.png"];
            self.iconImageView.highlightedImage = [UIImage imageNamed:@"actionsheet_icon_refresh_highlight.png"];
            self.textLabel.text = @"Refresh";
            break;
        case SheetButtonPhoto:
            self.iconImageView.image = [UIImage imageNamed:@"actionsheet_icon_photo_normal.png"];
            self.iconImageView.highlightedImage = [UIImage imageNamed:@"actionsheet_icon_photo_highlight.png"];
            self.textLabel.text =@"Photo Library";
            break;
        case SheetButtonCamera:
            self.iconImageView.image = [UIImage imageNamed:@"actionsheet_icon_camera_normal.png"];
            self.iconImageView.highlightedImage = [UIImage imageNamed:@"actionsheet_icon_camera_highlight.png"];
            self.textLabel.text = @"Camera";
            break;
        default:
            break;
    }
}

@end

@interface SActionSheet ()

@property (nonatomic, assign) id<SActionSheetDelegate> delegate;

/// 该ActionSheet显示所以来的window
@property (nonatomic, strong) SWindow * window;
/// 点击空白区域消失
@property (nonatomic, strong) UIButton * dismissButton;
/// 该ActionSheet背景View
@property (nonatomic, strong) UIView * backgroundView;

/// 整个actionSheet的高度
@property (nonatomic, assign) CGFloat actionSheetHeight;
/// 整个actionSheet所显示按钮的区域。底部
@property (nonatomic, strong) UIView * contentView;

/// 整个actionSheet的头部区域。包括阴影分割线，title
@property (nonatomic, strong) UIView * topView;
/// 该ActionSheet头部阴影
@property (nonatomic, strong) UIImageView * topShadowView;
/// 该ActionSheet的文字区域
@property (nonatomic, strong) UIView * titleView;
/// 该ActionSheet的标题
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) CGFloat titleHeight;
/// 当前action是否在显示
@property (nonatomic, assign) BOOL visible;
/// 是否需要取消按钮
@property (nonatomic, assign) BOOL cancelButton;
/// 屏幕高度
@property (nonatomic, assign) CGRect mainBounds;
/// 当点击任意sheetButton时的回调
@property (nonatomic, copy) SActionSheetHandler dismissHandler;

/**
 * @brief 绘制actionSheet。填充底部的按钮等
 */
- (void) createActionSheet;

/**
 * @brief 创建取消按钮。
 */
- (SheetItemView *) createCancelButton;

/**
 * @brief 根据type创建按钮类型
 *
 * @param type 当前按钮的类型
 */
- (SheetItemView *) createSheetButtonWithType:(SheetButtonType) type;

/**
 * @brief 展示当前ActionSheet
 */
- (void) presentActionSheet;

/**
 * @brief 当action即将出现时会调用此方法
 */
- (void) actionSheetWillAppear;

/**
 * @brief 关闭当前actionSheet
 */
- (void) dismissActionSheet;

/**
 * @brief 当前actionSheet即将关闭时会调用此方法
 */
- (void) actionSheetWillDisappear;

/**
 * @brief actionSheet 上的所有按钮点击所产生的事件
 *
 * @brief sender 产生事件的按钮
 */
- (void) didClickWithButton:(id) sender;

@end

/**
 * @brief ActionSheet 弹出式组建。参见系统的UIActionSheet
 */
@implementation SActionSheet

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
otherSheetItemTypes:(SheetButtonType) aSheetItemType, ... {
    
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.numberOfSheetButtons = 0;
        self.selectedIndex = -1;
        
        self.title = title;
        self.delegate = delegate;
        
        self.titleHeight = 0.0f;
        UIFont * titleFont = UIFontWithName(kFontNameHelveticaBold, 18.0f);
        if (self.title) {
            CGSize size = [self.title sizeWithFont:titleFont constrainedToSize:CGSizeMake(280, 100) lineBreakMode:NSLineBreakByWordWrapping];
            self.titleHeight = size.height + 20;
        } else {
            self.titleHeight = 2.0f;
        }
        
        
        self.mainBounds = [UIScreen mainScreen].bounds;
        self.frame = self.mainBounds;
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.mainBounds];
        self.backgroundView.backgroundColor = UIColorWithRGB(0x000000);
        [self addSubview:self.backgroundView];
        
        
        self.sheetButtonArray = [NSMutableArray arrayWithCapacity:20];
        
        SheetButtonType arg;
        va_list args;
        if(aSheetItemType) {
            [self createSheetButtonWithType:aSheetItemType];
            va_start(args,aSheetItemType);
            while((arg = va_arg(args,SheetButtonType))) {
                [self createSheetButtonWithType:arg];
            }
            va_end(args);
        }
        //// 总高度为 头部高度+(每个Cell的高度+分割线高度) * count +cancel的高度
        self.actionSheetHeight = kSheetTopShadowHeight + self.titleHeight + self.numberOfSheetButtons * (kSheetButtonHeight+kSheetButtonSepartorHeight);
        
        self.cancelButton = !!cancelSheetItemType;
        if (self.cancelButton) {
            self.cancelSheetButton = [self createCancelButton];
            self.actionSheetHeight += kSheetButtonHeight;
        }
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainBounds.size.height - self.actionSheetHeight, 320, self.actionSheetHeight)];
        [self addSubview:self.contentView];
        
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSheetButtonWidth, kSheetTopShadowHeight + self.titleHeight)];
        self.topView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.topView];
        
        self.topShadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSheetButtonWidth, kSheetTopShadowHeight)];
        self.topShadowView.image = [UIImage imageNamed:@"actionsheet_top_shadow.png"];
        [self.topView addSubview:self.topShadowView];
        
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kSheetTopShadowHeight, 320,self.titleHeight)];
        self.titleView.backgroundColor = UIColorWithRGB(0xCB553B);
        [self.topView addSubview:self.titleView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, self.titleHeight)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = self.title;
        self.titleLabel.clipsToBounds = YES;
        self.titleLabel.font = titleFont;
        [self.titleView addSubview:self.titleLabel];
        
        
        [self createActionSheet];
        
        
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.dismissButton.tag = self.cancelSheetButton.sheetButton.tag;
        self.dismissButton.frame = CGRectMake(0, 0, self.mainBounds.size.width, self.mainBounds.size.height - self.actionSheetHeight);
        [self.dismissButton addTarget:self action:@selector(didClickWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.dismissButton];
    }
    
    return self;
}

- (void) setModalSheet:(BOOL)modalSheet {
    _modalSheet = modalSheet;
    self.dismissButton.hidden = modalSheet;
}

/**
 * @brief 创建取消按钮。
 */
- (SheetItemView *) createCancelButton {
    SheetItemView * itemView = [[SheetItemView alloc] init];
    [itemView setSheetButtonType:SheetButtonCancel];
    itemView.sheetButton.tag = self.numberOfSheetButtons;
    itemView.sheetButton.exclusiveTouch = YES;
    [itemView.sheetButton addTarget:self action:@selector(didClickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    return itemView;
}

/**
 * @brief 根据type创建按钮类型
 *
 * @param type 当前按钮的类型
 */
- (SheetItemView *) createSheetButtonWithType:(SheetButtonType) type {
    SheetItemView * itemView = [[SheetItemView alloc] init];
    [itemView setSheetButtonType:type];
    itemView.sheetButton.tag = self.numberOfSheetButtons;
    itemView.sheetButton.exclusiveTouch = YES;
    [itemView.sheetButton addTarget:self action:@selector(didClickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetButtonArray addObject:itemView];
    self.numberOfSheetButtons ++;
    return itemView;
}

/**
 * @brief 显示当前ActionSheet，会在点击任意按钮之后dismiss。
 */
- (void) show {
    [self showWithDismissHandler:NULL];
}

/**
 * @brief 显示ActionSheet。
 *
 * @param dismissHandler  按钮点击之后该ActionSheet会消失，消失的过程中会调用此方法
 */
- (void) showWithDismissHandler:(SActionSheetHandler) dismissHandler {
    if (self.visible) {
        return;
    } else {
        self.visible = YES;
        [self presentActionSheet];
    }
    if (dismissHandler) {
        self.dismissHandler = dismissHandler;
    }
}

/**
 * @brief actionSheet 上的所有按钮点击所产生的事件
 *
 * @brief sender 产生事件的按钮
 */
- (void) didClickWithButton:(UIButton *) sender {
    NSInteger tag = sender.tag;
    self.selectedIndex = tag;
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:self.selectedIndex];
    }
    [self dismissActionSheet];
}

/**
 * @brief 展示当前ActionSheet
 */
- (void) presentActionSheet {
    self.window = [[SWindow alloc] initWithFrame:self.mainBounds];
    self.window.windowLevel = UIWindowLevelAlert;
    [self.window addSubview:self];
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [self.delegate willPresentActionSheet:self];
    }
    [self actionSheetWillAppear];

}

/**
 * @brief 当action即将出现时会调用此方法
 */
- (void) actionSheetWillAppear {
    self.contentView.top = self.mainBounds.size.height;
    self.backgroundView.alpha = 0.0;
    [self.window makeKeyAndVisible];
    [UIView animateWithDuration:0.30f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentView.top = self.mainBounds.size.height -  self.actionSheetHeight;
        self.backgroundView.alpha = 0.3;
    } completion:^(BOOL finished) {
        self.contentView.top = self.mainBounds.size.height -  self.actionSheetHeight;
        self.backgroundView.alpha = 0.3;
        if ([self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
            [self.delegate didPresentActionSheet:self];
        }
    }];
}

/**
 * @brief 关闭当前actionSheet
 */
- (void) dismissActionSheet {
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:self.selectedIndex];
    }
    [self actionSheetWillDisappear];
    
}

/**
 * @brief 当前actionSheet即将关闭时会调用此方法
 */
- (void) actionSheetWillDisappear {
//    RVActionSheet __block * actionSheet = self;
    [UIView animateWithDuration:0.30 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.contentView.top = self.mainBounds.size.height;
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.contentView.top = self.mainBounds.size.height;
        self.backgroundView.alpha = 0.0;
        if (self.selectedIndex != -1) {
            self.visible = NO;
            if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
                [self.delegate actionSheet:self didDismissWithButtonIndex:self.selectedIndex];
            }
            if (self.dismissHandler) {
                self.dismissHandler(self,self.selectedIndex);
            }
        }
        [self removeFromSuperview];
        self.window = nil;
    }];
}


/**
 * @brief 绘制actionSheet。填充底部的按钮等
 */
- (void) createActionSheet {
    
    CGFloat top = kSheetTopShadowHeight + self.titleHeight;
    
    for (SheetItemView * itemView in self.sheetButtonArray) {
        CGRect sheetRect = itemView.frame;
        sheetRect.origin.y = top;
        itemView.frame = sheetRect;
        [self.contentView addSubview:itemView];
        top += kSheetButtonHeight;
        UIImageView * separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, top, 320, kSheetButtonSepartorHeight)];
        separatorView.image = [UIImage imageNamed:@"actionsheet_separator.png"];
        [self.contentView addSubview:separatorView];
        top += kSheetButtonSepartorHeight;
        
    }
    if (self.cancelSheetButton) {
        self.cancelSheetButton.frame = CGRectMake(0, top, 320, kSheetButtonHeight);
        [self.contentView addSubview:self.cancelSheetButton];
        top += kSheetButtonHeight;
    }
}


@end
