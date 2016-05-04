//
//  MenuCategoryButton.m
//  TableMenu
//
//  Created by Malin on 2015-08-29.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import "MenuCategoryButton.h"

@interface MenuCategoryButton()

@property (assign) id<MenuCategoryButtonDelegate> delegate;
@property (strong) MenuCategory                   *category;

@end

@implementation MenuCategoryButton

-(id)initWithCategory:(MenuCategory *)pCategory
                frame:(CGRect)frame
             delegate:(id<MenuCategoryButtonDelegate>)delegate
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        _delegate = delegate;
        _category = pCategory;
        
        [self.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];
        
        [self setTitle:_category.name forState:UIControlStateNormal];
        
        [self setTitleColor:[UIColor colorWithRed:224.0/255
                                            green:113.0/255
                                             blue:1.0/255 alpha:1.0]
                   forState:UIControlStateNormal];
         
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self addTarget:self
                 action:@selector(btnPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)btnPressed:(id)sender
{
    [_delegate buttonPressedForCategory:_category];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if( YES == selected )
    {
        [self setBackgroundColor:[UIColor grayColor]];
        [self setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor colorWithRed:224.0/255
                                            green:113.0/255
                                             blue:1.0/255 alpha:1.0]
                   forState:UIControlStateNormal];
    }
}

@end
