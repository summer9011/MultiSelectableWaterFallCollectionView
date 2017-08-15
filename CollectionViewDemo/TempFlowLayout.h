//
//  TempFlowLayout.h
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TempFlowDelegate <NSObject>

- (NSArray<NSIndexPath *> *)indexPathsWithIsCurrent:(BOOL)isCurrent;

@end

@interface TempFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<TempFlowDelegate> delegate;

@end
