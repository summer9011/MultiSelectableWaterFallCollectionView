//
//  TempFlowLayout.h
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TempFlowLayout;

@protocol TempFlowDelegate <NSObject>

- (CGFloat)layout:(TempFlowLayout *)layout previousEdgeLengthForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

- (CGFloat)layout:(TempFlowLayout *)layout lastEdgeLengthForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

@end

@interface TempFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<TempFlowDelegate> delegate;

@property (nonatomic, assign) NSUInteger itemPadding;
@property (nonatomic, assign) NSUInteger numberInRow;

@end
