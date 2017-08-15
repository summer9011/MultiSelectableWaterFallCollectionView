//
//  TempCell.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "TempCell.h"

NSString *const TempCellIdentifier = @"TempCellIdentifier";

@interface TempCell ()

@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;

@end

@implementation TempCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:1.f];
        [self configSubView];
    }
    
    return self;
}

- (void)configSubView {
    self.firstView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.firstView];
    
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo([TempCell firstViewSize].height);
    }];
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.secondView];
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo([TempCell seconvViewSize].height);
    }];
    
    [self.contentView bringSubviewToFront:self.firstView];
}

- (void)setFirstColor:(UIColor *)firstColor {
    _firstColor = firstColor;
    
    self.firstView.backgroundColor = firstColor;
}

- (void)setSecondColor:(UIColor *)secondColor {
    _secondColor = secondColor;
    
    self.secondView.backgroundColor = secondColor;
}

+ (CGSize)firstViewSize {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
}

+ (CGSize)seconvViewSize {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
}

+ (CGSize)cellSizeWithIsSelected:(BOOL)isSelected offsetY:(CGFloat)offsetY {
    CGFloat height;
    if (isSelected) {
        height = [TempCell firstViewSize].height + [TempCell seconvViewSize].height;
    } else {
        height = [TempCell firstViewSize].height + offsetY;
    }
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, height);
}

@end