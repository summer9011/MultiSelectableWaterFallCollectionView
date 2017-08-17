//
//  WaterFallFlowLayout.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "WaterFallFlowLayout.h"

@interface WaterFallFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *sectionHeaderLastAttrDic;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *sectionFooterLastAttrDic;

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *cellLastAttrDic;

@end

@implementation WaterFallFlowLayout

#pragma mark - Override

- (void)prepareLayout {
    [super prepareLayout];
    
    NSLog(@"prepareLayout");
    
    self.sectionHeaderLastAttrDic = [NSMutableDictionary dictionary];
    self.sectionFooterLastAttrDic = [NSMutableDictionary dictionary];
    self.cellLastAttrDic = [NSMutableDictionary dictionary];
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.cellLastAttrDic setObject:attr forKey:indexPath];
        }
        
        NSIndexPath *sectionPath = [NSIndexPath indexPathWithIndex:section];
        
        UICollectionViewLayoutAttributes *sectionHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionPath];
        [self.sectionHeaderLastAttrDic setObject:sectionHeader forKey:sectionPath];
        
        UICollectionViewLayoutAttributes *sectionFooter = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:sectionPath];
        [self.sectionFooterLastAttrDic setObject:sectionFooter forKey:sectionPath];
    }
}

- (CGSize)collectionViewContentSize {
    NSLog(@"collectionViewContentSize");
    
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
                NSIndexPath *sectionPath = [NSIndexPath indexPathWithIndex:section];
                
                CGSize sectionHeaderSize = CGSizeZero;
                if (self.sectionHeaderLastAttrDic[sectionPath]) {
                    UICollectionViewLayoutAttributes *attr = self.sectionHeaderLastAttrDic[sectionPath];
                    sectionHeaderSize = attr.frame.size;
                } else {
                    sectionHeaderSize = [self sectionHeaderSizeWithSection:section];
                }
                
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
                    UICollectionViewLayoutAttributes *attr = self.cellLastAttrDic[indexPath];
                    
                    CGFloat rowLength = [rowLengthArr[postion] integerValue];
                    rowLength += (CGRectGetHeight(attr.frame) + self.itemPadding);
                    [rowLengthArr replaceObjectAtIndex:postion withObject:@(rowLength)];
                }
                
                CGFloat maxLength = [[rowLengthArr valueForKeyPath:@"@max.floatValue"] floatValue];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    contentSize.height += maxLength;
                } else {
                    contentSize.width += maxLength;
                }
                
                CGSize sectionFooterSize = CGSizeZero;
                if (self.sectionFooterLastAttrDic[sectionPath]) {
                    UICollectionViewLayoutAttributes *attr = self.sectionFooterLastAttrDic[sectionPath];
                    sectionFooterSize = attr.frame.size;
                } else {
                    sectionFooterSize = [self sectionFooterSizeWithSection:section];
                }
                
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
    
    for (NSIndexPath *sectionPath in self.sectionHeaderLastAttrDic) {
        UICollectionViewLayoutAttributes *attr = self.sectionHeaderLastAttrDic[sectionPath];
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [attrArr addObject:attr];
        }
    }
    
    for (NSIndexPath *indexPath in self.cellLastAttrDic) {
        UICollectionViewLayoutAttributes *attr = self.cellLastAttrDic[indexPath];
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [attrArr addObject:attr];
        }
    }
    
    for (NSIndexPath *sectionPath in self.sectionFooterLastAttrDic) {
        UICollectionViewLayoutAttributes *attr = self.sectionFooterLastAttrDic[sectionPath];
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [attrArr addObject:attr];
        }
    }
    
    return attrArr;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.alpha = 1.f;
    attr.frame = [self cellFrameWithIndexPath:indexPath isLast:YES];
    
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attr.alpha = 1.f;
    attr.frame = [self sectionFrameWithSupplementaryViewOfKind:elementKind indexPath:indexPath isLast:YES];
    
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
    attr.frame = [self cellFrameWithIndexPath:itemIndexPath isLast:NO];
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return self.cellLastAttrDic[itemIndexPath];
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    attr.alpha = 1.f;
    attr.frame = [self sectionFrameWithSupplementaryViewOfKind:elementKind indexPath:elementIndexPath isLast:NO];
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return self.sectionHeaderLastAttrDic[elementIndexPath];
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        return self.sectionFooterLastAttrDic[elementIndexPath];
    }
    
    return nil;
}

#pragma mark - Private Method

- (CGRect)cellFrameWithIndexPath:(NSIndexPath *)indexPath isLast:(BOOL)isLast {
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

- (CGRect)sectionFrameWithSupplementaryViewOfKind:(NSString *)elementKind indexPath:(NSIndexPath *)indexPath isLast:(BOOL)isLast {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGSize size = [self sectionHeaderSizeWithSection:indexPath.section];
        
        return CGRectMake(0, 0, size.width, size.height);
        
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        CGSize size = [self sectionFooterSizeWithSection:indexPath.section];
        
        return CGRectMake(0, 0, size.width, size.height);
    }
    
    return CGRectZero;
}

@end
