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

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *insertIndexPathArr;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *deleteIndexPathArr;

@property (nonatomic, assign) UICollectionUpdateAction updateAction;

@end

@implementation WaterFallFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemPadding = 0;
        self.numberInRow = 1;
    }
    
    return self;
}

#pragma mark - Override

- (void)prepareLayout {
    [super prepareLayout];
    
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
    if ([self.collectionView numberOfSections] > 0) {
        NSUInteger itemCount = 0;
        for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
            itemCount += [self.collectionView numberOfItemsInSection:section];
        }
        
        if (itemCount > 0) {
            CGSize contentSize = CGSizeZero;
            contentSize.width = CGRectGetWidth(self.collectionView.frame);
            
            for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
                NSIndexPath *sectionPath = [NSIndexPath indexPathWithIndex:section];
                
                //Header
                CGSize sectionHeaderSize = CGSizeZero;
                if (self.sectionHeaderLastAttrDic[sectionPath]) {
                    UICollectionViewLayoutAttributes *attr = self.sectionHeaderLastAttrDic[sectionPath];
                    sectionHeaderSize = attr.frame.size;
                } else {
                    sectionHeaderSize = [self sectionHeaderSizeWithSection:section];
                }
                contentSize.height += sectionHeaderSize.height;
                
                //Cell
                NSMutableArray<NSNumber *> *rowHeightArr = [NSMutableArray array];
                for (NSInteger row = 0; row < self.numberInRow; row ++) {
                    [rowHeightArr addObject:@(self.itemPadding)];
                }
                
                for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
                    NSUInteger postion = item%self.numberInRow;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                    UICollectionViewLayoutAttributes *attr = self.cellLastAttrDic[indexPath];
                    
                    CGFloat rowHeight = [rowHeightArr[postion] integerValue];
                    rowHeight += (CGRectGetHeight(attr.frame) + self.itemPadding);
                    [rowHeightArr replaceObjectAtIndex:postion withObject:@(rowHeight)];
                }
                
                contentSize.height += [[rowHeightArr valueForKeyPath:@"@max.floatValue"] floatValue];
                
                //Footer
                CGSize sectionFooterSize = CGSizeZero;
                if (self.sectionFooterLastAttrDic[sectionPath]) {
                    UICollectionViewLayoutAttributes *attr = self.sectionFooterLastAttrDic[sectionPath];
                    sectionFooterSize = attr.frame.size;
                } else {
                    sectionFooterSize = [self sectionFooterSizeWithSection:section];
                }
                contentSize.height += sectionFooterSize.height;
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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    self.insertIndexPathArr = [NSMutableArray array];
    self.deleteIndexPathArr = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *item in updateItems) {
        switch (item.updateAction) {
            case UICollectionUpdateActionInsert: {
                [self.insertIndexPathArr addObject:item.indexPathAfterUpdate];
                self.updateAction = UICollectionUpdateActionInsert;
            }
                break;
            case UICollectionUpdateActionDelete: {
                [self.deleteIndexPathArr addObject:item.indexPathBeforeUpdate];
                self.updateAction = UICollectionUpdateActionDelete;
            }
                break;
            case UICollectionUpdateActionReload: {
                self.updateAction = UICollectionUpdateActionReload;
            }
                break;
            case UICollectionUpdateActionMove: {
                self.updateAction = UICollectionUpdateActionMove;
            }
                break;
            default: {
                self.updateAction = UICollectionUpdateActionNone;
            }
                break;
        }
    }
    
}

