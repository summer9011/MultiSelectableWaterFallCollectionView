//
//  TempCell.h
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

#define OffsetY 10

extern NSString *const TempCellIdentifier;

@class TempCell;

@protocol TempCellDelegate <NSObject>

@required

- (void)didCellSelectedInsert:(TempCell *)cell;

- (void)didCellSelectedDelete:(TempCell *)cell;

@end

@interface TempCell : UICollectionViewCell

@property (nonatomic, weak) id<TempCellDelegate> delegate;
@property (nonatomic, weak) UIViewController *bindVC;

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, copy) UIColor *firstColor;
@property (nonatomic, copy) UIColor *secondColor;

+ (CGSize)firstViewSize;
+ (CGSize)seconvViewSize;
+ (CGSize)cellSizeWithIsSelected:(BOOL)isSelected offsetY:(CGFloat)offsetY;

@end
