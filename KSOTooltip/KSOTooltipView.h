//
//  KSOTooltipView.h
//  KSOTooltip
//
//  Created by William Towe on 9/16/17.
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
#import <Stanley/KSTDefines.h>
#import <KSOTooltip/KSOTooltipDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOTooltipTheme;
@protocol KSOTooltipViewDelegate, KSOTooltipViewAccessory;

/**
 KSOTooltipView represents a tooltip attached to a source view or source bar button item. It provides styling features through its theme property. See KSOTooltipTheme for more information.
 */
@interface KSOTooltipView : UIView

/**
 Set and get the delegate.
 
 @see KSOTooltipViewDelegate
 */
@property (weak,nonatomic,nullable) id<KSOTooltipViewDelegate> delegate;

/**
 Set and get the theme.
 
 The default is KSOTooltipTheme.defaultTheme.
 */
@property (strong,nonatomic,null_resettable) KSOTooltipTheme *theme;

/**
 Set and get the allowed arrow directions for presentation. Similar to UIPopoverArrowDirection.
 
 The receiver will override this value if the tooltip won't fit on the screen with the value originally provided. Setting this to KSOTooltipArrowDirectionUnknown will reset it to the default.
 
 The default is KSOTooltipArrowDirectionAll.
 */
@property (assign,nonatomic) KSOTooltipArrowDirection allowedArrowDirections;

/**
 Set and get the dismiss options for the receiver.
 
 The default is KSOTooltipDismissOptionsDefault.
 
 @see KSOTooltipDismissOptions
 */
@property (assign,nonatomic) KSOTooltipDismissOptions dismissOptions;
/**
 Set and get the dismiss delay for the receiver. This is only relevant if dismissOptions contains KSOTooltipDismissOptionsAutomaticallyAfterDelay.
 
 The default is 2.5.
 */
@property (assign,nonatomic) NSTimeInterval dismissDelay;

/**
 Set and get the tooltip text.
 
 You must set this or attributedText before presenting the receiver.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSString *text;
/**
 Set and get the tooltip attributeds text.
 
 You must set this or attributedText before presenting the receiver.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSAttributedString *attributedText;

/**
 Set and get the source bar button item.
 
 Useful for presenting a tooltip tied to a bar button item. Similar to UIPopoverPresentationController. You must set sourceBarButtonItem or sourceView before presenting the receiver.
 
 The default is nil.
 */
@property (weak,nonatomic,nullable) UIBarButtonItem *sourceBarButtonItem;
/**
 Set and get the source view.
 
 You must set sourceBarButtonItem or sourceView before presenting the receiver.
 
 The default is nil.
 */
@property (weak,nonatomic,nullable) UIView *sourceView;

/**
 Set and get the accessory view to be displayed along with the tooltip text.
 
 The accessory view will be pinned to the leading, trailing, and bottom edges of the tooltip content view.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) __kindof UIView<KSOTooltipViewAccessory> *accessoryView;

/**
 Convenience initializer providing *text*, *sourceBarButtonItem* or *sourceView*.
 
 @param text The tooltip text
 @param sourceBarButtonItem The bar button item to attach the tooltip to
 @param sourceView The view to attach the tooltip to
 @return The initialized instance
 */
+ (instancetype)tooltipViewWithText:(NSString *)text sourceBarButtonItem:(nullable UIBarButtonItem *)sourceBarButtonItem sourceView:(nullable UIView *)sourceView;
/**
 Convenience initializer providing *attributedText*, *sourceBarButtonItem* or *sourceView*.
 
 @param attributedText The tooltip attributed text
 @param sourceBarButtonItem The bar button item to attach the tooltip to
 @param sourceView The view to attach the tooltip to
 @return The initialized instance
 */
+ (instancetype)tooltipViewWithAttributedText:(NSAttributedString *)attributedText sourceBarButtonItem:(nullable UIBarButtonItem *)sourceBarButtonItem sourceView:(nullable UIView *)sourceView;

/**
 Present the receiver, optionally *animated*, and invoke *completion* when the animation completes.
 
 @param animated Whether to animate the present animation
 @param completion The completion block to invoke when the animation finishes
 */
- (void)presentAnimated:(BOOL)animated completion:(nullable KSTVoidBlock)completion;
/**
 Dismiss the receiver, optionally *animated*, and invoke the *completion* when the animation completes.
 
 @param animated Whether to animate the dismiss animation
 @param completion The completion block to invoke when the animation finishes
 */
- (void)dismissAnimated:(BOOL)animated completion:(nullable KSTVoidBlock)completion;

@end

@protocol KSOTooltipViewDelegate <NSObject>
@optional
/**
 Called to determine if the tooltip view should dismiss itself.
 
 Even if this returns NO, you can always dismiss the tooltip view programatically.
 
 @param view The sender of the message
 @return Whether to dismiss the tooltip view
 */
- (BOOL)tooltipViewShouldDismiss:(KSOTooltipView *)view;
/**
 Called right before the tooltip view is dismissed.
 
 @param view The sender of the message
 */
- (void)tooltipViewWillDismiss:(KSOTooltipView *)view;
/**
 Called right after the tooltip view is dismissed, immediately before it is removed the view hierarchy.
 
 @param view The sender of the message
 */
- (void)tooltipViewDidDismiss:(KSOTooltipView *)view;
@end

/**
 Protocol describing an object that can be set as the accessory view of a KSOTooltipView instance.
 */
@protocol KSOTooltipViewAccessory <NSObject>
@optional
/**
 Will be set with the owning tooltip view instance so the accessory view can refer back to it.
 */
@property (weak,nonatomic) KSOTooltipView *tooltipView;
@end

/**
 To silence the compiler warning you would otherwise get by setting a UIView subclass that does not declare conformance to the protocol.
 */
@interface UIView (KSOTooltipViewExtensions) <KSOTooltipViewAccessory>
@end

NS_ASSUME_NONNULL_END
