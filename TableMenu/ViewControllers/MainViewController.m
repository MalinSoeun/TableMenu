//
//  MainViewController.m
//  TableMenu
//
//  Created by Malin on 2015-08-29.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import "MainViewController.h"
#import "MenuItemCollectionViewCell.h"
#import "ItemViewController.h"

@interface MainViewController ()

@property (weak) IBOutlet UIScrollView     *scrollView;
@property (weak) IBOutlet UICollectionView *collectionView;

@property (strong) NSArray                 *categories;
@property (strong) NSArray                 *items;
@property (strong) MenuCategory            *selectedCategory;
@property (assign) NSInteger               seletedItemIndex;
@property (strong) UIPopoverController     *activePopover;
@property (assign) CGSize                  itemSize;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPlists];
    
    [self setupCategories];
}

- (void)setupPlists
{
    NSArray         *lpPaths ;
    NSString        *lpDocumentsDirectory;
    NSString        *lpHeaderPlistPath;
    NSArray         *lpHeaders;
    NSString        *lpHeader;
    NSFileManager   *lpFileManager;
    NSString        *lpPath;
    NSString        *lpBundlePlistPath;
    NSArray         *lpContents;
    
    // get document directory path
    lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    lpDocumentsDirectory = [lpPaths objectAtIndex:0];
    
    // get menu plist path
    lpHeaderPlistPath = [[NSBundle mainBundle] pathForResource:@"MenuHeaders"
                                                        ofType:@"plist"];
    // get content of plist file
    lpHeaders = [NSArray arrayWithContentsOfFile:lpHeaderPlistPath];
    
    // get file manager object
    lpFileManager = [NSFileManager defaultManager];
    
    for ( lpHeader in lpHeaders)
    {
        // set plist path
        lpPath = [lpDocumentsDirectory stringByAppendingString:
                  [NSString stringWithFormat:@"/%@.plist", lpHeader]];
        
        // check if file not exist
        if ( YES != [lpFileManager fileExistsAtPath:lpPath])
        {
            // get path of plist file in main bundle
            lpBundlePlistPath = [[NSBundle mainBundle] pathForResource:lpHeader
                                                                ofType:@"plist"];
            // get content of plist file
            lpContents = [NSArray arrayWithContentsOfFile:lpBundlePlistPath];
            
            // write data to file
            if ( YES != [lpContents writeToFile:lpPath atomically:YES])
            {
                NSLog(@"File write failed.");
            }
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ( YES ==UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        _itemSize = CGSizeMake(180, 210);
    }
    else
    {
        _itemSize = CGSizeMake(225, 240);
    }
    [_collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark UIRotation

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if( YES == UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        _itemSize = CGSizeMake(180, 210);
    }
    else
    {
        _itemSize = CGSizeMake(225, 240);
    }

    [_collectionView.collectionViewLayout invalidateLayout];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_collectionView reloadData];
}

-(void)setupCategories
{
    NSString        *lpPlistPath;
    NSArray         *lpCategories;
    MenuCategory    *lpCategory;
    NSInteger        index = 0;
    NSMutableArray  *lpTempCategories;
    
    
    // get path of plist file
    lpPlistPath = [[NSBundle mainBundle] pathForResource:@"MenuHeaders"
                                                  ofType:@"plist"];
    
    // get menu content form plist file
    lpCategories = [NSArray arrayWithContentsOfFile:lpPlistPath];
    
    lpTempCategories = @[].mutableCopy;
    
    for (index = 0; index < lpCategories.count; index++)
    {
        lpCategory = [[MenuCategory alloc] init];
        
        [lpCategory setName:[lpCategories objectAtIndex:index]];
        
        [lpTempCategories addObject:lpCategory];
    }
    
    _categories = lpTempCategories;
    
    [self layoutCategoryButtons];
}

-(void)setupItems
{
    NSArray         *lpPaths;
    NSString        *lpDocumentsDirectory;
    NSString        *lpPlistPath;
    NSArray         *lpItems;
    NSMutableArray  *lpTempItems;
    NSInteger        index  = 0;
    MenuItem        *lpItem;
    NSDictionary    *lpDictItem;
    
    // get document directory path
    lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                  NSUserDomainMask, YES);
    
    lpDocumentsDirectory = [lpPaths objectAtIndex:0];
    
    // get path of plist file
    lpPlistPath = [lpDocumentsDirectory stringByAppendingString:
                   [NSString stringWithFormat:@"/%@.plist",_selectedCategory.name]];
    
    // get content of plist file
    lpItems = [NSArray arrayWithContentsOfFile:lpPlistPath];
    
    lpTempItems = @[].mutableCopy;
    
    for (index = 0; index < lpItems.count; index++)
    {
        lpDictItem = [lpItems objectAtIndex:index];
        
        lpItem = [[MenuItem alloc] init];
        
        [lpItem setIdentifier:[NSNumber numberWithInteger:
                               [[lpDictItem objectForKey:@"Id"] integerValue]]];
        [lpItem setName:[lpDictItem objectForKey:@"Name"]];
        [lpItem setShortDesc:[lpDictItem objectForKey:@"ShortDescription"]];
        [lpItem setDesc:[lpDictItem objectForKey:@"Description"]];
        [lpItem setPrice:[NSDecimalNumber decimalNumberWithDecimal:
                          [[lpDictItem objectForKey:@"Price"] decimalValue]]];

        
        [lpItem setSmallImage:[lpDictItem objectForKey:@"Thumbnail"]];
        [lpItem setLargeImage:[lpDictItem objectForKey:@"Image"]];
        
        [lpTempItems addObject:lpItem];
    }
    
    _items = lpTempItems;
    
    [_collectionView reloadData];
}

-(void)layoutCategoryButtons
{
    __block MenuCategoryButton *lpEmptyButton;
    __block NSInteger           x = 25;
    
    lpEmptyButton = [[MenuCategoryButton alloc] initWithCategory:nil
                                                           frame:CGRectMake(0, 0, 100, 100)
                                                        delegate:nil];
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop)
    {
        [view removeFromSuperview];
    }];
    
    [_categories enumerateObjectsUsingBlock:^(MenuCategory *lpCategory, NSUInteger idx, BOOL *stop)
    {
        MenuCategoryButton *lpButton;
        CGRect              lRect;
        
        lRect = [lpCategory.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:
                                                          lpEmptyButton.titleLabel.font}
                                                  context:nil];
        
        lRect = CGRectMake(x, 0, lRect.size.width + 28, 50);
        
        lpButton = [[MenuCategoryButton alloc] initWithCategory:lpCategory
                                                          frame:lRect
                                                       delegate:self];
        [_scrollView addSubview:lpButton];
        
        x += lRect.size.width;
    }];
    
    [_scrollView setContentSize:CGSizeMake(x, _scrollView.frame.size.height)];
    
    [self buttonPressedForCategory:[_categories firstObject]];
    
    [self setupItems];
}


