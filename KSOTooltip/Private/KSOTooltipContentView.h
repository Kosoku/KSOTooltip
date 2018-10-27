//
//  KSOTooltipContentView.h
//  KSOTooltip-iOS
//
//  Created by William Towe on 10/11/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
