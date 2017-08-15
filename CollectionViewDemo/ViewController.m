//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by 赵立波 on 2017/8/11.
//  Copyright © 2017年 赵立波. All rights reserved.
//

#import "ViewController.h"
#import "TempFlowLayout.h"
#import "TempCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, TempFlowDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TempFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray<NSArray<UIColor *> *> *dataArr;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *prevSelectedIndexPathArr;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *currentSelectedIndexPathArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:1.f];
    
    self.prevSelectedIndexPathArr = [NSMutableArray array];
    self.currentSelectedIndexPathArr = [NSMutableArray array];
    
    self.dataArr = @[
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ],
                     @[
                         [UIColor whiteColor],
                         [UIColor darkGrayColor]
                         ]
                     ];
    
    TempFlowLayout *flowLayout = [[TempFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[TempCell class] forCellWithReuseIdentifier:TempCellIdentifier];
    
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (TempCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TempCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TempCellIdentifier forIndexPath:indexPath];
    
    NSArray<UIColor *> *colors = self.dataArr[indexPath.item];
    cell.firstColor = colors[0];
    cell.secondColor = colors[1];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.prevSelectedIndexPathArr = [self.currentSelectedIndexPathArr mutableCopy];
    
    if ([self.currentSelectedIndexPathArr containsObject:indexPath]) {
        [self.currentSelectedIndexPathArr removeObject:indexPath];
    } else {
        [self.currentSelectedIndexPathArr addObject:indexPath];
    }
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [TempCell cellSizeWithIsSelected:[self.currentSelectedIndexPathArr indexOfObject:indexPath] != NSNotFound offsetY:OffsetY];
}

#pragma mark - TempFlowDelegate

- (NSArray<NSIndexPath *> *)indexPathsWithIsCurrent:(BOOL)isCurrent {
    return isCurrent ? self.currentSelectedIndexPathArr:self.prevSelectedIndexPathArr;
}

@end
