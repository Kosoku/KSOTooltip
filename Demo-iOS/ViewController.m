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

@interface ViewController ()
@property (strong,nonatomic) UIBarButtonItem *customBarButtonItem;
@end

@implementation ViewController

- (NSString *)title {
    return @"Demo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Show",@"Tooltip"]];
    
    [segmentedControl setMomentary:YES];
    [segmentedControl setApportionsSegmentWidthsByContent:YES];
    [segmentedControl addTarget:self action:@selector(_showTooltipAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl sizeToFit];
    
    [self setCustomBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:segmentedControl]];
    
    [self.navigationItem setLeftBarButtonItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_showTooltipAction:)],self.customBarButtonItem]];
    
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithTitle:@"Show Tooltip" style:UIBarButtonItemStylePlain target:self action:@selector(_showTooltipAction:)]]];
}

- (IBAction)_showTooltipAction:(id)sender {
    KSOTooltipViewController *viewController = [[KSOTooltipViewController alloc] init];
    KSOTooltipArrowDirection directions = arc4random_uniform((uint32_t)KSOTooltipArrowDirectionAll) + KSOTooltipArrowDirectionUp;
    
    KSTLog(@"allowed directions: %@",@(directions));
    
    [viewController setAllowedArrowDirections:directions];
    
    if ([sender isKindOfClass:UISegmentedControl.class]) {
        [viewController setText:@"This tooltip is being presented from a bar button item with a custom view"];
        [viewController setBarButtonItem:self.customBarButtonItem];
    }
    else if ([sender isKindOfClass:UIView.class]) {
        [viewController setBackgroundColor:KDIColorRandomRGB()];
        [viewController setTextColor:[viewController.backgroundColor KDI_contrastingColor]];
        [viewController setText:@"The tooltip is being presented from a button"];
        [viewController setSourceView:sender];
    }
    else {
        [viewController setText:@"This tooltip is being presented from a bar button item"];
        [viewController setBarButtonItem:sender];
    }
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
