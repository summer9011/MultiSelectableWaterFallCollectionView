//
//  TempSectionView.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/16.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "TempSectionView.h"

@implementation TempSectionView

- (void)setColor:(UIColor *)color {
    _color = color;
    
    self.backgroundColor = color;
}

@end

NSString *const TempSectionHeaderIdentifier = @"TempSectionHeaderIdentifier";
@implementation TempSectionHeaderView
@end

NSString *const TempSectionFooterIdentifier = @"TempSectionFooterIdentifier";
@implementation TempSectionFooterView
@end
