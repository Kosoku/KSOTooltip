//
//  KSOTooltipDefines.h
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

#ifndef __KSO_TOOLTIP_DEFINES__
#define __KSO_TOOLTIP_DEFINES__

#import <Foundation/Foundation.h>

/**
 Enum for possible arrow styles.
 */
typedef NS_ENUM(NSInteger, KSOTooltipArrowStyle) {
    /**
     The default arrow style.
     */
    KSOTooltipArrowStyleDefault,
    /**
     The arrow is not drawn.
     */
    KSOTooltipArrowStyleNone
};

/**
 Options mask for dismiss options.
 */
typedef NS_OPTIONS(NSUInteger, KSOTooltipDismissOptions) {
    /**
     No dismiss options. The client must dismiss the tooltip programatically.
     */
    KSOTooltipDismissOptionsNone = 0,
    /**
     A tap outside of the tooltip content view (the text and possible accessory view) will dismiss the tooltip.
     */
    KSOTooltipDismissOptionsTapOnBackground = 1 << 0,
    /**
     A tap inside the tooltip content view will dismiss the tooltip.
     */
    KSOTooltipDismissOptionsTapOnForeground = 1 << 1,
    /**
     The tooltip will dismiss itself after a delay. See dismissDelay on KSOTooltipView.
     */
    KSOTooltipDismissOptionsAutomaticallyAfterDelay = 1 << 2,
    /**
     The default options. Tap on background or foreground will dismiss the tooltip.
     */
    KSOTooltipDismissOptionsDefault = KSOTooltipDismissOptionsTapOnBackground|KSOTooltipDismissOptionsTapOnForeground,
    /**
     Convenience to specify all options.
     */
    KSOTooltipDismissOptionsAll = KSOTooltipDismissOptionsTapOnBackground|KSOTooltipDismissOptionsTapOnForeground|KSOTooltipDismissOptionsAutomaticallyAfterDelay
};

/**
 Options mask for possible arrow directions.
 */
typedef NS_OPTIONS(NSUInteger, KSOTooltipArrowDirection) {
    /**
     The arrow direction is unknown.
     */
    KSOTooltipArrowDirectionUnknown = 0,
    /**
     The arrow is pointing up.
     */
    KSOTooltipArrowDirectionUp = 1 << 0,
    /**
     The arrow is pointing left.
     */
    KSOTooltipArrowDirectionLeft = 1 << 1,
    /**
     The arrow is pointing down.
     */
    KSOTooltipArrowDirectionDown = 1 << 2,
    /**
     The arrow is pointing right.
     */
    KSOTooltipArrowDirectionRight = 1 << 3,
    /**
     All valid arrow directions (top, left, down, right).
     */
    KSOTooltipArrowDirectionAll = KSOTooltipArrowDirectionUp|KSOTooltipArrowDirectionLeft|KSOTooltipArrowDirectionDown|KSOTooltipArrowDirectionRight
};

#endif
