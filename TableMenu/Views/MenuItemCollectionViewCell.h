//
//  MenuItemCollectionViewCell.h
//  TableMenu
//
//  Created by Malin on 2015-08-29.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MenuItemCollectionViewCell : UICollectionViewCell

-(void)configureCellWithItem:(MenuItem *)item;

@end
