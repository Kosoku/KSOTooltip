//
//  KSOTooltipViewController.m
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

#import "KSOTooltipViewController.h"
#import "KSOTooltipAnimation.h"
#import "KSOTooltipView.h"
#import "NSBundle+KSOTooltipPrivateExtensions.h"
#import "KSOTooltipPresentationController.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOTooltipViewController () <KDIDynamicTypeObject,UIViewControllerTransitioningDelegate>
@property (strong,nonatomic) UIButton *dismissButton;
@property (strong,nonatomic) KSOTooltipView *tooltipView;

- (BOOL)_getRect:(CGRect *)outRect sourceRect:(CGRect)sourceRect allowedArrowDirections:(KSOTooltipArrowDirection)allowedArrowDirections;
@end

@implementation KSOTooltipViewController
#pragma mark *** Subclass Overrides ***
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}
- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}
#pragma mark -
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    [self setTransitioningDelegate:self];
    
    _textStyle = UIFontTextStyleFootnote;
    _minimumEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    _allowedArrowDirections = KSOTooltipArrowDirectionAll;
    
    _tooltipView = [[KSOTooltipView alloc] initWithFrame:CGRectZero];
    
    [NSObject KDI_registerDynamicTypeObject:self forTextStyle:_textStyle];
    
    return self;
}
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDismissButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.dismissButton setAccessibilityLabel:NSLocalizedStringWithDefaultValue(@"DISMISS_BUTTON_ACCESSIBILITY_LABEL", nil, [NSBundle KSO_tooltipFrameworkBundle], @"Close", @"dismiss button accessibility label")];
    [self.dismissButton setAccessibilityHint:NSLocalizedStringWithDefaultValue(@"DISMISS_BUTTON_ACCESSIBILITY_HINT", nil, [NSBundle KSO_tooltipFrameworkBundle], @"Close the tooltip", @"dismiss button accessibility hint")];
    [self.dismissButton addTarget:self action:@selector(_dismissButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    [self.view addSubview:self.tooltipView];
}
- (void)viewDidLayoutSubviews {
    if (self.isBeingDismissed) {
        return;
    }
    
    [self.dismissButton setFrame:self.view.bounds];
    
    UIView *sourceView;
    
    if (self.sourceView != nil) {
        sourceView = self.sourceView;
    }
    else if (self.barButtonItem != nil) {
        if (self.barButtonItem.customView != nil) {
            sourceView = self.barButtonItem.customView;
        }
        else if ([self.barButtonItem respondsToSelector:@selector(view)]) {
            id view = [self.barButtonItem valueForKey:@"view"];
            
            if ([view isKindOfClass:UIView.class]) {
                sourceView = view;
            }
        }
    }
    
    NSAssert(sourceView != nil, @"sourceView or barButtonItem must not be nil!");
    
    CGRect sourceRect = CGRectIsEmpty(self.sourceRect) ? sourceView.bounds : self.sourceRect;
    
    [self.tooltipView setSourceView:sourceView];
    [self.tooltipView setSourceRect:sourceRect];
    
    sourceRect = [self.view convertRect:[self.view.window convertRect:[sourceView convertRect:sourceRect toView:nil] fromWindow:nil] fromView:nil];
    
    CGRect rect = CGRectZero;
    KSOTooltipArrowDirection direction = self.allowedArrowDirections;
    
    while (![self _getRect:&rect sourceRect:sourceRect allowedArrowDirections:direction]) {
        direction &= ~self.tooltipView.arrowDirection;
        
        if (direction == KSOTooltipArrowDirectionUnknown) {
            direction = KSOTooltipArrowDirectionAll;
        }
    }
    
    [self.tooltipView setFrame:rect];
}
#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    KSOTooltipAnimation *retval = [[KSOTooltipAnimation alloc] init];
    
    [retval setPresenting:YES];
    [retval setTooltipView:self.tooltipView];
    
    return retval;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    KSOTooltipAnimation *retval = [[KSOTooltipAnimation alloc] init];
    
    [retval setTooltipView:self.tooltipView];
    
    return retval;
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    KSOTooltipPresentationController *retval = [[KSOTooltipPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
    [retval setBackgroundColor:self.backgroundColor];
    
    return retval;
}
#pragma mark KDIDynamicTypeObject
- (SEL)dynamicTypeSetFontSelector {
    return @selector(setFont:);
}
#pragma mark *** Public Methods ***
#pragma mark Properties
@dynamic text;
- (NSString *)text {
    return self.tooltipView.text;
}
- (void)setText:(NSString *)text {
    [self.tooltipView setText:text];
}
@dynamic fillColor;
- (UIColor *)fillColor {
    return self.tooltipView.fillColor;
}
- (void)setFillColor:(UIColor *)fillColor {
    [self.tooltipView setFillColor:fillColor];
}
@dynamic textColor;
- (UIColor *)textColor {
    return self.tooltipView.textColor;
}
- (void)setTextColor:(UIColor *)textColor {
    [self.tooltipView setTextColor:textColor];
}
@dynamic font;
- (UIFont *)font {
    return self.tooltipView.font;
}
- (void)setFont:(UIFont *)font {
    [self.tooltipView setFont:font];
    
    if (self.isViewLoaded) {
        [self.view setNeedsLayout];
    }
}
- (void)setTextStyle:(UIFontTextStyle)textStyle {
    _textStyle = textStyle;
    
    if (_textStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self forTextStyle:_textStyle];
    }
}
- (KSOTooltipArrowDirection)arrowDirection {
    return self.tooltipView.arrowDirection;
}
@dynamic arrowStyle;
- (KSOTooltipArrowStyle)arrowStyle {
    return self.tooltipView.arrowStyle;
}
- (void)setArrowStyle:(KSOTooltipArrowStyle)arrowStyle {
    [self.tooltipView setArrowStyle:arrowStyle];
}
@dynamic arrowWidth;
- (CGFloat)arrowWidth {
    return self.tooltipView.arrowWidth;
}
- (void)setArrowWidth:(CGFloat)arrowWidth {
    [self.tooltipView setArrowWidth:arrowWidth];
}
@dynamic arrowHeight;
- (CGFloat)arrowHeight {
    return self.tooltipView.arrowHeight;
}
- (void)setArrowHeight:(CGFloat)arrowHeight {
    [self.tooltipView setArrowHeight:arrowHeight];
}
@dynamic cornerRadius;
- (CGFloat)cornerRadius {
    return self.tooltipView.cornerRadius;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.tooltipView setCornerRadius:cornerRadius];
}
@dynamic accessoryView;
- (UIView *)accessoryView {
    return self.tooltipView.accessoryView;
}
- (void)setAccessoryView:(UIView *)accessoryView {
    [self.tooltipView setAccessoryView:accessoryView];
}
#pragma mark *** Private Methods ***
- (BOOL)_getRect:(CGRect *)outRect sourceRect:(CGRect)sourceRect allowedArrowDirections:(KSOTooltipArrowDirection)allowedArrowDirections; {
    BOOL retval = YES;
    CGSize size = CGSizeZero;
    
    if (allowedArrowDirections & KSOTooltipArrowDirectionUp) {
        [self.tooltipView setArrowDirection:KSOTooltipArrowDirectionUp];
    }
    else if (allowedArrowDirections & KSOTooltipArrowDirectionDown) {
        [self.tooltipView setArrowDirection:KSOTooltipArrowDirectionDown];
    }
    else if (allowedArrowDirections & KSOTooltipArrowDirectionLeft) {
        [self.tooltipView setArrowDirection:KSOTooltipArrowDirectionLeft];
    }
    else if (allowedArrowDirections & KSOTooltipArrowDirectionRight) {
        [self.tooltipView setArrowDirection:KSOTooltipArrowDirectionRight];
    }
    
    size = [self.tooltipView sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.bounds) - self.minimumEdgeInsets.left - self.minimumEdgeInsets.right, CGRectGetHeight(self.view.bounds) - self.minimumEdgeInsets.top - self.minimumEdgeInsets.bottom)];
    
    CGRect rect = CGRectZero;
    
    switch (self.tooltipView.arrowDirection) {
        case KSOTooltipArrowDirectionUp:
            rect = KSTCGRectCenterInRectHorizontally(CGRectMake(0, CGRectGetMaxY(sourceRect), size.width, size.height), sourceRect);
            break;
        case KSOTooltipArrowDirectionDown:
            rect = KSTCGRectCenterInRectHorizontally(CGRectMake(0, CGRectGetMinY(sourceRect) - size.height, size.width, size.height), sourceRect);
            break;
        case KSOTooltipArrowDirectionLeft:
            rect = KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMaxX(sourceRect), 0, size.width, size.height), sourceRect);
            break;
        case KSOTooltipArrowDirectionRight:
            rect = KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(sourceRect) - size.width, 0, size.width, size.height), sourceRect);
            break;
        default:
            break;
    }
    
    // check left edge
    if (CGRectGetMinX(rect) < self.minimumEdgeInsets.left) {
        rect.origin.x = self.minimumEdgeInsets.left;
    }
    // check right edge
    else if (CGRectGetMaxX(rect) > CGRectGetWidth(self.view.bounds) - self.minimumEdgeInsets.right) {
        rect.origin.x = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(rect) - self.minimumEdgeInsets.right;
    }
    
    // check top edge
    if (CGRectGetMinY(rect) < self.topLayoutGuide.length + self.minimumEdgeInsets.top) {
        rect.origin.y = self.topLayoutGuide.length + self.minimumEdgeInsets.top;
    }
    // check bottom edge
    else if (CGRectGetMaxY(rect) > CGRectGetHeight(self.view.bounds) - self.minimumEdgeInsets.bottom) {
        rect.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(rect) - self.minimumEdgeInsets.bottom;
    }
    
    if (CGRectIntersectsRect(rect, sourceRect)) {
        retval = NO;
    }
    
    *outRect = rect;
    
    return retval;
}
#pragma mark Actions
- (IBAction)_dismissButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tooltipViewControllerShouldDismiss:)] &&
        ![self.delegate tooltipViewControllerShouldDismiss:self]) {
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tooltipViewControllerWillDismiss:)]) {
        [self.delegate tooltipViewControllerWillDismiss:self];
    }
    
    kstWeakify(self);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        kstStrongify(self);
        if ([self.delegate respondsToSelector:@selector(tooltipViewControllerDidDismiss:)]) {
            [self.delegate tooltipViewControllerDidDismiss:self];
        }
    }];
}

@end
