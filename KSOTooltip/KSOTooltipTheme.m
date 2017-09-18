//
//  KSOTooltipTheme.m
//  KSOTooltip
//
//  Created by William Towe on 9/18/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOTooltipTheme.h"

#import <Stanley/Stanley.h>

@interface KSOTooltipTheme ()
@property (readwrite,copy,nonatomic) NSString *identifier;

+ (UIFont *)_defaultFont;
@end

@implementation KSOTooltipTheme

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> %@: %@ %@: %@ %@: %@ %@: %@ %@: %@ %@: %@ %@: %@ %@: %@ %@: %@ %@: %@ %@: %@ %@: %@",NSStringFromClass(self.class),self,@kstKeypath(self,identifier),self.identifier,@kstKeypath(self,backgroundColor),self.backgroundColor,@kstKeypath(self,fillColor),self.fillColor,@kstKeypath(self,textColor),self.textColor,@kstKeypath(self,font),self.font,@kstKeypath(self,textStyle),self.textStyle,@kstKeypath(self,minimumEdgeInsets),NSStringFromUIEdgeInsets(self.minimumEdgeInsets),@kstKeypath(self,textEdgeInsets),NSStringFromUIEdgeInsets(self.textEdgeInsets),@kstKeypath(self,cornerRadius),@(self.cornerRadius),@kstKeypath(self,arrowStyle),@(self.arrowStyle),@kstKeypath(self,arrowWidth),@(self.arrowWidth),@kstKeypath(self,arrowHeight),@(self.arrowHeight)];
}

- (id)copyWithZone:(NSZone *)zone {
    KSOTooltipTheme *retval = [[[self class] alloc] initWithIdentifier:[NSString stringWithFormat:@"%@.copy",self.identifier]];
    
    retval->_backgroundColor = _backgroundColor;
    retval->_fillColor = _fillColor;
    retval->_textColor = _textColor;
    
    retval->_font = _font;
    retval->_textStyle = _textStyle;
    
    retval->_minimumEdgeInsets = _minimumEdgeInsets;
    retval->_textEdgeInsets = _textEdgeInsets;
    
    retval->_cornerRadius = _cornerRadius;
    
    retval->_arrowStyle = _arrowStyle;
    retval->_arrowWidth = _arrowWidth;
    retval->_arrowHeight = _arrowHeight;
    
    return retval;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (!(self = [super init]))
        return nil;
    
    _identifier = [identifier copy];
    _font = [self.class _defaultFont];
    _minimumEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    _textEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    _cornerRadius = 5.0;
    _arrowWidth = 8.0;
    _arrowHeight = 8.0;
    
    return self;
}

+ (KSOTooltipTheme *)defaultTheme {
    return [[KSOTooltipTheme alloc] initWithIdentifier:@"com.kosoku.ksotooltip.theme.default"];
}

- (void)setFont:(UIFont *)font {
    _font = font ?: [self.class _defaultFont];
}

+ (UIFont *)_defaultFont {
    return [UIFont systemFontOfSize:12.0];
}

@end
