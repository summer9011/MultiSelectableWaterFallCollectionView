//
//  WaterFallFlowLayout.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "WaterFallFlowLayout.h"

@interface WaterFallFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *supplementaryViewAttrDic;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *attrDic;

@end

@implementation WaterFallFlowLayout

#pragma mark - Override

- (void)prepareLayout {
    [super prepareLayout];
    
    self.supplementaryViewAttrDic = [NSMutableDictionary dictionary];
    self.attrDic = [NSMutableDictionary dictionary];
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        NSIndexPath *sectionPath = [NSIndexPath indexPathWithIndex:section];
        
        UICollectionViewLayoutAttributes *sectionHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionPath];
        [self.supplementaryViewAttrDic setObject:sectionHeader forKey:sectionPath];
        
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrDic setObject:attr forKey:indexPath];
        }
        
        UICollectionViewLayoutAttributes *sectionFooter = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:sectionPath];
        [self.supplementaryViewAttrDic setObject:sectionFooter forKey:sectionPath];
    }
}

- (CGSize)collectionViewContentSize {
    if ([self.collectionView numberOfSections] > 0) {
        NSUInteger itemCount = 0;
        for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
            itemCount += [self.collectionView numberOfItemsInSection:section];
        }
        if (itemCount > 0) {
            CGSize contentSize = CGSizeZero;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                contentSize.width = CGRectGetWidth(self.collectionView.frame);
            } else {
                contentSize.height = CGRectGetHeight(self.collectionView.frame);
            }
            
            for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
                CGSize sectionHeaderSize = [self sectionHeaderSizeWithSection:section];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    contentSize.height += sectionHeaderSize.height;
                } else {
                    contentSize.width += sectionHeaderSize.width;
                }
                
                NSMutableArray<NSNumber *> *rowLengthArr = [NSMutableArray array];
                for (NSInteger row = 0; row < self.numberInRow; row ++) {
                    [rowLengthArr addObject:@(self.itemPadding)];
                }
                
                for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
                    NSUInteger postion = item%self.numberInRow;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                    CGFloat edgeLength = [self.delegate layout:self lastEdgeLengthForItemAtIndexPath:indexPath scrollDirection:self.scrollDirection];
                    
                    CGFloat rowLength = [rowLengthArr[postion] integerValue];
                    rowLength += (edgeLength + self.itemPadding);
                    [rowLengthArr replaceObjectAtIndex:postion withObject:@(rowLength)];
                }
                
                CGFloat maxLength = [[rowLengthArr valueForKeyPath:@"@max.floatValue"] floatValue];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    contentSize.height += maxLength;
                } else {
                    contentSize.width += maxLength;
                }
                
                CGSize sectionFooterSize = [self sectionFooterSizeWithSection:section];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    contentSize.height += sectionFooterSize.height;
                } else {
                    contentSize.width += sectionFooterSize.width;
                }
            }
            
            return contentSize;
        } else {
            return self.collectionView.frame.size;
        }
    } else {
        return self.collectionView.frame.size;
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attrArr = [NSMutableArray array];
    
    for (NSIndexPath *sectionPath in self.supplementaryViewAttrDic) {
        UICollectionViewLayoutAttributes *attr = self.supplementaryViewAttrDic[sectionPath];
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [attrArr addObject:attr];
        }
    }
    
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
    attr.frame = [self lastFrameWithIndexPath:indexPath];
    
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attr.frame = [self sectionFrameWithSupplementaryViewOfKind:elementKind indexPath:indexPath];
    
    return attr;
}

- (void)finalizeCollectionViewUpdates {
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectionView layoutIfNeeded];
    }];
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    attr.alpha = 1.f;
    attr.frame = [self previousFrameWithIndexPath:itemIndexPath];
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    attr.alpha = 1.f;
    attr.frame = [self lastFrameWithIndexPath:itemIndexPath];
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    attr.alpha = 1.f;
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    attr.alpha = 1.f;
    return attr;
}

#pragma mark - Private Method

- (CGRect)previousFrameWithIndexPath:(NSIndexPath *)indexPath {
    return [self frameWithIndexPath:indexPath isLast:NO];
}

