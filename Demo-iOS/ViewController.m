//
//  ViewController.m
//  Demo-iOS
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

#import "ViewController.h"

#import <KSOTooltip/KSOTooltip.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface AccessoryView : UIView
@property (strong,nonatomic) KDIBadgeButton *badgeButton;
@property (weak,nonatomic) KSOTooltipViewController *viewController;

- (instancetype)initWithFrame:(CGRect)frame viewController:(KSOTooltipViewController *)viewController;
@end

@implementation AccessoryView

- (instancetype)initWithFrame:(CGRect)frame viewController:(KSOTooltipViewController *)viewController {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _viewController = viewController;
    
    _badgeButton = [[KDIBadgeButton alloc] initWithFrame:CGRectZero];
    [_badgeButton setBadgePosition:KDIBadgeButtonBadgePositionRelativeToImage];
    [_badgeButton.button setContentEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_badgeButton.button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
    [_badgeButton.button setImageContentVerticalAlignment:KDIButtonContentVerticalAlignmentTop];
    [_badgeButton.button setImageContentHorizontalAlignment:KDIButtonContentHorizontalAlignmentCenter];
    [_badgeButton.button setTitleContentVerticalAlignment:KDIButtonContentVerticalAlignmentBottom];
    [_badgeButton.button setTitleContentHorizontalAlignment:KDIButtonContentHorizontalAlignmentCenter];
    [_badgeButton.button setImage:[UIImage imageNamed:@"ghost"] forState:UIControlStateNormal];
    [_badgeButton.button setTitle:@"Badge Button" forState:UIControlStateNormal];
    [_badgeButton.badgeView setBadge:@"123"];
    [self addSubview:_badgeButton];
    
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window != nil) {
        UIColor *color = [self.viewController.fillColor ?: self.tintColor KDI_contrastingColor];
        
        [self.badgeButton.button setTintColor:color];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.badgeButton sizeThatFits:self.bounds.size];
    
    [self.badgeButton setFrame:KSTCGRectCenterInRect(CGRectMake(0, 0, size.width, size.height), self.bounds)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.badgeButton sizeThatFits:size];
}

@end

@interface AccessoryViewWithAutoLayout : UIView
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (weak,nonatomic) KSOTooltipViewController *viewController;

- (instancetype)initWithFrame:(CGRect)frame viewController:(KSOTooltipViewController *)viewController;
@end

@implementation AccessoryViewWithAutoLayout

- (instancetype)initWithFrame:(CGRect)frame viewController:(KSOTooltipViewController *)viewController {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _viewController = viewController;
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_label setText:@"Accessory"];
    [_label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self addSubview:_label];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"One",@"Two",@"Three"]];
    [_segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_segmentedControl];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": _label}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": _label}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-|" options:0 metrics:nil views:@{@"view": _segmentedControl, @"subview": _label}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": _segmentedControl}]];
    
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window != nil) {
        UIColor *color = [self.viewController.fillColor ?: self.tintColor KDI_contrastingColor];
        
        [self.label setTextColor:color];
        [self.segmentedControl setTintColor:color];
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end

@interface ViewController ()
@property (strong,nonatomic) UIBarButtonItem *customBarButtonItem;
@end

@implementation ViewController

- (NSString *)title {
    return @"Demo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Show",@"Tooltip"]];
    
    [segmentedControl setMomentary:YES];
    [segmentedControl setApportionsSegmentWidthsByContent:YES];
    [segmentedControl addTarget:self action:@selector(_showTooltipAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl sizeToFit];
    
    [self setCustomBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:segmentedControl]];
    
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_showTooltipAction:)],self.customBarButtonItem]];
    
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithTitle:@"Show Tooltip" style:UIBarButtonItemStylePlain target:self action:@selector(_showTooltipAction:)]]];
}

- (IBAction)_showTooltipAction:(id)sender {
    KSOTooltipViewController *viewController = [[KSOTooltipViewController alloc] init];
    KSOTooltipArrowDirection directions = arc4random_uniform((uint32_t)KSOTooltipArrowDirectionAll) + KSOTooltipArrowDirectionUp;
    
    KSTLog(@"allowed directions: %@",@(directions));
    
    [viewController setAllowedArrowDirections:directions];
    
    if (arc4random_uniform(2) % 2 == 0) {
        if (arc4random_uniform(2) % 2 == 0) {
            [viewController setAccessoryView:[[AccessoryViewWithAutoLayout alloc] initWithFrame:CGRectZero viewController:viewController]];
        }
        else {
            [viewController setAccessoryView:[[AccessoryView alloc] initWithFrame:CGRectZero viewController:viewController]];
        }
    }
    
    if ([sender isKindOfClass:UISegmentedControl.class]) {
        [viewController setBackgroundColor:KDIColorWA(0, 0.5)];
        [viewController setText:@"This tooltip is being presented from a bar button item with a custom view"];
        [viewController setBarButtonItem:self.customBarButtonItem];
    }
    else if ([sender isKindOfClass:UIView.class]) {
        [viewController setFillColor:KDIColorRandomRGB()];
        [viewController setTextColor:[viewController.fillColor KDI_contrastingColor]];
        [viewController setText:@"The tooltip is being presented from a button"];
        [viewController setSourceView:sender];
    }
    else {
        [viewController setBackgroundColor:KDIColorWA(0, 0.5)];
        [viewController setText:@"This tooltip is being presented from a bar button item"];
        [viewController setBarButtonItem:sender];
    }
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
