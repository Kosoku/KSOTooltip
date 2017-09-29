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

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOTooltipView ()
@property (strong,nonatomic) UILabel *label;

@property (readonly,nonatomic) UIColor *fillColor;

- (CGRect)_backgroundRectForBounds:(CGRect)bounds;
- (CGRect)_arrowRectForBounds:(CGRect)bounds;
- (CGRect)_accessoryViewRectForBounds:(CGRect)bounds;
@end

@implementation KSOTooltipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_label setNumberOfLines:0];
    [self addSubview:_label];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPath:@kstKeypath(self,theme) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self.label setFont:self.theme.font];
            [self.label setTextColor:self.theme.textColor == nil ? [self.fillColor KDI_contrastingColor] : self.theme.textColor];

            if (self.theme.textStyle == nil) {
                [NSObject KDI_unregisterDynamicTypeObject:self.label];
            }
            else {
                [NSObject KDI_registerDynamicTypeObject:self.label forTextStyle:self.theme.textStyle];
            }

            [self setNeedsDisplay];
            [self setNeedsLayout];
        });
    }];
    
    return self;
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

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retval = CGSizeZero;
    CGFloat maxWidth = size.width;
    
    switch (self.theme.arrowStyle) {
        case KSOTooltipArrowStyleDefault: {
            switch (self.arrowDirection) {
                case KSOTooltipArrowDirectionUp:
                case KSOTooltipArrowDirectionDown: {
                    maxWidth -= self.theme.textEdgeInsets.left + self.theme.textEdgeInsets.right;
                    
                    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(maxWidth, size.height - self.theme.textEdgeInsets.top - self.theme.textEdgeInsets.bottom - self.theme.arrowHeight)];
                    
                    retval.width += self.theme.textEdgeInsets.left + labelSize.width + self.theme.textEdgeInsets.right;
                    retval.height += self.theme.textEdgeInsets.top + labelSize.height + self.theme.textEdgeInsets.bottom + self.theme.arrowHeight;
                }
                    break;
                case KSOTooltipArrowDirectionLeft:
                case KSOTooltipArrowDirectionRight: {
                    maxWidth -= self.theme.textEdgeInsets.left + self.theme.textEdgeInsets.right + self.theme.arrowWidth;
                    
                    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(maxWidth, size.height - self.theme.textEdgeInsets.top - self.theme.textEdgeInsets.bottom)];
                    
                    retval.width += self.theme.textEdgeInsets.left + labelSize.width + self.theme.textEdgeInsets.right + self.theme.arrowWidth;
                    retval.height += self.theme.textEdgeInsets.top + labelSize.height + self.theme.textEdgeInsets.bottom;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case KSOTooltipArrowStyleNone: {
            maxWidth -= self.theme.textEdgeInsets.left + self.theme.textEdgeInsets.right;
            
            CGSize labelSize = [self.label sizeThatFits:CGSizeMake(maxWidth, size.height - self.theme.textEdgeInsets.top - self.theme.textEdgeInsets.bottom)];
            
            retval.width += self.theme.textEdgeInsets.left + labelSize.width + self.theme.textEdgeInsets.right;
            retval.height += self.theme.textEdgeInsets.top + labelSize.height + self.theme.textEdgeInsets.bottom;
        }
            break;
    }
    
    if (self.accessoryView != nil) {
        CGSize accessorySize = CGSizeZero;
        
        if ([self.accessoryView.class requiresConstraintBasedLayout]) {
            accessorySize = [self.accessoryView systemLayoutSizeFittingSize:CGSizeMake(maxWidth, size.height)];
        }
        else {
            accessorySize = [self.accessoryView sizeThatFits:CGSizeMake(maxWidth, size.height)];
        }
        
        retval.width = KSTBoundedValue(accessorySize.width, retval.width, maxWidth);
        retval.height += accessorySize.height;
    }
    
    return retval;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.theme.arrowStyle) {
        case KSOTooltipArrowStyleDefault:
            switch (self.arrowDirection) {
                case KSOTooltipArrowDirectionUp:
                    [self.label setFrame:CGRectMake(self.theme.textEdgeInsets.left, self.theme.arrowHeight + self.theme.textEdgeInsets.top, CGRectGetWidth(self.bounds) - self.theme.textEdgeInsets.left - self.theme.textEdgeInsets.right, CGRectGetHeight(self.bounds) - self.theme.textEdgeInsets.bottom - self.theme.textEdgeInsets.top - self.theme.arrowHeight)];
                    break;
                case KSOTooltipArrowDirectionLeft:
                    [self.label setFrame:CGRectMake(self.theme.arrowWidth + self.theme.textEdgeInsets.left, self.theme.textEdgeInsets.top, CGRectGetWidth(self.bounds) - self.theme.textEdgeInsets.left - self.theme.textEdgeInsets.right - self.theme.arrowWidth, CGRectGetHeight(self.bounds) - self.theme.textEdgeInsets.top - self.theme.textEdgeInsets.bottom)];
                    break;
                case KSOTooltipArrowDirectionDown:
                    [self.label setFrame:CGRectMake(self.theme.textEdgeInsets.left, self.theme.textEdgeInsets.top, CGRectGetWidth(self.bounds) - self.theme.textEdgeInsets.left - self.theme.textEdgeInsets.right, CGRectGetHeight(self.bounds) - self.theme.textEdgeInsets.top - self.theme.textEdgeInsets.bottom - self.theme.arrowHeight)];
                    break;
                case KSOTooltipArrowDirectionRight:
                    [self.label setFrame:CGRectMake(self.theme.textEdgeInsets.left, self.theme.textEdgeInsets.top, CGRectGetWidth(self.bounds) - self.theme.textEdgeInsets.left - self.theme.textEdgeInsets.right - self.theme.arrowWidth, CGRectGetHeight(self.bounds) - self.theme.textEdgeInsets.left - self.theme.textEdgeInsets.right)];
                    break;
                default:
                    break;
            }
            break;
        case KSOTooltipArrowStyleNone:
            [self.label setFrame:CGRectMake(self.theme.textEdgeInsets.left, self.theme.textEdgeInsets.top, CGRectGetWidth(self.bounds) - self.theme.textEdgeInsets.left - self.theme.textEdgeInsets.right, CGRectGetHeight(self.bounds) - self.theme.textEdgeInsets.top - self.theme.textEdgeInsets.bottom)];
            break;
        default:
            break;
    }
    
    if (self.accessoryView != nil) {
        [self.accessoryView setFrame:[self _accessoryViewRectForBounds:self.bounds]];
        
        [self.label setFrame:CGRectMake(CGRectGetMinX(self.label.frame), CGRectGetMinY(self.label.frame), CGRectGetWidth(self.label.frame), CGRectGetHeight(self.label.frame) - CGRectGetHeight(self.accessoryView.frame))];
    }
}
@dynamic text;
- (NSString *)text {
    return self.attributedText.string;
}
- (void)setText:(NSString *)text {
    [self.label setText:text];
}
@dynamic attributedText;
- (NSAttributedString *)attributedText {
    return self.label.attributedText;
}
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self.label setAttributedText:attributedText];
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
- (void)setArrowDirection:(KSOTooltipArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
- (void)setAccessoryView:(UIView *)accessoryView {
    [_accessoryView removeFromSuperview];
    
    _accessoryView = accessoryView;
    
    if (_accessoryView != nil) {
        [self addSubview:_accessoryView];
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
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
        CGRect sourceRect = self.sourceRect;
        
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
- (CGRect)_accessoryViewRectForBounds:(CGRect)bounds {
    CGRect retval = CGRectZero;
    
    if (self.accessoryView != nil) {
        CGSize accessorySize = CGSizeZero;
        
        if ([self.accessoryView.class requiresConstraintBasedLayout]) {
            accessorySize = [self.accessoryView systemLayoutSizeFittingSize:CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds))];
        }
        else {
            accessorySize = [self.accessoryView sizeThatFits:CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds))];
        }
        
        CGRect backgroundRect = [self _backgroundRectForBounds:bounds];
        
        retval = CGRectMake(CGRectGetMinX(backgroundRect), CGRectGetMaxY(backgroundRect) - accessorySize.height, CGRectGetWidth(backgroundRect), accessorySize.height);
    }
    
    return retval;
}

- (UIColor *)fillColor {
    return self.theme.fillColor ?: self.tintColor;
}

@end
