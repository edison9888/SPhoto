//
//  RVToolsTaberCell.h
//  RenrenVoice
//
//  Created by wang lei on 12-8-21.
//  Copyright (c) 2012年 Renren Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RVToolsTaberCell : UIView{
    float topPadding;
    float bottomPadding;
    float leftPadding;
    float rightPadding;
    
    float buttonHeight;
    float descriptionHeight;
}

@property(nonatomic,strong)UIButton* functionButton;
@property(nonatomic,strong)NSString* functionDescription;



-(id)initWithFrame:(CGRect)frame Button:(UIButton*)button buttonPostionInfo:(NSDictionary*)info;

@end
