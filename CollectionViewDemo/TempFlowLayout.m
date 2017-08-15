//
//  TempFlowLayout.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "TempFlowLayout.h"
#import "TempCell.h"

@interface TempFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *attrDic;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *reloadArr;

@end

@implementation TempFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.attrDic = [NSMutableDictionary dictionary];
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrDic setObject:attr forKey:indexPath];
        }
    }
}

- (CGSize)collectionViewContentSize {
    if ([self.collectionView numberOfSections] > 0) {
        NSUInteger itemCount = 0;
        for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
            itemCount += [self.collectionView numberOfItemsInSection:section];
        }
        if (itemCount > 0) {
            CGFloat height = 0;
            
            for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
                height += self.sectionInset.top + (self.itemSize.height + self.minimumLineSpacing) * [self.collectionView numberOfItemsInSection:section] + self.sectionInset.bottom;
            }
            
            return CGSizeMake(self.sectionInset.left + self.itemSize.width + self.minimumInteritemSpacing + self.sectionInset.right, height);
        } else {
            return self.collectionView.frame.size;
        }
    } else {
        return self.collectionView.frame.size;
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attrArr = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.attrDic) {
        UICollectionViewLayoutAttributes *attr = self.attrDic[indexPath];
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [attrArr addObject:attr];
        }
    }
    
    return attrArr;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = [self currentFrameWithIndexPath:indexPath];
    
    return attr;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.reloadArr = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        NSIndexPath *beforeIndexPath = updateItem.indexPathBeforeUpdate;
        [self.reloadArr addObject:beforeIndexPath];
    }
}

- (void)finalizeCollectionViewUpdates {
    [UIView animateWithDuration:0.3 animations:^{
        [self.collectionView layoutIfNeeded];
    }];
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    attr.frame = [self lastFrameWithIndexPath:itemIndexPath];
    
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    attr.alpha = 1.f;
    attr.frame = [self currentFrameWithIndexPath:itemIndexPath];
    
    return attr;
}

- (CGRect)lastFrameWithIndexPath:(NSIndexPath *)indexPath {
    return [self frameWithIndexPath:indexPath isCurrent:NO];
}

- (CGRect)currentFrameWithIndexPath:(NSIndexPath *)indexPath {
    return [self frameWithIndexPath:indexPath isCurrent:YES];
}

- (CGRect)frameWithIndexPath:(NSIndexPath *)selectedIndexPath isCurrent:(BOOL)isCurrent {
    NSArray<NSIndexPath *> *indexPaths = [self.delegate indexPathsWithIsCurrent:isCurrent];
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
    
    CGFloat offsetY = 0;
    CGFloat height = 0;
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        offsetY += self.sectionInset.top;
        
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            CGSize size = [TempCell cellSizeWithIsSelected:[indexPaths containsObject:indexPath] offsetY:OffsetY];
            if (item < selectedIndexPath.item) {
                offsetY += self.minimumLineSpacing + size.height;
            } else if (item == selectedIndexPath.item) {
                offsetY += self.minimumLineSpacing;
                height  += size.height;
                
                break;
            }
        }
        
        if (section == selectedIndexPath.section) {
            break;
        }
        
        offsetY += self.sectionInset.bottom;
    }
    
    frame.origin.y = offsetY;
    frame.size.height = height;
    
    return frame;
}

@end
