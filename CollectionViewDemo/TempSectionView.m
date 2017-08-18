//
//  TempSectionView.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/16.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "TempSectionView.h"
#import <Masonry.h>

@interface TempSectionView ()

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation TempSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
    }
    
    return self;
}

- (void)configSubView {
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:22];
    self.tipLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.tipLabel];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
    }];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    
    self.backgroundColor = color;
}

@end

NSString *const TempSectionHeaderIdentifier = @"TempSectionHeaderIdentifier";
@implementation TempSectionHeaderView

- (void)setIndexPath:(NSIndexPath *)indexPath {
    [super setIndexPath:indexPath];
    
    self.tipLabel.text = [NSString stringWithFormat:@"Section Header {%ld}", indexPath.section];
}

@end

NSString *const TempSectionFooterIdentifier = @"TempSectionFooterIdentifier";
@implementation TempSectionFooterView

- (void)setIndexPath:(NSIndexPath *)indexPath {
    [super setIndexPath:indexPath];
    
    self.tipLabel.text = [NSString stringWithFormat:@"Section Footer {%ld}", indexPath.section];
}
@end
