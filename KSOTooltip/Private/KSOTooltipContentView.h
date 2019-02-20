//
//  KSOTooltipContentView.h
//  KSOTooltip-iOS
//
//  Created by William Towe on 10/11/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <UIKit/UIKit.h>
#import "KSOTooltipView.h"

NS_ASSUME_NONNULL_BEGIN

@class KSOTooltipTheme;
@protocol KSOTooltipContentViewDelegate;

@interface KSOTooltipContentView : UIView

@property (weak,nonatomic,nullable) id<KSOTooltipContentViewDelegate> delegate;

@property (strong,nonatomic) KSOTooltipTheme *theme;
@property (assign,nonatomic) KSOTooltipArrowDirection arrowDirection;
@property (assign,nonatomic) KSOTooltipDismissOptions dismissOptions;

@property (weak,nonatomic) UIView *sourceView;
@property (strong,nonatomic,nullable) __kindof UIView<KSOTooltipViewAccessory> *accessoryView;

@property (readonly,strong,nonatomic) UITextView *label;

@end

@protocol KSOTooltipContentViewDelegate <NSObject>
@required
- (void)tooltipContentViewDidTapToDismiss:(KSOTooltipContentView *)view;
@end

NS_ASSUME_NONNULL_END