#pragma mark - MenuCategoryButtonDelegate Methods

-(void)buttonPressedForCategory:(MenuCategory *)pCategory
{
    _selectedCategory = pCategory;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop)
     {
        if( YES == [view isKindOfClass:[MenuCategoryButton class]])
        {
            if( YES != [[(MenuCategoryButton *)view category] isEqual:pCategory])
            {
                [(MenuCategoryButton *)view setSelected:NO];
            }
            else
            {
                [(MenuCategoryButton *)view setSelected:YES];
            }
        }
    }];
    
    [self setupItems];
}

#pragma mark - UICollectionView Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_items count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCollectionViewCell *lpCell;
    
    lpCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuItemCollectionCell"
                                                       forIndexPath:indexPath];
    
    lpCell.layer.shouldRasterize = YES;
    lpCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [lpCell configureCellWithItem:_items[indexPath.row]];
    
    return lpCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize    lSize;
    
    lSize = _itemSize;
    
    return lSize;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    return layoutAttributes;
}

#pragma mark - UICollectionView Delegate Methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _seletedItemIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"ToDetailVC" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ToDetailVC"])
    {
        ItemViewController *lpItemVC;
        
        lpItemVC       = segue.destinationViewController;
        lpItemVC.items = _items;
        lpItemVC.currentIndex = _seletedItemIndex;
    }
}

@end
