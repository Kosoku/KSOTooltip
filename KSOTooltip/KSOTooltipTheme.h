//
//  KSOTooltipTheme.h
//  KSOTooltip
//
//  Created by William Towe on 9/18/17.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
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
 
 The default is UIFontTextStyleFootnote.
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

/**
 The duration used for present and dismiss animations.
 
 The default is 0.33.
 */
@property (assign,nonatomic) NSTimeInterval animationDuration;
/**
 The spring damping used for the present animation.
 
 The default is 0.5.
 */
@property (assign,nonatomic) CGFloat animationSpringDamping;
/**
 The initial spring velocity used for the present animation.
 
 The default is 0.0.
 */
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
