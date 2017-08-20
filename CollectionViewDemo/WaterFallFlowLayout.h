//
//  WaterFallFlowLayout.h
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WaterFallModeType) {
    WaterFallModeNone = 0,
    WaterFallModeReload = 1,
    WaterFallModeInsert = 2,
    WaterFallModeDelete = 3,
    WaterFallModeSelect = 4
};

@class WaterFallFlowLayout;

@protocol WaterFallFlowLayoutDelegate <NSObject>

- (WaterFallModeType)layoutOperationMode:(WaterFallFlowLayout *)layout;

- (NSIndexPath *)layoutOperationIndexPath:(WaterFallFlowLayout *)layout;

- (CGFloat)layout:(WaterFallFlowLayout *)layout previousHeightForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

- (CGFloat)layout:(WaterFallFlowLayout *)layout lastHeightForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

@end

@interface WaterFallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<WaterFallFlowLayoutDelegate> delegate;

@property (nonatomic, assign) CGFloat itemPadding;
@property (nonatomic, assign) NSUInteger numberInRow;

@end
