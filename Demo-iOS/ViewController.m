//
//  ViewController.m
//  Demo-iOS
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

#import "ViewController.h"

#import <KSOTooltip/KSOTooltip.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface UIFont (DynamicTypeTest)
+ (UIFont *)iOSDemo_fontForTextStyle:(UIFontTextStyle)textStyle;
@end

@implementation UIFont (DynamicTypeTest)

+ (void)load {
    [UIFont setKDI_dynamicTypeFontForTextStyleSelector:@selector(iOSDemo_fontForTextStyle:)];
}

+ (UIFont *)iOSDemo_fontForTextStyle:(UIFontTextStyle)textStyle {
    UIFontDescriptor *fontDesc = [UIFontDescriptor preferredFontDescriptorWithTextStyle:textStyle];
    
    return [UIFont boldSystemFontOfSize:fontDesc.pointSize];
}

@end

@interface CheckmarkAccessoryView : UIView
@property (strong,nonatomic) KDIButton *button;
@end

@implementation CheckmarkAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _button = [KDIButton buttonWithType:UIButtonTypeSystem];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [_button setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
    [_button setTitle:@"Tap to toggle selected" forState:UIControlStateNormal];
    [_button setContentEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [_button setKDI_cornerRadius:5.0];
    [_button setRounded:YES];
    [_button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:_button];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _button}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _button}]];
    
    return self;
}

- (IBAction)_buttonAction:(id)sender {
    [self.button setInverted:!self.button.isInverted];
}

@end

@interface AccessoryView : UIView
@property (strong,nonatomic) KDIBadgeButton *badgeButton;
@end

@implementation AccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    _badgeButton = [[KDIBadgeButton alloc] initWithFrame:CGRectZero];
    _badgeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_badgeButton setBadgePosition:KDIBadgeButtonBadgePositionRelativeToImage];
    [_badgeButton.button setContentEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_badgeButton.button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
    [_badgeButton.button setImageContentVerticalAlignment:KDIButtonContentVerticalAlignmentTop];
    [_badgeButton.button setImageContentHorizontalAlignment:KDIButtonContentHorizontalAlignmentCenter];
    [_badgeButton.button setTitleContentVerticalAlignment:KDIButtonContentVerticalAlignmentBottom];
    [_badgeButton.button setTitleContentHorizontalAlignment:KDIButtonContentHorizontalAlignmentCenter];
    [_badgeButton.button setImage:[UIImage imageNamed:@"ghost"] forState:UIControlStateNormal];
    [_badgeButton.button setTitle:@"Badge Button" forState:UIControlStateNormal];
    [_badgeButton.badgeView setBadge:@"123"];
    [self addSubview:_badgeButton];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _badgeButton}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _badgeButton}]];
    
    return self;
}

@end

@interface AccessoryViewWithAutoLayout : UIView
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation AccessoryViewWithAutoLayout

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_label setText:@"Accessory"];
    [_label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self addSubview:_label];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"One",@"Two",@"Three"]];
    [_segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_segmentedControl];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": _label}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _label}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-|" options:0 metrics:nil views:@{@"view": _segmentedControl, @"subview": _label}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _segmentedControl}]];
    
    return self;
}

@end

typedef NS_ENUM(NSInteger, ButtonTag) {
    ButtonTagNone = 0,
    ButtonTagAccessoryView = 1,
    ButtonTagAccessoryViewWithAutolayout = 2
};

@interface ViewController ()
@property (strong,nonatomic) UIBarButtonItem *customBarButtonItem;
@property (strong,nonatomic) UIView *customView;
@end

@implementation ViewController

- (NSString *)title {
    return @"Demo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KDIBadgeButton *customView = [[KDIBadgeButton alloc] initWithFrame:CGRectZero];
    
    [customView.button setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
    [customView.badgeView setBadge:@"12"];
    [customView.button addTarget:self action:@selector(_showTooltipAction:) forControlEvents:UIControlEventTouchUpInside];
    [customView sizeToFit];
    
    [self setCustomView:customView.button];
    
    [self setCustomBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customView]];
    
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flick"] style:UIBarButtonItemStylePlain target:self action:@selector(_showTooltipAction:)],self.customBarButtonItem]];
    
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithTitle:@"Show Tooltip" style:UIBarButtonItemStylePlain target:self action:@selector(_showTooltipAction:)]]];
}

- (IBAction)_showTooltipAction:(id)sender {
    KSOTooltipView *view = [[KSOTooltipView alloc] initWithFrame:CGRectZero];
    
    KSOTooltipTheme *theme = [view.theme copy];

    [theme setBackgroundColor:[KDIColorRandomRGB() colorWithAlphaComponent:0.5]];
    [theme setFillColor:KDIColorRandomRGB()];
    [theme setTextColor:[theme.fillColor KDI_contrastingColor]];
    [theme setTextStyle:UIFontTextStyleFootnote];
    
    [view setTheme:theme];
    
    if ([sender isEqual:self.customView]) {
        [view setAttributedText:({
            NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] initWithString:@"This tooltip is being presented from a bar button item with a custom view" attributes:@{NSFontAttributeName: theme.font}];
            
            [retval.string enumerateSubstringsInRange:NSMakeRange(0, retval.length) options:NSStringEnumerationByWords|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                [retval addAttribute:NSForegroundColorAttributeName value:KDIColorRandomRGB() range:substringRange];
            }];
            
            retval;
        })];
        [view setSourceBarButtonItem:self.customBarButtonItem];
        [view setAccessoryView:[[CheckmarkAccessoryView alloc] initWithFrame:CGRectZero]];
    }
    else if ([sender isKindOfClass:UIButton.class]) {
        switch ((ButtonTag)[(UIButton *)sender tag]) {
            case ButtonTagAccessoryView:
                [view setAccessoryView:[[AccessoryView alloc] initWithFrame:CGRectZero]];
                break;
            case ButtonTagAccessoryViewWithAutolayout:
                [view setAccessoryView:[[AccessoryViewWithAutoLayout alloc] initWithFrame:CGRectZero]];
                break;
            case ButtonTagNone:
            default:
                break;
        }

        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        UIColor *textColor = [theme.fillColor KDI_contrastingColor];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"The tooltip is being presented from a button and has a link to " attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Ars Technica" attributes:@{NSLinkAttributeName: [NSURL URLWithString:@"https://arstechnica.com/"], NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}]];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" in it that you can interact with" attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}]];

        [view setAttributedText:attrString];
        [view setSourceView:sender];
    }
    else {
        [view setText:@"This tooltip is being presented from a bar button item"];
        [view setSourceBarButtonItem:sender];
    }
    
    [view presentAnimated:YES completion:nil];
}

@end
