//
//  KSOTooltipTheme.m
//  KSOTooltip
//
//  Created by William Towe on 9/18/17.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
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

#import "KSOTooltipTheme.h"

#import <Stanley/Stanley.h>

#import <objc/runtime.h>

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
    
    retval->_animationDuration = _animationDuration;
    retval->_animationSpringDamping = _animationSpringDamping;
    retval->_animationInitialSpringVelocity = _animationInitialSpringVelocity;
    
    return retval;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (!(self = [super init]))
        return nil;
    
    _identifier = [identifier copy];
    _font = [self.class _defaultFont];
    _textStyle = UIFontTextStyleFootnote;
    _minimumEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    _textEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    _cornerRadius = 5.0;
    _arrowWidth = 8.0;
    _arrowHeight = 8.0;
    _animationDuration = 0.33;
    _animationSpringDamping = 0.5;
    
    return self;
}

static void const *kDefaultThemeKey = &kDefaultThemeKey;
+ (KSOTooltipTheme *)defaultTheme {
    return objc_getAssociatedObject(self, kDefaultThemeKey) ?: [[KSOTooltipTheme alloc] initWithIdentifier:@"com.kosoku.ksotooltip.theme.default"];
}
+ (void)setDefaultTheme:(KSOTooltipTheme *)defaultTheme {
    objc_setAssociatedObject(self, kDefaultThemeKey, defaultTheme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFont:(UIFont *)font {
    _font = font ?: [self.class _defaultFont];
}

+ (UIFont *)_defaultFont {
    return [UIFont systemFontOfSize:12.0];
}

@end
