//
//  KSOTooltipContentView.m
//  KSOTooltip-iOS
//
//  Created by William Towe on 10/11/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
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

#import "KSOTooltipContentView.h"
#import "KSOTooltipTheme.h"
#import "NSBundle+KSOTooltipPrivateExtensions.h"

#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>

@interface KSOTooltipContentView () <UIGestureRecognizerDelegate, UITextViewDelegate>
@property (strong,nonatomic) UIStackView *stackView;
@property (readwrite,strong,nonatomic) UITextView *label;
@property (readonly,nonatomic) UIColor *fillColor;

@property (strong,nonatomic) UITapGestureRecognizer *dismissGestureRecognizer;

- (CGRect)_backgroundRectForBounds:(CGRect)bounds;
- (CGRect)_arrowRectForBounds:(CGRect)bounds;
@end

@implementation KSOTooltipContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    kstWeakify(self);
    
    self.contentMode = UIViewContentModeRedraw;
    
    _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing = 8.0;
    [self addSubview:_stackView];
    
    _label = [[UITextView alloc] initWithFrame:CGRectZero];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [_label setBackgroundColor:UIColor.clearColor];
    [_label setScrollEnabled:NO];
    [_label setEditable:NO];
    [_label setContentInset:UIEdgeInsetsZero];
    [_label setTextContainerInset:UIEdgeInsetsZero];
    [_label.textContainer setLineFragmentPadding:0.0];
    [_label setDataDetectorTypes:UIDataDetectorTypeLink];
    [_label setLinkTextAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}];
    _label.delegate = self;
    [_label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    _label.hidden = YES;
    [_stackView addArrangedSubview:_label];
    
    _dismissGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    _dismissGestureRecognizer.delegate = self;
    [_dismissGestureRecognizer KDI_addBlock:^(__kindof UIGestureRecognizer * _Nonnull gestureRecognizer) {
        kstStrongify(self);
        [self.delegate tooltipContentViewDidTapToDismiss:self];
    }];
    [_label addGestureRecognizer:_dismissGestureRecognizer];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,dismissOptions)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if ([keyPath isEqualToString:@kstKeypath(self,dismissOptions)]) {
            self.dismissGestureRecognizer.enabled = (self.dismissOptions & KSOTooltipDismissOptionsTapOnForeground) != 0;
        }
    }];
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSMutableDictionary *metrics = [@{@"left": @(self.theme.textEdgeInsets.left),
                                      @"right": @(self.theme.textEdgeInsets.right),
                                      @"top": @(self.theme.textEdgeInsets.top),
                                      @"bottom": @(self.theme.textEdgeInsets.bottom)
                                      } mutableCopy];
    
    switch (self.theme.arrowStyle) {
        case KSOTooltipArrowStyleDefault: {
            switch (self.arrowDirection) {
                case KSOTooltipArrowDirectionRight:
                    metrics[@"right"] = @(self.theme.textEdgeInsets.right + self.theme.arrowWidth);
                    break;
                case KSOTooltipArrowDirectionLeft:
                    metrics[@"left"] = @(self.theme.textEdgeInsets.left + self.theme.arrowWidth);
                    break;
                case KSOTooltipArrowDirectionDown:
                    metrics[@"bottom"] = @(self.theme.textEdgeInsets.bottom + self.theme.arrowHeight);
                    break;
                case KSOTooltipArrowDirectionUp:
                    metrics[@"top"] = @(self.theme.textEdgeInsets.top + self.theme.arrowHeight);
                    break;
                default:
                    break;
            }
        }
            break;
        case KSOTooltipArrowStyleNone:
            break;
    }
    
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]-right-|" options:0 metrics:metrics views:@{@"view": self.stackView}]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:metrics views:@{@"view": self.stackView}]];
    
    self.KDI_customConstraints = temp;
    
    [super updateConstraints];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    if (self.theme.textColor == nil) {
        [self.label setTextColor:[self.fillColor KDI_contrastingColor]];
    }
}

- (BOOL)isOpaque {
    return NO;
}
- (void)drawRect:(CGRect)rect {
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    CGRect backgroundRect = [self _backgroundRectForBounds:self.bounds];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:backgroundRect cornerRadius:self.theme.cornerRadius];
    
    [self.theme.fillColor ?: self.tintColor setFill];
    
    [path fill];
    
    if (self.theme.arrowStyle == KSOTooltipArrowStyleDefault) {
        CGRect arrowRect = [self _arrowRectForBounds:self.bounds];
        
        path = [UIBezierPath bezierPath];
        
        switch (self.arrowDirection) {
            case KSOTooltipArrowDirectionUp:
                [path moveToPoint:CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMinY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMaxY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMaxY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMinY(arrowRect))];
                break;
            case KSOTooltipArrowDirectionLeft:
                [path moveToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMidY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMaxY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMinY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMidY(arrowRect))];
                break;
            case KSOTooltipArrowDirectionDown:
                [path moveToPoint:CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMaxY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMinY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMinY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMaxY(arrowRect))];
                break;
            case KSOTooltipArrowDirectionRight:
                [path moveToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMidY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMaxY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMinY(arrowRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMidY(arrowRect))];
                break;
            default:
                break;
        }
        
        [self.theme.fillColor ?: self.tintColor setFill];
        
        [path fill];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [otherGestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    return interaction != UITextItemInteractionPresentActions;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    return interaction != UITextItemInteractionPresentActions;
}

