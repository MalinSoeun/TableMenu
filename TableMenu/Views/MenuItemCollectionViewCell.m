//
//  MenuItemCollectionViewCell.m
//  TableMenu
//
//  Created by Malin on 2015-08-29.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import "MenuItemCollectionViewCell.h"

@interface MenuItemCollectionViewCell()

@property (weak) IBOutlet UILabel            *lblName;
@property (weak) IBOutlet UILabel            *lblPrice;
@property (weak) IBOutlet UILabel            *lblDesc;
@property (weak) IBOutlet UIImageView        *imageView;
@property (weak) IBOutlet NSLayoutConstraint *constraitHeight;
@property (strong) MenuItem                  *item;
@end

@implementation MenuItemCollectionViewCell

-(void)configureCellWithItem:(MenuItem *)pItem
{
    NSNumberFormatter *lpNumberFormatter;
    CGRect             lRect;
    
    lpNumberFormatter = [[NSNumberFormatter alloc] init];
    
    [lpNumberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    
    lRect = [pItem.shortDesc boundingRectWithSize:CGSizeMake(_lblDesc.frame.size.width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:
                                [UIFont fontWithName:@"Arial-ItalicMT"
                                                size:15.0f]}
                                     context:nil];
    if ( 30 < lRect.size.height )
    {
        _constraitHeight.constant = 47;
    }
    else
    {
        _constraitHeight.constant = 47;
    }

    _item            = pItem;
    _lblName.text    = [pItem.name uppercaseString];
    _lblDesc.text    = pItem.shortDesc;
    _lblPrice.text   = [lpNumberFormatter stringFromNumber:pItem.price];
    _imageView.image =[UIImage imageNamed:pItem.smallImage];
    
}
@end
