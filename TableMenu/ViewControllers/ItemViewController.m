//
//  ItemViewController.m
//  TableMenu
//
//  Created by Malin on 2015-08-30.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import "ItemViewController.h"
#import "ItemView.h"

@interface ItemViewController ()
@property(weak)IBOutlet  UIScrollView       *scrollView;
@property(weak)IBOutlet  UIButton           *btnDone;
@property(weak)IBOutlet  UIButton           *btnNext;
@property(weak)IBOutlet  UIButton           *btnPrev;
@property(weak) IBOutlet NSLayoutConstraint *constraintHeight;
@property(weak) IBOutlet NSLayoutConstraint *constraintWidth;
@property(strong) NSMutableArray            *itemViewList;
@property(assign) BOOL                      needResize;
@end

@implementation ItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _btnDone.layer.borderColor = [UIColor whiteColor].CGColor;

    [self hideButtons:YES];
    
    _needResize = YES;
    
    [self addTapEvent];
    
    [self setupData];
    
}

-(void)viewDidLayoutSubviews
{
    if ( YES == _needResize )
    {
        [self setScrollView:_scrollView.frame.size.width height:_scrollView.frame.size.height];
    }
    
    _needResize = NO;
}
-(void)hideButtons:(BOOL)hide
{
    _btnDone.hidden = hide;
    _btnNext.hidden = hide;
    _btnPrev.hidden = hide;
}
-(void)setupData
{
    MenuItem   *lpItem;
    NSInteger   index;
    NSMutableArray  *lpItems;
    
    lpItems = _items.mutableCopy;
    
    [lpItems insertObject:[_items objectAtIndex:_items.count-1] atIndex:0];
    
    [lpItems addObject:[_items objectAtIndex:0]];
    
    _items = lpItems;
    
    _currentIndex = _currentIndex + 1;
    
    lpItem = [_items objectAtIndex:_currentIndex];
    
    _itemViewList = @[].mutableCopy;
    
    for ( index=0; index < [_items count]; index++ )
    {
        [_itemViewList addObject:[NSNull null]];
    }
    
    [self currentPageIndexDidChange];
    
}

- (void)currentPageIndexDidChange
{
    UIView      *lpPage     = nil;
    
    // layout current image view
    [self layoutPage:_currentIndex output:&lpPage];
    
    // layout next image view
    if (_currentIndex+1 < [_items count] )
    {
        [self layoutPage:_currentIndex+1 output:&lpPage];
        
    }else{
        [self layoutPage:0 output:&lpPage];
    }
    
    // layout previous image view
    if (_currentIndex > 0)
    {
        [self layoutPage:_currentIndex-1 output:&lpPage];
    }else
    {
        [self layoutPage:_items.count-1 output:&lpPage];
    }
}

- (void)layoutPage:(NSUInteger)pageIndex output:(UIView ** )pageView
{
    UIView          *lPageView = nil;
    CGSize          lSize ;
    CGRect          lRect;
    
    // get image view size
    lSize = [self pageSize];
    
    // get image view at page index
    [self viewForPage:pageIndex output:&lPageView];
    
    if ( nil != lPageView)
    {
        // resize image view
        lRect.origin.x    = (pageIndex * lSize.width);
        lRect.origin.y    = 0;
        lRect.size.width  = lSize.width ;
        lRect.size.height = lSize.height;
        lPageView.frame = lRect;
        
        *pageView = lPageView;
    }
}

- (void)viewForPage:(NSUInteger)pageIndex output:( UIView **)pPageView
{
    
    ItemView  *lpPageView = nil;
    
    // check array at page index
    if ([NSNull null] == [_itemViewList objectAtIndex:pageIndex])
    {
        // add image view to array at page index
        [self addItemView:pageIndex output:&lpPageView];
        
    }
    else
    {
        // get image view frame array by index
        lpPageView = [_itemViewList objectAtIndex:pageIndex];
        
    }
    
    // assign value to output parameter
    *pPageView = lpPageView;
}

-(void) addItemView: (NSUInteger) index output: (UIView **)pageView
{
    ItemView       *lpPage;
    NSUInteger      lCount = 0;
    CGSize          lSize;
    CGRect          lRect;
    
    // check input parameter
    if ( [_itemViewList count] <= index )
    {
        return;
    }
    
    // get page view size
    lSize = [self pageSize];
    
    // create size of page view
    lRect.origin.x = (index * lSize.width);
    
    lRect.origin.y    = 0;
    lRect.size.width  = lSize.width;
    lRect.size.height = lSize.height;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"item"
                                                 owner:self options:nil];
    
    // create new image view with specify size
    lpPage = [nib objectAtIndex:0];
    
    if ( nil == lpPage )
    {
        return;
    }
    
    lpPage.frame = lRect;
    
    [lpPage setupViewWithItem:[_items objectAtIndex:index]];
    
    // get number of page view in array
    lCount = [_itemViewList count];
    
    // add page view to array
    [_itemViewList replaceObjectAtIndex:index withObject:lpPage];
    
    // add page view to scroll view
    [_scrollView addSubview:lpPage];
    
    //lSize = self.view.frame.size;
    
    // set scroll view content size
    _scrollView.contentSize = CGSizeMake(lCount * lSize.width,lSize.height);
    
    *pageView = [_itemViewList objectAtIndex:index];

}

-(void)moveToIndex :(NSUInteger) index animation :(BOOL) status
{
    CGRect      lRect;
    CGSize      lSize;
    
    // check input parameter
    if ( [_itemViewList count] <= index )
    {
        return;
    }
    
    // get size of page view
    lSize = [self pageSize];
    
    lRect.origin.x = index * lSize.width  ;
    lRect.origin.y = 0;
    lRect.size.width = lSize.width ;
    lRect.size.height = lSize.height;
    
    // set current page of image view index
    _currentIndex = index;
    
    // layout the page views
    [self currentPageIndexDidChange];
    
    // move scroll view to specific rectangle
    [_scrollView scrollRectToVisible:lRect animated:status];
    
}

