//
//  KSOTooltipDefines.h
//  KSOTooltip
//
//  Created by William Towe on 9/16/17.
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
