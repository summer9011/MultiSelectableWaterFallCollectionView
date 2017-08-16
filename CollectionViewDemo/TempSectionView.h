//
//  TempSectionView.h
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/16.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempSectionView : UICollectionReusableView

@property (nonatomic, copy) UIColor *color;

@end


extern NSString *const TempSectionHeaderIdentifier;
@interface TempSectionHeaderView : TempSectionView
@end

extern NSString *const TempSectionFooterIdentifier;
@interface TempSectionFooterView : TempSectionView
@end
