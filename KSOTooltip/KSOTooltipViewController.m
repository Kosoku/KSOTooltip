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
#import "KSOTooltipTheme.h"

#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>

@interface KSOTooltipViewController () <UIViewControllerTransitioningDelegate>
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
    
    kstWeakify(self);
    
    [self setTransitioningDelegate:self];
    
    _theme = KSOTooltipTheme.defaultTheme;
    _allowedArrowDirections = KSOTooltipArrowDirectionAll;
    
    _tooltipView = [[KSOTooltipView alloc] initWithFrame:CGRectZero];
    [_tooltipView setTheme:_theme];
    
    [self KAG_addObserverForNotificationName:UIApplicationDidEnterBackgroundNotification object:nil block:^(NSNotification * _Nonnull notification) {
        kstStrongify(self);
        if ([self.delegate respondsToSelector:@selector(tooltipViewControllerWillDismiss:)]) {
            [self.delegate tooltipViewControllerWillDismiss:self];
        }
        
        [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
            kstStrongify(self);
            if ([self.delegate respondsToSelector:@selector(tooltipViewControllerDidDismiss:)]) {
                [self.delegate tooltipViewControllerDidDismiss:self];
            }
        }];
    }];
    
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
    
    [retval setBackgroundColor:self.theme.backgroundColor];
    
    return retval;
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setTheme:(KSOTooltipTheme *)theme {
    _theme = theme ?: KSOTooltipTheme.defaultTheme;
    
    [self.tooltipView setTheme:_theme];
}
@dynamic text;
- (NSString *)text {
    return self.tooltipView.text;
}
- (void)setText:(NSString *)text {
    [self.tooltipView setText:text];
}
@dynamic attributedText;
- (NSAttributedString *)attributedText {
    return self.tooltipView.attributedText;
}
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self.tooltipView setAttributedText:attributedText];
}
- (KSOTooltipArrowDirection)arrowDirection {
    return self.tooltipView.arrowDirection;
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
    
    size = [self.tooltipView sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.bounds) - self.theme.minimumEdgeInsets.left - self.theme.minimumEdgeInsets.right, CGRectGetHeight(self.view.bounds) - self.theme.minimumEdgeInsets.top - self.theme.minimumEdgeInsets.bottom)];
    
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
    if (CGRectGetMinX(rect) < self.theme.minimumEdgeInsets.left) {
        rect.origin.x = self.theme.minimumEdgeInsets.left;
    }
    // check right edge
    else if (CGRectGetMaxX(rect) > CGRectGetWidth(self.view.bounds) - self.theme.minimumEdgeInsets.right) {
        rect.origin.x = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(rect) - self.theme.minimumEdgeInsets.right;
    }
    
    // check top edge
    if (CGRectGetMinY(rect) < self.topLayoutGuide.length + self.theme.minimumEdgeInsets.top) {
        rect.origin.y = self.topLayoutGuide.length + self.theme.minimumEdgeInsets.top;
    }
    // check bottom edge
    else if (CGRectGetMaxY(rect) > CGRectGetHeight(self.view.bounds) - self.theme.minimumEdgeInsets.bottom) {
        rect.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(rect) - self.theme.minimumEdgeInsets.bottom;
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
    
    BOOL animate = ([self.delegate respondsToSelector:@selector(tooltipViewControllerDismissalShouldAnimate:)] && [self.delegate tooltipViewControllerDismissalShouldAnimate:self]) || ![self.delegate respondsToSelector:@selector(tooltipViewControllerDismissalShouldAnimate:)];
    
    kstWeakify(self);
    [self.presentingViewController dismissViewControllerAnimated:animate completion:^{
        kstStrongify(self);
        if ([self.delegate respondsToSelector:@selector(tooltipViewControllerDidDismiss:)]) {
            [self.delegate tooltipViewControllerDidDismiss:self];
        }
    }];
}

@end
