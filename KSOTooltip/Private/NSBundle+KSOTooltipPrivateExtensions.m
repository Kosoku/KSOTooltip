//
//  NSBundle+KSOTooltipPrivateExtensions.m
//  KSOTooltip
//
//  Created by William Towe on 9/17/17.
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

#import "NSBundle+KSOTooltipPrivateExtensions.h"

@implementation NSBundle (KSOTooltipPrivateExtensions)

+ (NSBundle *)KSO_tooltipFrameworkBundle; {
    return [NSBundle bundleWithIdentifier:@"com.kosoku.ksotooltip"] ?: [self bundleWithURL:[[[NSBundle mainBundle].privateFrameworksURL URLByAppendingPathComponent:@"KSOTooltip.framework" isDirectory:YES] URLByAppendingPathComponent:@"KSOTooltip.bundle" isDirectory:YES]] ?: [self bundleWithURL:[[NSBundle mainBundle] URLForResource:@"KSOTooltip" withExtension:@"bundle"]];
}

@end
