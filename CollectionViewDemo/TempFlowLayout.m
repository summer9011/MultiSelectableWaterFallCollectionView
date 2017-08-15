//
//  TempFlowLayout.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "TempFlowLayout.h"

@interface TempFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *attrDic;

@end

@implementation TempFlowLayout

#pragma mark - Override

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
            id <UICollectionViewDelegateFlowLayout> flowLayoutDelegate = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
            
            NSMutableArray<NSNumber *> *rowLengthArr = [NSMutableArray array];
            for (NSInteger row = 0; row < self.numberInRow; row ++) {
                [rowLengthArr addObject:@(0)];
            }
            
            CGSize contentSize;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                contentSize.width = CGRectGetWidth(self.collectionView.frame);
            } else {
                contentSize.height = CGRectGetHeight(self.collectionView.frame);
            }
            
            for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
                if (flowLayoutDelegate && [flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                    CGSize sectionHeaderSize = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
                    for (NSInteger row = 0; row < self.numberInRow; row ++) {
                        CGFloat length = [rowLengthArr[row] floatValue];
                        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                            [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionHeaderSize.height)];
                        } else {
                            [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionHeaderSize.width)];
                        }
                    }
                }
                
                for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
                    NSUInteger postion = item%self.numberInRow;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                    CGFloat edgeLength = [self.delegate layout:self lastEdgeLengthForItemAtIndexPath:indexPath scrollDirection:self.scrollDirection];
                    
                    NSNumber *rowLength = rowLengthArr[postion];
                    [rowLengthArr replaceObjectAtIndex:postion withObject:@([rowLength floatValue] + self.itemPadding + edgeLength + ((item == [self.collectionView numberOfItemsInSection:section] - 1)?self.itemPadding:0))];
                }
                
                if (flowLayoutDelegate && [flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
                    CGSize sectionFooterSize = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
                    for (NSInteger row = 0; row < self.numberInRow; row ++) {
                        CGFloat length = [rowLengthArr[row] floatValue];
                        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                            [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionFooterSize.height)];
                        } else {
                            [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionFooterSize.width)];
                        }
                    }
                }
            }
            
            __block CGFloat maxLength = 0;
            [rowLengthArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj floatValue] > maxLength) {
                    maxLength = [obj floatValue];
                }
            }];
            
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                contentSize.height += maxLength;
            } else {
                contentSize.width += maxLength;
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

- (void)finalizeCollectionViewUpdates {
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectionView layoutIfNeeded];
    }];
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    attr.alpha = 1.f;
    attr.frame = [self previousFrameWithIndexPath:itemIndexPath];
    
//    NSLog(@"  ");
//    
//    NSLog(@"initialLayout indexPath %@", attr.indexPath);
//    NSLog(@"initialLayout frame %@", NSStringFromCGRect(attr.frame));
//    NSLog(@"initialLayout center %@", NSStringFromCGPoint(attr.center));
//    NSLog(@"initialLayout size %@", NSStringFromCGSize(attr.size));
//    NSLog(@"initialLayout bounds %@", NSStringFromCGRect(attr.bounds));
//    NSLog(@"  ");
    
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    attr.alpha = 1.f;
    attr.frame = [self lastFrameWithIndexPath:itemIndexPath];
    
//    NSLog(@"  ");
//    
//    NSLog(@"finalLayout indexPath %@", attr.indexPath);
//    NSLog(@"finalLayout frame %@", NSStringFromCGRect(attr.frame));
//    NSLog(@"finalLayout center %@", NSStringFromCGPoint(attr.center));
//    NSLog(@"finalLayout size %@", NSStringFromCGSize(attr.size));
//    NSLog(@"finalLayout bounds %@", NSStringFromCGRect(attr.bounds));
//    
//    NSLog(@"  ");
    
    return attr;
}

- (CGRect)previousFrameWithIndexPath:(NSIndexPath *)indexPath {
    return [self frameWithIndexPath:indexPath isLast:NO];
}

- (CGRect)lastFrameWithIndexPath:(NSIndexPath *)indexPath {
    return [self frameWithIndexPath:indexPath isLast:YES];
}

- (CGRect)frameWithIndexPath:(NSIndexPath *)indexPath isLast:(BOOL)isLast {
    CGRect itemFrame = CGRectZero;
    
    NSMutableArray<NSNumber *> *rowLengthArr = [NSMutableArray array];
    for (NSInteger row = 0; row < self.numberInRow; row ++) {
        [rowLengthArr addObject:@(0)];
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        itemFrame.size.width = floorf((CGRectGetWidth(self.collectionView.frame) - self.itemPadding * (self.numberInRow + 1))/(CGFloat)self.numberInRow);
    } else {
        itemFrame.size.height = floorf((CGRectGetHeight(self.collectionView.frame) - self.itemPadding * (self.numberInRow + 1))/(CGFloat)self.numberInRow);
    }
    
    id <UICollectionViewDelegateFlowLayout> flowLayoutDelegate = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        if (flowLayoutDelegate && [flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            CGSize sectionHeaderSize = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
            for (NSInteger row = 0; row < self.numberInRow; row ++) {
                CGFloat length = [rowLengthArr[row] floatValue];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionHeaderSize.height)];
                } else {
                    [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionHeaderSize.width)];
                }
            }
        }
        
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
            NSUInteger postion = item%self.numberInRow;
            
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat edgeLength;
            if (isLast) {
                edgeLength = [self.delegate layout:self lastEdgeLengthForItemAtIndexPath:tmpIndexPath scrollDirection:self.scrollDirection];
            } else {
                edgeLength = [self.delegate layout:self previousEdgeLengthForItemAtIndexPath:tmpIndexPath scrollDirection:self.scrollDirection];
            }
            
            NSNumber *rowLength = rowLengthArr[postion];
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                itemFrame.origin.y = (self.itemPadding + [rowLength floatValue]);
                [rowLengthArr replaceObjectAtIndex:postion withObject:@(itemFrame.origin.y + edgeLength)];
            } else {
                itemFrame.origin.x = (self.itemPadding + [rowLength floatValue]);
                [rowLengthArr replaceObjectAtIndex:postion withObject:@(itemFrame.origin.x + edgeLength)];
            }
            
            if (indexPath.item == item) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    itemFrame.origin.x = self.itemPadding + (itemFrame.size.width + self.itemPadding) * postion;
                    itemFrame.size.height = edgeLength;
                } else {
                    itemFrame.origin.y = self.itemPadding + (itemFrame.size.height + self.itemPadding) * postion;
                    itemFrame.size.width = edgeLength;
                }
                
                break;
            }
        }
        
        if (indexPath.section == section) {
            break;
        }
        
        if (flowLayoutDelegate && [flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            CGSize sectionFooterSize = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
            for (NSInteger row = 0; row < self.numberInRow; row ++) {
                CGFloat length = [rowLengthArr[row] floatValue];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionFooterSize.height)];
                } else {
                    [rowLengthArr replaceObjectAtIndex:row withObject:@(length + sectionFooterSize.width)];
                }
            }
        }
    }
    
    return itemFrame;
}

@end
