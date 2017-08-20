# MultiSelectableWaterFallCollectionView

## What's that?
  This demo is a custom waterfall layout, support multiple selection, support insert/delete one item in a section, animation during selection process, and also support to display supplementary view.
  Only support scroll in vertical direction.
#### The demo help you to understand clearly when using waterfall layout.
  
## How to integrate it?
  Download or git clone it, add <code>WaterFallFlowLayout.h</code> and <code>WaterFallFlowLayout.m</code> files into your project.
  
## How to use it?
  1. Init the waterfall layout using <code>[[WaterFallFlowLayout alloc] init]</code>.
  2. Set item padding using properties <code>itemPadding</code>, default value is <code>0</code>.
  3. Set the count in a row using properties <code>numberInRow</code>, default value is <code>1</code>.
  4. Set delegate using properties <code>delegate</code> to bind layout data source, the delegate is required.
  5. Set the <code>headerReferenceSize</code> or <code>footerReferenceSize</code> if section header or footer is necessary, 
  also can using <code>- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;</code> or <code>- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;</code>
  to make them dynamic.
  6. Implement delegate's methods, return important result.
  
## Details.
  You can see more details in the demo project. Good luck.
