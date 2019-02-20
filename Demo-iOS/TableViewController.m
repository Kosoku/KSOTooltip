//
//  TableViewController.m
//  Demo-iOS
//
//  Created by William Towe on 10/12/18.
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

#import "TableViewController.h"

#import <KSOTooltip/KSOTooltip.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface TextTableViewCell : UITableViewCell
@property (strong,nonatomic) UITextField *textField;
@property (strong,nonatomic) UIButton *button;
@end

@implementation TextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"Type something";
    [self.textField KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        KSOTooltipView *view = [KSOTooltipView tooltipViewWithText:@"The best tooltip in all the land" sourceBarButtonItem:nil sourceView:self.textField];
        
        [view presentAnimated:YES completion:nil];
    } forControlEvents:UIControlEventEditingDidBegin];
    [self.contentView addSubview:self.textField];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"Tooltip" forState:UIControlStateNormal];
    [self.button KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        KSOTooltipView *view = [KSOTooltipView tooltipViewWithText:@"The best tooltip in all the land" sourceBarButtonItem:nil sourceView:self.button];
        
        [view presentAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.button sizeToFit];
    self.textField.rightView = self.button;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": self.textField}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": self.textField}]];
    
    return self;
}

@end

@interface TableViewController ()

@end

@implementation TableViewController

- (NSString *)title {
    return @"Table View";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44.0;
    [self.tableView registerClass:TextTableViewCell.class forCellReuseIdentifier:NSStringFromClass(TextTableViewCell.class)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextTableViewCell *retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TextTableViewCell.class) forIndexPath:indexPath];
    
    return retval;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

@end
