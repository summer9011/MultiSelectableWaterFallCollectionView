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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, WaterFallFlowLayoutDelegate, TempCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WaterFallFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSArray<UIColor *> *> *> *dataArr;
@property (nonatomic, assign) NSUInteger sectionNumber;
@property (nonatomic, assign) NSUInteger itemNumber;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *previousSelectedIndexPathArr;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *lastSelectedIndexPathArr;

@property (nonatomic, strong) UISegmentedControl *numberControl;

@property (nonatomic, assign) WaterFallModeType operationMode;
@property (nonatomic, copy) NSIndexPath *operationIndexPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configDataSource];
    [self configOperationView];
    [self configCollectionView];
    [self resetControl];
}

- (void)configDataSource {
    self.previousSelectedIndexPathArr = [NSMutableArray array];
    self.lastSelectedIndexPathArr = [NSMutableArray array];
    
    self.sectionNumber = 5;
    self.itemNumber = 7;
    
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

- (void)configOperationView {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:toolbar];
    
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    UIBarButtonItem *fixable1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *numberItems = @[
                             @"One",
                             @"Two",
                             @"Three",
                             @"Four"
                             ];
    UISegmentedControl *numberControl = [[UISegmentedControl alloc] initWithItems:numberItems];
    [numberControl addTarget:self action:@selector(numberSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *numberItem = [[UIBarButtonItem alloc] initWithCustomView:numberControl];
    
    UIBarButtonItem *fixable2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[fixable1, numberItem, fixable2];
    
    self.numberControl = numberControl;
}

- (void)configCollectionView {
    self.operationMode = WaterFallModeNone;
    
    WaterFallFlowLayout *flowLayout = [[WaterFallFlowLayout alloc] init];
    flowLayout.itemPadding = 4;
    flowLayout.numberInRow = 2;
    flowLayout.delegate = self;
    flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(50, 0, 50, 0);
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[TempCell class] forCellWithReuseIdentifier:TempCellIdentifier];
    [self.collectionView registerClass:[TempSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TempSectionHeaderIdentifier];
    [self.collectionView registerClass:[TempSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TempSectionFooterIdentifier];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIControl Event

- (void)resetControl {
    WaterFallFlowLayout *layout = (WaterFallFlowLayout *)self.collectionView.collectionViewLayout;
    [self.numberControl setSelectedSegmentIndex:(layout.numberInRow - 1)];
}

- (void)numberSegmentChanged:(UISegmentedControl *)control {
    WaterFallFlowLayout *layout = (WaterFallFlowLayout *)self.collectionView.collectionViewLayout;
    layout.numberInRow = (control.selectedSegmentIndex + 1);
    
    self.operationMode = WaterFallModeReload;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadData];
    } completion:^(BOOL finished) {
        self.operationMode = WaterFallModeNone;
    }];
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
    cell.delegate = self;
    cell.bindVC = self;
    
    NSArray<UIColor *> *colors = self.dataArr[indexPath.section][indexPath.item];
    cell.firstColor = colors[0];
    cell.secondColor = colors[1];
    cell.indexPath = indexPath;
    
    return cell;
}

- (TempSectionView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TempSectionView *view = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TempSectionHeaderIdentifier forIndexPath:indexPath];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TempSectionFooterIdentifier forIndexPath:indexPath];
    }
    view.color = [UIColor colorWithWhite:0.4 alpha:1.f];
    view.indexPath = indexPath;
    
    return view;
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
    
    self.operationMode = WaterFallModeSelect;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    } completion:^(BOOL finished) {
        self.operationMode = WaterFallModeNone;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }];
}

#pragma mark - WaterFallFlowLayoutDelegate

- (WaterFallModeType)layoutOperationMode:(WaterFallFlowLayout *)layout {
    return self.operationMode;
}

- (NSIndexPath *)layoutOperationIndexPath:(WaterFallFlowLayout *)layout {
    return self.operationIndexPath;
}

- (CGFloat)layout:(WaterFallFlowLayout *)layout previousHeightForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    return [TempCell cellSizeWithIsSelected:[self.previousSelectedIndexPathArr indexOfObject:indexPath] != NSNotFound offsetY:OffsetY].height;
}

- (CGFloat)layout:(WaterFallFlowLayout *)layout lastHeightForItemAtIndexPath:(NSIndexPath *)indexPath scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    return [TempCell cellSizeWithIsSelected:[self.lastSelectedIndexPathArr indexOfObject:indexPath] != NSNotFound offsetY:OffsetY].height;
}

#pragma mark - TempCellDelegate

- (void)didCellSelectedInsert:(TempCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    NSArray *colors = @[
                        [UIColor blueColor],
                        [UIColor brownColor]
                        ];
    [self.dataArr[indexPath.section] insertObject:colors atIndex:indexPath.item];
    
    self.operationMode = WaterFallModeInsert;
    self.operationIndexPath = indexPath;
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        self.operationMode = WaterFallModeNone;
        self.operationIndexPath = nil;
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }];
}

- (void)didCellSelectedDelete:(TempCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    [self.dataArr[indexPath.section] removeObjectAtIndex:indexPath.item];
    [self.previousSelectedIndexPathArr removeObject:indexPath];
    [self.lastSelectedIndexPathArr removeObject:indexPath];
    
    self.operationMode = WaterFallModeDelete;
    self.operationIndexPath = indexPath;
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        self.operationMode = WaterFallModeNone;
        self.operationIndexPath = nil;
    }];
}

@end