-(CGSize) pageSize
{
    CGSize  lSize;
    
    // get size of scroll view
    lSize = _scrollView.frame.size;
    
    // return size of the page
    return ( lSize );
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGSize          lPageSize;
    NSUInteger      lNewPageIndex;
    float           lContentOffset = 0;
    
    // get image view size
    lPageSize    = [self pageSize];
    
    // get content offset of the scroll view
    lContentOffset = scrollView.contentOffset.x;
    
    // calculate new scroll view index
    lNewPageIndex = (lContentOffset + (lPageSize.width / 2)) / lPageSize.width;
    
    if ( [_itemViewList count]-1 <= lNewPageIndex )
    {
        return;
    }
    
    // check whether user scroll to next page
    if ( _currentIndex != lNewPageIndex)
    {
        // set current page index of image view
        _currentIndex = lNewPageIndex;
        
        // layout scroll view
        [self currentPageIndexDidChange];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGSize  lSize;
    CGRect  lRect;
    
    lSize = [self pageSize];
    
    if ( 0 == scrollView.contentOffset.x )
    {
        // user is scrolling to the left from image 1 to image 10.
        // reposition offset to show image 10 that is on the right in the scroll view
        _currentIndex = _items.count - 1;
        
        [self currentPageIndexDidChange];
        
        lRect = CGRectMake(lSize.width * (_itemViewList.count-2) ,0,
                           lSize.width,lSize.height);
        
        [scrollView scrollRectToVisible:lRect
                               animated:NO];
    }
    else if (lSize.width * (_itemViewList.count-1) == scrollView.contentOffset.x)
    {
        // user is scrolling to the right from image 10 to image 1.
        // reposition offset to show image 1 that is on the left in the scroll view
        
        _currentIndex = 0;
        
        [self currentPageIndexDidChange];
        
        lRect = CGRectMake(lSize.width,0,lSize.width,lSize.height);
        
        [scrollView scrollRectToVisible:lRect
                               animated:NO];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGSize  lSize;
    CGRect  lRect;
    
    lSize = [self pageSize];
    
    if ( 0 == scrollView.contentOffset.x )
    {
        // user is scrolling to the left from image 1 to image 10.
        // reposition offset to show image 10 that is on the right in the scroll view
        _currentIndex = _items.count - 1;
        
        [self currentPageIndexDidChange];
        
        lRect = CGRectMake(lSize.width * (_itemViewList.count-2) ,0,
                           lSize.width,lSize.height);
        
        [scrollView scrollRectToVisible:lRect
                               animated:NO];
    }
    else if (lSize.width * (_itemViewList.count-1) == scrollView.contentOffset.x)
    {
        // user is scrolling to the right from image 10 to image 1.
        // reposition offset to show image 1 that is on the left in the scroll view
        
        _currentIndex = 0;
        
        [self currentPageIndexDidChange];
        
        lRect = CGRectMake(lSize.width,0,lSize.width,lSize.height);
        
        [scrollView scrollRectToVisible:lRect
                               animated:NO];
    }
    
}
-(void)setScrollView:(float)width height:(float)height
{
    NSUInteger      lCount  = 0;
    NSUInteger      lIndex  = 0;
    CGRect          lRect   = CGRectZero;
    CGSize          lSize   = CGSizeZero;
    UIView         *lpView  = NULL;
    
    // check input parameter
    if ( (0 > width ) || ( 0 > height ) )
    {
        return;
    }
    
    // get array count
    lCount = [_itemViewList count];
    
    lSize = CGSizeMake(width, height);
    
    // resize scroll view
    //_scrollView.frame = CGRectMake(0, 0, lSize.width, lSize.height);
    
    // set scroll view content size
    _scrollView.contentSize = CGSizeMake( lCount* lSize.width,
                                              lSize.height);
    
    // resize all image view in array
    for ( lIndex = 0; lIndex < lCount; lIndex ++)
    {
        lRect = CGRectMake(lIndex * lSize.width ,0 ,
                           lSize.width  , lSize.height);
        
        if ( [NSNull null] != [_itemViewList objectAtIndex:lIndex])
        {
            lpView = [_itemViewList objectAtIndex:lIndex];
            lpView.frame = lRect;
        }
        
    }
    
    lRect = _scrollView.frame;
    
    lRect.origin.x = _currentIndex * lRect.size.width;
    lRect.origin.y = 0;
    
    // scroll scroll-view to specific rectangle
    [_scrollView scrollRectToVisible:lRect animated:NO];
}


#pragma mark - Action Methods

-(void)addTapEvent
{
    UITapGestureRecognizer *lpTapGesture;
    
    lpTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(screenTapped:)];
    
    [self.view addGestureRecognizer:lpTapGesture];
    
}

-(IBAction)btnDonePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnNextPressed:(id)sender
{
    if ( _currentIndex >= _items.count - 1 )
    {
        return;
    }
    _currentIndex = _currentIndex + 1;
    
    [self moveToIndex:_currentIndex animation:YES];
    
}

-(IBAction)btnPreviousPressed:(id)sender
{
    if ( _currentIndex <= 0 )
    {
        return;
    }
    
    _currentIndex = _currentIndex - 1;
    
    [self moveToIndex:_currentIndex animation:YES];
}

-(void)screenTapped:(UITapGestureRecognizer *)gesture
{
    if ( YES == _btnDone.hidden )
    {
        [self hideButtons:NO];
    }
    else
    {
        [self hideButtons:YES];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _needResize = YES;
}

@end
