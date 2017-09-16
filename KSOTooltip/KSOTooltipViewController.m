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

@interface KSOTooltipViewController () <UIViewControllerTransitioningDelegate>
@property (strong,nonatomic) UIButton *dismissButton;
@property (strong,nonatomic) KSOTooltipView *tooltipView;
@end

@implementation KSOTooltipViewController
#pragma mark *** Subclass Overrides ***
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    [self setTransitioningDelegate:self];
    
    _minimumEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    _tooltipView = [[KSOTooltipView alloc] initWithFrame:CGRectZero];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_contentSizeCategoryDidChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    return self;
}
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDismissButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self.dismissButton addTarget:self action:@selector(_dismissButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    [self.view addSubview:self.tooltipView];
}
- (void)viewWillLayoutSubviews {
    [self.dismissButton setFrame:self.view.bounds];
    
    CGRect sourceRect = CGRectIsEmpty(self.sourceRect) ? self.sourceView.bounds : self.sourceRect;
    
    sourceRect = [self.view convertRect:[self.view.window convertRect:[self.sourceView convertRect:sourceRect toView:nil] fromWindow:nil] fromView:nil];
    
    CGSize size = [self.tooltipView sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.bounds) - self.minimumEdgeInsets.left - self.minimumEdgeInsets.right, CGRectGetHeight(self.view.bounds) - self.minimumEdgeInsets.top - self.minimumEdgeInsets.bottom)];
    CGRect rect = CGRectMake(CGRectGetMinX(sourceRect), CGRectGetMaxY(sourceRect), size.width, size.height);
    
    // check right edge
    if (CGRectGetMaxX(rect) > CGRectGetWidth(self.view.bounds) - self.minimumEdgeInsets.right) {
        rect.origin.x = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(rect) - self.minimumEdgeInsets.right;
    }
    
    [self.tooltipView setFrame:rect];
}
#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    KSOTooltipAnimation *retval = [[KSOTooltipAnimation alloc] init];
    
    [retval setPresenting:YES];
    
    return retval;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[KSOTooltipAnimation alloc] init];
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
#pragma mark *** Private Methods ***
#pragma mark Actions
- (IBAction)_dismissButtonAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Notifications
- (void)_contentSizeCategoryDidChange:(NSNotification *)note {
    [self.view setNeedsLayout];
}

@end
