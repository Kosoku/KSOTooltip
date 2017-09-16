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

@interface KSOTooltipView ()
@property (strong,nonatomic) UILabel *label;
@end

@implementation KSOTooltipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:UIColor.blueColor];
    
    _edgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_label setNumberOfLines:0];
    [_label setTextColor:UIColor.whiteColor];
    [_label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_label setAdjustsFontForContentSizeCategory:YES];
    [self addSubview:_label];
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retval = CGSizeZero;
    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(size.width - self.edgeInsets.left - self.edgeInsets.right, size.height)];
    
    retval.width += self.edgeInsets.left;
    retval.width += labelSize.width;
    retval.width += self.edgeInsets.right;
    
    retval.height += self.edgeInsets.top;
    retval.height += labelSize.height;
    retval.height += self.edgeInsets.bottom;
    
    return retval;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets)];
}

@dynamic text;
- (NSString *)text {
    return self.label.text;
}
- (void)setText:(NSString *)text {
    [self.label setText:text];
}

@end
