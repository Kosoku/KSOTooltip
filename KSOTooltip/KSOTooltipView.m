//
//  KSOTooltipView.m
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

#import "KSOTooltipView.h"
#import "KSOTooltipTheme.h"
#import "KSOTooltipContentView.h"
#import "NSBundle+KSOTooltipPrivateExtensions.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOTooltipView ()
@property (strong,nonatomic) UIButton *dismissButton;
@property (strong,nonatomic) KSOTooltipContentView *contentView;

@end

@implementation KSOTooltipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    kstWeakify(self);
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _theme = KSOTooltipTheme.defaultTheme;
    _allowedArrowDirections = KSOTooltipArrowDirectionAll;
    
    _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dismissButton.backgroundColor = _theme.backgroundColor;
    _dismissButton.accessibilityLabel = NSLocalizedStringWithDefaultValue(@"button.close.accessibility-label", nil, NSBundle.KSO_tooltipFrameworkBundle, @"Close", @"button close accessibility label");
    _dismissButton.accessibilityHint = NSLocalizedStringWithDefaultValue(@"button.close.accessibility-hint", nil, NSBundle.KSO_tooltipFrameworkBundle, @"Double tap to close the tooltip", @"button close accessibility hint");
    [_dismissButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self dismissAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dismissButton];
    
    _contentView = [[KSOTooltipContentView alloc] initWithFrame:CGRectZero];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = UIColor.clearColor;
    _contentView.theme = _theme;
    [self addSubview:_contentView];
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    NSMutableArray<NSLayoutConstraint *> *temp = [[NSMutableArray alloc] init];
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self}]];
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.dismissButton}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.dismissButton}]];
    
    if (self.sourceView != nil) {
        [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=left-[view]->=right-|" options:0 metrics:@{@"left": @(self.theme.minimumEdgeInsets.left), @"right": @(self.theme.minimumEdgeInsets.right)} views:@{@"view": self.contentView}]];
        [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": @(self.theme.minimumEdgeInsets.top + CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame)), @"bottom": @(self.theme.minimumEdgeInsets.bottom)} views:@{@"view": self.contentView}]];
        
        switch (self.contentView.arrowDirection) {
            case KSOTooltipArrowDirectionRight:
                [temp addObject:[self.contentView.rightAnchor constraintEqualToAnchor:self.sourceView.leftAnchor constant:0.0]];
                break;
            case KSOTooltipArrowDirectionUp:
                [temp addObject:[self.contentView.topAnchor constraintEqualToAnchor:self.sourceView.bottomAnchor constant:0.0]];
                break;
            case KSOTooltipArrowDirectionDown:
                [temp addObject:[self.contentView.bottomAnchor constraintEqualToAnchor:self.sourceView.topAnchor constant:0.0]];
                break;
            case KSOTooltipArrowDirectionLeft:
                [temp addObject:[self.contentView.leftAnchor constraintEqualToAnchor:self.sourceView.rightAnchor constant:0.0]];
                break;
            default:
                break;
        }
        
        if (self.contentView.arrowDirection == KSOTooltipArrowDirectionUp ||
            self.contentView.arrowDirection == KSOTooltipArrowDirectionDown) {
            
            if (self.sourceBarButtonItem == nil) {
                [temp addObject:[self.contentView.centerXAnchor constraintEqualToAnchor:self.sourceView.centerXAnchor]];

                temp.lastObject.priority = UILayoutPriorityDefaultLow;
            }
        }
        else if (self.contentView.arrowDirection == KSOTooltipArrowDirectionLeft ||
                 self.contentView.arrowDirection == KSOTooltipArrowDirectionRight) {
            
            if (self.sourceBarButtonItem == nil) {
                [temp addObject:[self.contentView.centerYAnchor constraintEqualToAnchor:self.sourceView.centerYAnchor]];
                
                temp.lastObject.priority = UILayoutPriorityDefaultLow;
            }
        }
    }
    
    self.KDI_customConstraints = temp;
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.contentView.arrowDirection != KSOTooltipArrowDirectionUnknown) {
        return;
    }
    
    CGRect sourceRect = [self.window convertRect:self.sourceView.bounds fromView:self.sourceView];
    CGPoint center = CGPointMake(CGRectGetMidX(sourceRect), CGRectGetMidY(sourceRect));
    CGRect bounds = self.window.bounds;
    CGRect topLeft = CGRectMake(0, 0, CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGRect topRight = CGRectMake(CGRectGetMidX(bounds), 0, CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGRect bottomLeft = CGRectMake(0, CGRectGetMidY(bounds), CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGRect bottomRight = CGRectMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds), CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    // always prefer up
    if (CGRectContainsPoint(topLeft, center)) {
        if (self.allowedArrowDirections & KSOTooltipArrowDirectionUp) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionUp;
        }
        else if (self.allowedArrowDirections & KSOTooltipArrowDirectionLeft) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionLeft;
        }
    }
    else if (CGRectContainsPoint(topRight, center)) {
        if (self.allowedArrowDirections & KSOTooltipArrowDirectionUp) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionUp;
        }
        else if (self.allowedArrowDirections & KSOTooltipArrowDirectionRight) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionRight;
        }
    }
    else if (CGRectContainsPoint(bottomLeft, center)) {
        if (self.allowedArrowDirections & KSOTooltipArrowDirectionDown) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionDown;
        }
        else if (self.allowedArrowDirections & KSOTooltipArrowDirectionLeft) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionLeft;
        }
    }
    else if (CGRectContainsPoint(bottomRight, center)) {
        if (self.allowedArrowDirections & KSOTooltipArrowDirectionDown) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionDown;
        }
        else if (self.allowedArrowDirections & KSOTooltipArrowDirectionRight) {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionRight;
        }
    }
    
    // default to up/down
    if (self.contentView.arrowDirection == KSOTooltipArrowDirectionUnknown) {
        if (CGRectContainsPoint(topLeft, center) ||
            CGRectContainsPoint(topRight, center)) {
            
            self.contentView.arrowDirection = KSOTooltipArrowDirectionUp;
        }
        else {
            self.contentView.arrowDirection = KSOTooltipArrowDirectionDown;
        }
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)presentAnimated:(BOOL)animated completion:(KSTVoidBlock)completion; {
    if (self.window == nil) {
        [self.sourceView.window addSubview:self];
    }
    
    if (animated) {
        self.dismissButton.backgroundColor = UIColor.clearColor;
        self.contentView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        [UIView animateKeyframesWithDuration:self.theme.animationDuration delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.66 animations:^{
                self.dismissButton.backgroundColor = self.theme.backgroundColor;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                [UIView animateWithDuration:self.theme.animationDuration delay:0 usingSpringWithDamping:self.theme.animationSpringDamping initialSpringVelocity:self.theme.animationInitialSpringVelocity options:0 animations:^{
                    self.contentView.alpha = 1.0;
                    self.contentView.transform = CGAffineTransformIdentity;
                } completion:nil];
            }];
        } completion:^(BOOL finished) {
            if (finished) {
                if (completion != nil) {
                    completion();
                }
            }
        }];
    }
}
- (void)dismissAnimated:(BOOL)animated completion:(KSTVoidBlock)completion; {
    void(^block)(void) = ^{
        [self removeFromSuperview];
    };
    
    if (animated) {
        [UIView animateWithDuration:self.theme.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.dismissButton.backgroundColor = UIColor.clearColor;
            self.contentView.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        } completion:^(BOOL finished) {
            if (finished) {
                block();
            }
        }];
    }
    else {
        block();
    }
}

