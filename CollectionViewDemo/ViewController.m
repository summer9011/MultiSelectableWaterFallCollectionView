//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "ViewController.h"
#import "TempCell.h"
#import "TempSectionView.h"

#import "WaterFallFlowLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, WaterFallFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WaterFallFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSArray<UIColor *> *> *> *dataArr;
@property (nonatomic, assign) NSUInteger sectionNumber;
@property (nonatomic, assign) NSUInteger itemNumber;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *previousSelectedIndexPathArr;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *lastSelectedIndexPathArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:1.f];
    
    [self configDataSource];
    [self configCollectionView];
}

- (void)configDataSource {
    self.previousSelectedIndexPathArr = [NSMutableArray array];
    self.lastSelectedIndexPathArr = [NSMutableArray array];
    
    self.sectionNumber = 1;
    self.itemNumber = 22;
    
    self.dataArr = [NSMutableArray array];
    for (NSInteger section = 0; section < self.sectionNumber; section ++) {
        NSMutableArray<NSArray<UIColor *> *> *items = [NSMutableArray array];
        
        for (NSInteger item = 0; item < self.itemNumber; item ++) {
            NSArray *colors = @[
                                [UIColor whiteColor],
                                [UIColor darkGrayColor]
                                ];
            [items addObject:colors];
        }
        
        [self.dataArr addObject:items];
    }
}

- (void)configCollectionView {
    WaterFallFlowLayout *flowLayout = [[WaterFallFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemPadding = 10;
    flowLayout.numberInRow = 3;
    flowLayout.delegate = self;
    flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[TempCell class] forCellWithReuseIdentifier:TempCellIdentifier];
    [self.collectionView registerClass:[TempSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TempSectionHeaderIdentifier];
    [self.collectionView registerClass:[TempSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TempSectionFooterIdentifier];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.view).offset(-40);
        make.leading.trailing.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr[section].count;
}

- (TempCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TempCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TempCellIdentifier forIndexPath:indexPath];
    
    NSArray<UIColor *> *colors = self.dataArr[indexPath.section][indexPath.item];
    cell.firstColor = colors[0];
    cell.secondColor = colors[1];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TempSectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TempSectionHeaderIdentifier forIndexPath:indexPath];
        view.color = [UIColor blueColor];
        return view;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TempSectionFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TempSectionFooterIdentifier forIndexPath:indexPath];
        view.color = [UIColor greenColor];
        return view;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
}
*/

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.previousSelectedIndexPathArr = [self.lastSelectedIndexPathArr mutableCopy];
    
    if ([self.lastSelectedIndexPathArr containsObject:indexPath]) {
        [self.lastSelectedIndexPathArr removeObject:indexPath];
    } else {
        [self.lastSelectedIndexPathArr addObject:indexPath];
    }
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

#pragma mark - WaterFallFlowLayoutDelegate

- (CGFloat)layout:(WaterFallFlowLayout *)layout previousEdgeLengthForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        return [TempCell cellSizeWithIsSelected:[self.previousSelectedIndexPathArr indexOfObject:indexPath] != NSNotFound offsetY:OffsetY].height;
    }
    
    return 0;
}

- (CGFloat)layout:(WaterFallFlowLayout *)layout lastEdgeLengthForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        return [TempCell cellSizeWithIsSelected:[self.lastSelectedIndexPathArr indexOfObject:indexPath] != NSNotFound offsetY:OffsetY].height;
    }
    
    return 0;
}

@end