- (CGRect)lastFrameWithIndexPath:(NSIndexPath *)indexPath {
    return [self frameWithIndexPath:indexPath isLast:YES];
}

- (CGSize)sectionHeaderSizeWithSection:(NSUInteger)section {
    CGSize size = CGSizeZero;
    
    id <UICollectionViewDelegateFlowLayout> flowLayoutDelegate = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if (flowLayoutDelegate && [flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        size = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    } else {
        size = self.headerReferenceSize;
    }
    
    return size;
}

- (CGSize)sectionFooterSizeWithSection:(NSUInteger)section {
    CGSize size = CGSizeZero;
    
    id <UICollectionViewDelegateFlowLayout> flowLayoutDelegate = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if (flowLayoutDelegate && [flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        size = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    } else {
        size = self.footerReferenceSize;
    }
    
    return size;
}

- (CGRect)frameWithIndexPath:(NSIndexPath *)indexPath isLast:(BOOL)isLast {
    CGRect itemFrame = CGRectZero;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        itemFrame.size.width = floorf((CGRectGetWidth(self.collectionView.frame) - self.itemPadding * (self.numberInRow + 1))/(CGFloat)self.numberInRow);
    } else {
        itemFrame.size.height = floorf((CGRectGetHeight(self.collectionView.frame) - self.itemPadding * (self.numberInRow + 1))/(CGFloat)self.numberInRow);
    }
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        CGSize sectionHeaderSize = [self sectionHeaderSizeWithSection:section];
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            itemFrame.origin.y += sectionHeaderSize.height;
        } else {
            itemFrame.origin.x += sectionHeaderSize.width;
        }
        
        NSMutableArray<NSNumber *> *rowOffsetArr = [NSMutableArray array];
        for (NSInteger row = 0; row < self.numberInRow; row ++) {
            [rowOffsetArr addObject:@(self.itemPadding)];
        }
        
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
            NSUInteger postion = item%self.numberInRow;
            
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat edgeLength = 0;
            if (isLast) {
                edgeLength = [self.delegate layout:self lastEdgeLengthForItemAtIndexPath:tmpIndexPath scrollDirection:self.scrollDirection];
            } else {
                edgeLength = [self.delegate layout:self previousEdgeLengthForItemAtIndexPath:tmpIndexPath scrollDirection:self.scrollDirection];
            }
            
            CGFloat rowOffset = [rowOffsetArr[postion] integerValue];
            if (item < indexPath.item) {
                rowOffset += (edgeLength + self.itemPadding);
                [rowOffsetArr replaceObjectAtIndex:postion withObject:@(rowOffset)];
                
            } else if (item == indexPath.item) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    itemFrame.origin.x = self.itemPadding + (itemFrame.size.width + self.itemPadding) * postion;
                    itemFrame.origin.y += rowOffset;
                    itemFrame.size.height = edgeLength;
                } else {
                    itemFrame.origin.x += rowOffset;
                    itemFrame.origin.y = self.itemPadding + (itemFrame.size.height + self.itemPadding) * postion;
                    itemFrame.size.width = edgeLength;
                }
                
                break;
            }
        }
        
        if (indexPath.section == section) {
            break;
        }
        
        CGFloat maxLength = [[rowOffsetArr valueForKeyPath:@"@max.floatValue"] floatValue];
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            itemFrame.origin.y += maxLength;
        } else {
            itemFrame.origin.x += maxLength;
        }
        
        CGSize sectionFooterSize = [self sectionFooterSizeWithSection:section];
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            itemFrame.origin.y += sectionFooterSize.height;
        } else {
            itemFrame.origin.x += sectionFooterSize.width;
        }
    }
    
    return itemFrame;
}

- (CGRect)sectionFrameWithSupplementaryViewOfKind:(NSString *)elementKind indexPath:(NSIndexPath *)indexPath {
    CGSize size = [self sectionHeaderSizeWithSection:indexPath.section];
    return CGRectMake(0, 0, size.width, size.height);
}

@end
