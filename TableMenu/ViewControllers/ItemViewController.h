//
//  ItemViewController.h
//  TableMenu
//
//  Created by Malin on 2015-08-30.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface ItemViewController : UIViewController<UIScrollViewDelegate>
{
    
}

@property(strong)NSArray  *items;
@property(assign)NSInteger currentIndex;

@end