- (void)finalizeCollectionViewUpdates {
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectionView layoutIfNeeded];
    }];
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    switch (self.updateAction) {
        case UICollectionUpdateActionInsert: {
            if ([self.insertIndexPathArr containsObject:itemIndexPath]) {
                attr.alpha = 0.f;
                attr.transform = CGAffineTransformMakeScale(0.f, 0.f);
            } else {
                attr.alpha = 1.f;
                attr.transform = CGAffineTransformMakeScale(1.f, 1.f);
            }
        }
            break;
        case UICollectionUpdateActionDelete: {
            return self.cellLastAttrDic[itemIndexPath];
        }
            break;
        case UICollectionUpdateActionReload: {
            attr.alpha = 1.f;
            attr.frame = [self cellFrameWithIndexPath:itemIndexPath isLast:NO];
        }
            break;
        default:
            break;
    }
    
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
    itemFrame.size.width = floorf((CGRectGetWidth(self.collectionView.frame) - self.itemPadding * (self.numberInRow + 1))/(CGFloat)self.numberInRow);
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        //Header
        CGSize sectionHeaderSize = [self sectionHeaderSizeWithSection:section];
        itemFrame.origin.y += sectionHeaderSize.height;
        
        //Cell
        NSMutableArray<NSNumber *> *rowOffsetYArr = [NSMutableArray array];
        for (NSInteger row = 0; row < self.numberInRow; row ++) {
            [rowOffsetYArr addObject:@(self.itemPadding)];
        }
        
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item ++) {
            NSUInteger postion = item%self.numberInRow;
            
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat height = 0;
            if (isLast) {
                height = [self.delegate layout:self lastHeightForItemAtIndexPath:tmpIndexPath scrollDirection:self.scrollDirection];
            } else {
                height = [self.delegate layout:self previousHeightForItemAtIndexPath:tmpIndexPath scrollDirection:self.scrollDirection];
            }
            
            CGFloat rowOffsetY = [rowOffsetYArr[postion] integerValue];
            if (section < indexPath.section || item < indexPath.item) {
                rowOffsetY += (height + self.itemPadding);
                [rowOffsetYArr replaceObjectAtIndex:postion withObject:@(rowOffsetY)];
                
            } else if (item == indexPath.item) {
                itemFrame.origin.x = self.itemPadding + (itemFrame.size.width + self.itemPadding) * postion;
                itemFrame.origin.y += rowOffsetY;
                itemFrame.size.height = height;
                
                break;
            }
        }
        
        if (indexPath.section == section) {
            break;
        }
        
        itemFrame.origin.y += [[rowOffsetYArr valueForKeyPath:@"@max.floatValue"] floatValue];
        
        //Footer
        CGSize sectionFooterSize = [self sectionFooterSizeWithSection:section];
        itemFrame.origin.y += sectionFooterSize.height;
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
        CGRect frame = CGRectZero;
        frame.size = [self sectionHeaderSizeWithSection:indexPath.section];
        frame.origin.x = 0;
        
        if (indexPath.section == 0) {
            frame.origin.y = 0;
        } else {
            NSUInteger prevSection = indexPath.section - 1;
            NSIndexPath *prevSectionPath = [NSIndexPath indexPathWithIndex:prevSection];
            
            CGRect prevSectionFooterFrame = [self sectionFrameWithSupplementaryViewOfKind:UICollectionElementKindSectionFooter indexPath:prevSectionPath isLast:isLast];
            frame.origin.y += CGRectGetMaxY(prevSectionFooterFrame);
        }
        
        return frame;
        
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        CGRect frame = CGRectZero;
        frame.size = [self sectionFooterSizeWithSection:indexPath.section];
        frame.origin.x = 0;
        
        NSUInteger itemsCount = [self.collectionView numberOfItemsInSection:indexPath.section];
        
        if (itemsCount == 0) {
            CGRect currentSectionHeaderFrame = [self sectionFrameWithSupplementaryViewOfKind:UICollectionElementKindSectionHeader indexPath:indexPath isLast:isLast];
            frame.origin.y += (CGRectGetMaxY(currentSectionHeaderFrame) + self.itemPadding);
            
        } else {
            NSInteger beginItemIndex = itemsCount - self.numberInRow;
            if (beginItemIndex < 0) {
                beginItemIndex = 0;
            }
            
            NSMutableArray<NSNumber *> *lastItemsOffsetYArr = [NSMutableArray array];
            
            for (NSInteger item = beginItemIndex; item < itemsCount; item ++) {
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:item inSection:indexPath.section];
                
                CGRect itemFrame = [self cellFrameWithIndexPath:cellIndexPath isLast:isLast];
                [lastItemsOffsetYArr addObject:@(CGRectGetMaxY(itemFrame))];
            }
            
            frame.origin.y += ([[lastItemsOffsetYArr valueForKeyPath:@"@max.floatValue"] floatValue] + self.itemPadding);
        }
        
        return frame;
    }
    
    return CGRectZero;
}

@end
