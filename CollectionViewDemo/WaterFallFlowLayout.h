//
//  WaterFallFlowLayout.h
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFallFlowLayout;

@protocol WaterFallFlowLayoutDelegate <NSObject>

- (CGFloat)layout:(WaterFallFlowLayout *)layout previousEdgeLengthForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

- (CGFloat)layout:(WaterFallFlowLayout *)layout lastEdgeLengthForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

@end

@interface WaterFallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<WaterFallFlowLayoutDelegate> delegate;

@property (nonatomic, assign) CGFloat itemPadding;
@property (nonatomic, assign) NSUInteger numberInRow;

@end
