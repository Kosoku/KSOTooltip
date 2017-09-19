//
//  KSOTooltipViewController.h
//  KSOTooltip
//
//  Created by William Towe on 9/16/17.
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

@class KSOTooltipTheme;
@protocol KSOTooltipViewControllerDelegate;

/**
 KSOTooltipViewController is a view controller subclass that displays tooltip text in a rounded bubble with arrow attached to either a UIView or UIBarButtonItem. It can optionally display an accessory view below the tooltip text.
 */
@interface KSOTooltipViewController : UIViewController

/**
 Set and get the delegate.
 
 The default is nil.
 
 @see KSOTooltipViewControllerDelegate
 */
@property (weak,nonatomic,nullable) id<KSOTooltipViewControllerDelegate> delegate;

/**
 Set and get the theme.
 
 The default is KSOTooltipTheme.defaultTheme.
 
 @see KSOTooltipTheme
 */
@property (strong,nonatomic,null_resettable) KSOTooltipTheme *theme;

/**
 Set and get the tooltip text.
 */
@property (copy,nonatomic) NSString *text;
/**
 Set and get the tooltip attributed text.
 */
@property (copy,nonatomic) NSAttributedString *attributedText;

/**
 Set and get the allowed arrow directions for presenting. This is only a suggestion, if the tooltip text + accessory view will not fit, another direction will be used.
 
 The default is KSOTooltipArrowDirectionAll.
 */
@property (assign,nonatomic) KSOTooltipArrowDirection allowedArrowDirections;
/**
 Get the arrow direction being used to display the tooltip. Before the view controller is presented, this is KSOTooltipArrowDirectionUnknown.
 */
@property (readonly,nonatomic) KSOTooltipArrowDirection arrowDirection;

/**
 Set and get the source view from which to display the tooltip. Either `sourceView` or `barButtonItem` must be set to non-nil before presenting the view controller.
 */
@property (strong,nonatomic,nullable) UIView *sourceView;
/**
 Set and get the source rect, relative to the `sourceView`, from which to display the tooltip. If this is CGRectZero, it is assumed to mean the bounds of `sourceView`.
 */
@property (assign,nonatomic) CGRect sourceRect;

/**
 Set and get the bar button item from which to display the tooltip. Either `barButtonItem` or `sourceView` must be set to non-nil before presenting the view controller.
 */
@property (strong,nonatomic,nullable) UIBarButtonItem *barButtonItem;

/**
 Set and get the accessory view to be displayed below the tooltip text. The accessory view should either implement sizeThatFits: or override requiresConstraintBasedLayout to return YES and have appropriate layout constraints active to determine its size.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) UIView *accessoryView;

@end

@protocol KSOTooltipViewControllerDelegate <NSObject>
@optional
/**
 Returns whether the tooltip view controller should be dismissed. Return NO to prevent the dismissal.
 
 @param tooltipViewController The sender of the message
 @return YES if the view controller should be dismissed, otherwise NO
 */
- (BOOL)tooltipViewControllerShouldDismiss:(KSOTooltipViewController *)tooltipViewController;
/**
 Called right before the tooltip view controller is dismissed.
 
 @param tooltipViewController The sender of the message
 */
- (void)tooltipViewControllerWillDismiss:(KSOTooltipViewController *)tooltipViewController;
/**
 Called after the tooltip view controller is dismissed.
 
 @param tooltipViewController The sender of the message
 */
- (void)tooltipViewControllerDidDismiss:(KSOTooltipViewController *)tooltipViewController;
@end

NS_ASSUME_NONNULL_END