- (void)setTheme:(KSOTooltipTheme *)theme {
    _theme = theme;
    
    [self.label setFont:self.theme.font];
    [self.label setTextColor:self.theme.textColor == nil ? [self.fillColor KDI_contrastingColor] : self.theme.textColor];
    
    if (self.theme.textStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.label];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.label forTextStyle:self.theme.textStyle];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)setArrowDirection:(KSOTooltipArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
    
    [self setNeedsUpdateConstraints];
}

- (void)setAccessoryView:(__kindof UIView<KSOTooltipViewAccessory> *)accessoryView {
    if (_accessoryView == accessoryView) {
        return;
    }
    
    [_accessoryView removeFromSuperview];
    
    _accessoryView = accessoryView;
    
    if (_accessoryView != nil) {
        _accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.stackView addArrangedSubview:_accessoryView];
    }
    
    [self setNeedsUpdateConstraints];
}

@dynamic text;
- (NSString *)text {
    return self.label.text;
}
- (void)setText:(NSString *)text {
    self.label.text = text;
    self.label.hidden = KSTIsEmptyObject(text);
}

@dynamic attributedText;
- (NSAttributedString *)attributedText {
    return self.label.attributedText;
}
- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.label.attributedText = attributedText;
    self.label.hidden = KSTIsEmptyObject(attributedText.string);
}

- (CGRect)_backgroundRectForBounds:(CGRect)bounds; {
    CGRect retval = CGRectZero;
    
    switch (self.theme.arrowStyle) {
        case KSOTooltipArrowStyleDefault:
            switch (self.arrowDirection) {
                case KSOTooltipArrowDirectionUp:
                    retval = CGRectMake(0, self.theme.arrowHeight, CGRectGetWidth(bounds), CGRectGetHeight(bounds) - self.theme.arrowHeight);
                    break;
                case KSOTooltipArrowDirectionLeft:
                    retval = CGRectMake(self.theme.arrowWidth, 0, CGRectGetWidth(bounds) - self.theme.arrowWidth, CGRectGetHeight(bounds));
                    break;
                case KSOTooltipArrowDirectionDown:
                    retval = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds) - self.theme.arrowHeight);
                    break;
                case KSOTooltipArrowDirectionRight:
                    retval = CGRectMake(0, 0, CGRectGetWidth(bounds) - self.theme.arrowWidth, CGRectGetHeight(bounds));
                    break;
                default:
                    retval = bounds;
                    break;
            }
            break;
        case KSOTooltipArrowStyleNone:
            retval = bounds;
            break;
        default:
            break;
    }
    
    return retval;
}
- (CGRect)_arrowRectForBounds:(CGRect)bounds; {
    CGRect retval = CGRectZero;
    
    if (self.theme.arrowStyle == KSOTooltipArrowStyleDefault) {
        CGRect sourceRect = self.sourceView.bounds;
        
        CGPoint arrowPoint = [self convertPoint:[self.window convertPoint:[self.sourceView convertPoint:CGPointMake(CGRectGetMidX(sourceRect), CGRectGetMidY(sourceRect)) toView:nil] fromWindow:self.sourceView.window] fromView:nil];
        CGFloat arrowHalfWidth = floor(self.theme.arrowWidth * 0.5);
        
        switch (self.arrowDirection) {
            case KSOTooltipArrowDirectionUp:
                retval = CGRectMake(arrowPoint.x - arrowHalfWidth, 0, self.theme.arrowWidth, self.theme.arrowHeight);
                break;
            case KSOTooltipArrowDirectionLeft:
                retval = CGRectMake(0, arrowPoint.y - arrowHalfWidth, self.theme.arrowWidth, self.theme.arrowHeight);
                break;
            case KSOTooltipArrowDirectionDown:
                retval = CGRectMake(arrowPoint.x - arrowHalfWidth, CGRectGetHeight(bounds) - self.theme.arrowHeight, self.theme.arrowWidth, self.theme.arrowHeight);
                break;
            case KSOTooltipArrowDirectionRight:
                retval = CGRectMake(CGRectGetWidth(bounds) - self.theme.arrowWidth, arrowPoint.y - arrowHalfWidth, self.theme.arrowWidth, self.theme.arrowHeight);
                break;
            default:
                break;
        }
    }
    
    return retval;
}

- (UIColor *)fillColor {
    return self.theme.fillColor ?: self.tintColor;
}

@end
