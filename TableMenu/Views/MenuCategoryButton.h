//
//  MenuCategoryButton.h
//  TableMenu
//
//  Created by Malin on 2015-08-29.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCategory.h"

@protocol MenuCategoryButtonDelegate;

@interface MenuCategoryButton : UIButton

@property (readonly) MenuCategory *category;

-(id)initWithCategory:(MenuCategory *)category
                frame:(CGRect)frame
             delegate:(id<MenuCategoryButtonDelegate>)delegate;
@end

@protocol MenuCategoryButtonDelegate <NSObject>

-(void)buttonPressedForCategory:(MenuCategory *)category;

@end
