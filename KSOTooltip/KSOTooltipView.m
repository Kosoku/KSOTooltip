//
//  KSOTooltipView.m
//  KSOTooltip
//
//  Created by William Towe on 9/16/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
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

#import "KSOTooltipView.h"
#import "KSOTooltipTheme.h"
#import "KSOTooltipContentView.h"
#import "NSBundle+KSOTooltipPrivateExtensions.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOTooltipView () <KSOTooltipContentViewDelegate>
@property (strong,nonatomic) UIButton *dismissButton;
@property (strong,nonatomic) KSOTooltipContentView *contentView;

@property (strong,nonatomic) KSTTimer *dismissTimer;

- (void)_dismissIfPossible;
@end

@implementation KSOTooltipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    kstWeakify(self);
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _theme = KSOTooltipTheme.defaultTheme;
    _allowedArrowDirections = KSOTooltipArrowDirectionAll;
    _dismissOptions = KSOTooltipDismissOptionsDefault;
    _dismissDelay = 2.5;
    
    _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dismissButton.backgroundColor = _theme.backgroundColor;
    _dismissButton.accessibilityLabel = KSOTooltipLocalizedStringAccessibilityLabelDismiss();
    _dismissButton.accessibilityHint = KSOTooltipLocalizedStringAccessibilityHintDismiss();
    [_dismissButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self _dismissIfPossible];
    } forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dismissButton];
    
    _contentView = [[KSOTooltipContentView alloc] initWithFrame:CGRectZero];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = UIColor.clearColor;
    _contentView.theme = _theme;
    _contentView.delegate = self;
    [self addSubview:_contentView];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,dismissOptions)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if ([keyPath isEqualToString:@kstKeypath(self,dismissOptions)]) {
            self.contentView.dismissOptions = self.dismissOptions;
            
            BOOL canDismissOnBackgroundTap = (self.dismissOptions & KSOTooltipDismissOptionsTapOnBackground) != 0;
            
            self.dismissButton.enabled = canDismissOnBackgroundTap;
            
            if ((self.dismissOptions & KSOTooltipDismissOptionsAutomaticallyAfterDelay) == 0) {
                self.dismissTimer = nil;
            }
        }
    }];
    
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
        
        UIView *superview = self.sourceView.superview;
        UIScrollView *scrollView = nil;
        
        while (superview != nil) {
            if ([superview isKindOfClass:UIScrollView.class]) {
                scrollView = (UIScrollView *)superview;
                break;
            }
            superview = superview.superview;
        }
        
        switch (self.contentView.arrowDirection) {
            case KSOTooltipArrowDirectionRight:
                [temp addObject:[self.contentView.rightAnchor constraintEqualToAnchor:self.sourceView.leftAnchor constant:0.0]];
                
                temp.lastObject.priority = UILayoutPriorityDefaultLow;
                break;
            case KSOTooltipArrowDirectionUp:
                [temp addObject:[self.contentView.topAnchor constraintEqualToAnchor:self.sourceView.bottomAnchor constant:0.0]];
                
                temp.lastObject.priority = UILayoutPriorityDefaultLow;
                break;
            case KSOTooltipArrowDirectionDown:
                [temp addObject:[self.contentView.bottomAnchor constraintEqualToAnchor:self.sourceView.topAnchor constant:0.0]];
                
                temp.lastObject.priority = UILayoutPriorityDefaultLow;
                break;
            case KSOTooltipArrowDirectionLeft:
                [temp addObject:[self.contentView.leftAnchor constraintEqualToAnchor:self.sourceView.rightAnchor constant:0.0]];
                
                temp.lastObject.priority = UILayoutPriorityDefaultLow;
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
    
    if (self.sourceView == nil) {
        [self dismissAnimated:NO completion:nil];
        return;
    }
    
    CGRect sourceRect = [self convertRect:[self.window convertRect:[self.sourceView convertRect:self.sourceView.bounds toView:nil] fromWindow:nil] fromView:nil];
    
    if (self.contentView.arrowDirection != KSOTooltipArrowDirectionUnknown) {
        CGRect frame = self.contentView.frame;
        
        switch (self.contentView.arrowDirection) {
            case KSOTooltipArrowDirectionRight:
                frame.origin.x = CGRectGetMinX(sourceRect) - CGRectGetWidth(frame);
                break;
            case KSOTooltipArrowDirectionLeft:
                frame.origin.x = CGRectGetMaxX(sourceRect);
                break;
            case KSOTooltipArrowDirectionDown:
                frame.origin.y = CGRectGetMinY(sourceRect) - CGRectGetHeight(frame);
                break;
            case KSOTooltipArrowDirectionUp:
                frame.origin.y = CGRectGetMaxY(sourceRect);
                break;
            default:
                break;
        }
        
        self.contentView.frame = frame;
        
        return;
    }
    
    CGPoint center = CGPointMake(CGRectGetMidX(sourceRect), CGRectGetMidY(sourceRect));
    CGRect bounds = self.bounds;
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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL retval = [super pointInside:point withEvent:event];
    
    if (retval &&
        (self.dismissOptions & KSOTooltipDismissOptionsTapOnBackground) == 0) {
        
        if (![self.contentView pointInside:[self.contentView convertPoint:point fromView:self] withEvent:event]) {
            retval = NO;
        }
    }
    
    return retval;
}

