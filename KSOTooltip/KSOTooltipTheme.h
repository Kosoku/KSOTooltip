//
//  KSOTooltipTheme.h
//  KSOTooltip
//
//  Created by William Towe on 9/18/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>
#import <KSOTooltip/KSOTooltipDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSOTooltipTheme : NSObject <NSCopying>

@property (class,readonly,nonatomic) KSOTooltipTheme *defaultTheme;

@property (readonly,copy,nonatomic) NSString *identifier;

@property (strong,nonatomic,nullable) UIColor *backgroundColor;
@property (strong,nonatomic,nullable) UIColor *fillColor;
@property (strong,nonatomic,nullable) UIColor *textColor;

@property (strong,nonatomic,null_resettable) UIFont *font;
@property (copy,nonatomic,nullable) UIFontTextStyle textStyle;

@property (assign,nonatomic) UIEdgeInsets minimumEdgeInsets;

@property (assign,nonatomic) CGFloat cornerRadius;

@property (assign,nonatomic) KSOTooltipArrowStyle arrowStyle;
@property (assign,nonatomic) CGFloat arrowWidth;
@property (assign,nonatomic) CGFloat arrowHeight;

- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
