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

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;

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
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.firstLabel.font = [UIFont systemFontOfSize:20];
    self.firstLabel.adjustsFontSizeToFitWidth = YES;
    [self.firstView addSubview:self.firstLabel];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.firstView).offset(10);
        make.trailing.equalTo(self.firstView).offset(-10);
    }];
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.secondView];
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo([TempCell seconvViewSize].height);
    }];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.secondLabel.font = [UIFont systemFontOfSize:60];
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    self.secondLabel.adjustsFontSizeToFitWidth = YES;
    [self.secondView addSubview:self.secondLabel];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.secondView);
    }];
    
    [self.contentView bringSubviewToFront:self.firstView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnView:)];
    [self.firstView addGestureRecognizer:longPress];
}

#pragma Gesture

- (void)longPressOnView:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Choose Operation" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *insertAction = [UIAlertAction actionWithTitle:@"Insert" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate didCellSelectedInsert:self];
            }];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate didCellSelectedDelete:self];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alertVC addAction:insertAction];
            [alertVC addAction:deleteAction];
            [alertVC addAction:cancelAction];
            
            [self.bindVC presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Setting

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.firstLabel.text = [NSString stringWithFormat:@"Cell {%ld-%ld}", indexPath.section, indexPath.item];
    self.secondLabel.text = [NSString stringWithFormat:@"%ld", indexPath.item];
}

- (void)setFirstColor:(UIColor *)firstColor {
    _firstColor = firstColor;
    
    self.firstView.backgroundColor = firstColor;
    self.secondLabel.textColor = firstColor;
}

- (void)setSecondColor:(UIColor *)secondColor {
    _secondColor = secondColor;
    
    self.secondView.backgroundColor = secondColor;
    self.firstLabel.textColor = secondColor;
}

#pragma mark - Static Method

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