- (void)tooltipContentViewDidTapToDismiss:(KSOTooltipContentView *)view {
    [self _dismissIfPossible];
}

+ (instancetype)tooltipViewWithText:(NSString *)text sourceBarButtonItem:(UIBarButtonItem *)sourceBarButtonItem sourceView:(UIView *)sourceView {
    KSOTooltipView *retval = [[self alloc] initWithFrame:CGRectZero];
    
    retval.text = text;
    retval.sourceView = sourceView;
    retval.sourceBarButtonItem = sourceBarButtonItem;
    
    return retval;
}
+ (instancetype)tooltipViewWithAttributedText:(NSAttributedString *)attributedText sourceBarButtonItem:(UIBarButtonItem *)sourceBarButtonItem sourceView:(UIView *)sourceView {
    KSOTooltipView *retval = [[self alloc] initWithFrame:CGRectZero];
    
    retval.attributedText = attributedText;
    retval.sourceView = sourceView;
    retval.sourceBarButtonItem = sourceBarButtonItem;
    
    return retval;
}

- (void)presentAnimated:(BOOL)animated completion:(KSTVoidBlock)completion; {
    NSAssert(self.sourceView != nil, @"attempting to present %@ with nil sourceView!", self);
    NSAssert(!KSTIsEmptyObject(self.text) || !KSTIsEmptyObject(self.attributedText), @"attempting to present %@ without text or attributedText set!", self);
    
    kstWeakify(self);
    
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
            kstStrongify(self);
            if (finished) {
                if ((self.dismissOptions & KSOTooltipDismissOptionsAutomaticallyAfterDelay) != 0 &&
                    self.dismissDelay > 0.0) {
                    
                    self.dismissTimer = [KSTTimer scheduledTimerWithTimeInterval:self.dismissDelay block:^(KSTTimer * _Nonnull timer) {
                        kstStrongify(self);
                        [self dismissAnimated:YES completion:nil];
                    } userInfo:nil repeats:NO queue:nil];
                }
                
                if (completion != nil) {
                    completion();
                }
            }
        }];
    }
}
- (void)dismissAnimated:(BOOL)animated completion:(KSTVoidBlock)completion; {
    void(^block)(void) = ^{
        if ([self.delegate respondsToSelector:@selector(tooltipViewDidDismiss:)]) {
            [self.delegate tooltipViewDidDismiss:self];
        }
        
        [self removeFromSuperview];
    };
    
    if ([self.delegate respondsToSelector:@selector(tooltipViewWillDismiss:)]) {
        [self.delegate tooltipViewWillDismiss:self];
    }
    
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
- (void)setSourceView:(UIView *)sourceView {
    _sourceView = sourceView;
    
    self.contentView.sourceView = _sourceView;
}

@dynamic accessoryView;
- (UIView *)accessoryView {
    return self.contentView.accessoryView;
}
- (void)setAccessoryView:(__kindof UIView<KSOTooltipViewAccessory> *)accessoryView {
    if (accessoryView != nil) {
        NSAssert([accessoryView isKindOfClass:UIView.class], @"attempting to set accessory view %@ that does not inherit from UIView!", accessoryView);
    }
    
    self.contentView.accessoryView = accessoryView;
    
    if ([accessoryView respondsToSelector:@selector(setTooltipView:)]) {
        accessoryView.tooltipView = self;
    }
}

- (void)_dismissIfPossible; {
    BOOL shouldDismiss = YES;
    
    if ([self.delegate respondsToSelector:@selector(tooltipViewShouldDismiss:)]) {
        shouldDismiss = [self.delegate tooltipViewShouldDismiss:self];
    }
    
    if (shouldDismiss) {
        [self dismissAnimated:YES completion:nil];
    }
}

- (void)setDismissTimer:(KSTTimer *)dismissTimer {
    [_dismissTimer invalidate];
    
    _dismissTimer = dismissTimer;
}

@end
