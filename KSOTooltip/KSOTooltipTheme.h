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

/**
 KSOTooltipTheme manages the display properties of a KSOTooltipViewController that can be customized. Copying a theme returns a new theme with word @".copy" appended to its identifier. The default theme is provided using the `defaultTheme` class property.
 */
@interface KSOTooltipTheme : NSObject <NSCopying>

/**
 Set and get the default theme.
 
 The default theme uses the default return values described for the properties below.
 */
@property (class,strong,nonatomic,null_resettable) KSOTooltipTheme *defaultTheme;

/**
 Get the identifier of the receiver. Useful for debugging purposes.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 Set and get the status bar style used when the tooltip view controller is presented.
 
 The default value is UIStatusBarStyleDefault.
 */
@property (assign,nonatomic) UIStatusBarStyle statusBarStyle;

/**
 Set and get the background color that is displayed above the presenting view controller. This can be set to mirror the behavior of UIPopoverPresentationController so the background is dimmed.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) UIColor *backgroundColor;
/**
 Set and get the fill color that is used to draw the background of the tooltip and arrow if `arrowStyle` allows it.
 
 The default is nil, which means use the `tintColor` of the receiver.
 */
@property (strong,nonatomic,nullable) UIColor *fillColor;
/**
 Set and get the text color that is used to draw the tooltip text.
 
 The default is nil, which means use the appropriate contrasting color using KDI_contrastingColor against `fillColor`. With the default iOS tint color, this results in UIColor.whiteColor being used.
 */
@property (strong,nonatomic,nullable) UIColor *textColor;

/**
 Set and get the font used to draw the tooltip text.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *font;
/**
 Set and get the text style used to fetch the dynamic font used to draw the tooltip text. If this is non-nil, the tooltip text will respond to dynamic type changes and fetch its font using `[UIFont preferredFontForTextStyle:]`. If you wish to customize how the dynamic type font is fetched, see the Ditko/UIFont+KDIDynamicTypeExtensions.h header for more information.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) UIFontTextStyle textStyle;

/**
 Set and get the minimum edge insets for the tooltip view. This describes the minimum distance in points the tooltip view should be from the edges of the screen. The top member of this value is in addition to the status bar.
 
 The default is UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0).
 */
@property (assign,nonatomic) UIEdgeInsets minimumEdgeInsets;
/**
 Set and get the text edge insets for the tooltip text. This describes the distance from the edges of the tooltip background in which the text is drawn.
 
 The default is UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0).
 */
@property (assign,nonatomic) UIEdgeInsets textEdgeInsets;

/**
 Set and get the corner radius of the tooltip background view. This describes the corner radius of the rectangle behind the tooltip text, not the tooltip arrow.
 
 The default is 5.0.
 */
@property (assign,nonatomic) CGFloat cornerRadius;

/**
 Set and get the arrow style used when drawing the tooltip arrow.
 
 The default is KSOTooltipArrowStyleDefault, which means the arrow is drawn.
 */
@property (assign,nonatomic) KSOTooltipArrowStyle arrowStyle;
/**
 Set and get the arrow width.
 
 The default is 8.0.
 */
@property (assign,nonatomic) CGFloat arrowWidth;
/**
 Set and get the arrow height.
 
 The default is 8.0.
 */
@property (assign,nonatomic) CGFloat arrowHeight;

@property (assign,nonatomic) NSTimeInterval animationDuration;
@property (assign,nonatomic) CGFloat animationSpringDamping;
@property (assign,nonatomic) CGFloat animationInitialSpringVelocity;

/**
 The designated initializer.
 
 @param identifier The unique identifier for the theme
 @return The initialized instance
 */
- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
