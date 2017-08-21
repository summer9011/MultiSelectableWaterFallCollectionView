//
//  WaterFallFlowLayout.h
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 WaterFallMode

 - WaterFallModeNone: None
 - WaterFallModeReload: Reload all data source, sections or items.
 - WaterFallModeInsert: Insert a item.
 - WaterFallModeDelete: Delete a item.
 - WaterFallModeSelect: Select a item.
 */
typedef NS_ENUM(NSUInteger, WaterFallModeType) {
    WaterFallModeNone = 0,
    WaterFallModeReload = 1,
    WaterFallModeInsert = 2,
    WaterFallModeDelete = 3,
    WaterFallModeSelect = 4
};

@class WaterFallFlowLayout;

@protocol WaterFallFlowLayoutDelegate <NSObject>

@required

/**
 Return the height when data source is in previous status.

 @param layout Layout
 @param indexPath indexPath
 @param scrollDirection direction
 @return The height
 */
- (CGFloat)layout:(WaterFallFlowLayout *)layout previousHeightForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

/**
 Return the height when data source is in current status.
 
 @param layout Layout
 @param indexPath indexPath
 @param scrollDirection direction
 @return The height
 */
- (CGFloat)layout:(WaterFallFlowLayout *)layout lastHeightForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

@end

@interface WaterFallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<WaterFallFlowLayoutDelegate> delegate;

/**
 Item padding.
 */
@property (nonatomic, assign) CGFloat itemPadding;

/**
 The count in a row.
 */
@property (nonatomic, assign) NSUInteger numberInRow;

@end