- (void)setTheme:(KSOTooltipTheme *)theme {
    _theme = theme ?: KSOTooltipTheme.defaultTheme;
    
    self.dismissButton.backgroundColor = _theme.backgroundColor;
    
    self.contentView.theme = _theme;
}

- (void)setAllowedArrowDirections:(KSOTooltipArrowDirection)allowedArrowDirections {
    _allowedArrowDirections = allowedArrowDirections == KSOTooltipArrowDirectionUnknown ? KSOTooltipArrowDirectionAll : allowedArrowDirections;
}

@dynamic text;
- (NSString *)text {
    return self.attributedText.string;
}
- (void)setText:(NSString *)text {
    [self.contentView.label setText:text];
}
@dynamic attributedText;
- (NSAttributedString *)attributedText {
    return self.contentView.label.attributedText;
}
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self.contentView.label setAttributedText:attributedText];
}

- (void)setSourceView:(UIView *)sourceView {
    _sourceView = sourceView;
    
    self.contentView.sourceView = _sourceView;
}
- (void)setSourceBarButtonItem:(UIBarButtonItem *)sourceBarButtonItem {
    _sourceBarButtonItem = sourceBarButtonItem;
    
    if (_sourceBarButtonItem.customView != nil) {
        self.sourceView = _sourceBarButtonItem.customView;
    }
    else if ([_sourceBarButtonItem respondsToSelector:@selector(view)]) {
        id view = [_sourceBarButtonItem valueForKey:@"view"];
        
        if ([view isKindOfClass:UIView.class]) {
            self.sourceView = view;
        }
    }
}

@dynamic accessoryView;
- (UIView *)accessoryView {
    return self.contentView.accessoryView;
}
- (void)setAccessoryView:(__kindof UIView *)accessoryView {
    self.contentView.accessoryView = accessoryView;
}

@end
