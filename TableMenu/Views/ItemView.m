//
//  ItemView.m
//  TableMenu
//
//  Created by Malin on 2015-09-14.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import "ItemView.h"

@interface ItemView()
@property(weak)IBOutlet  UILabel            *lblTitle;
@property(weak)IBOutlet  UILabel            *lblDesc;
@property(weak)IBOutlet  UILabel            *lblPrice;
@property(weak)IBOutlet  UIImageView        *imageView;
@property(weak) IBOutlet NSLayoutConstraint *constraitHeight;
@property(weak) IBOutlet NSLayoutConstraint *constraintTop;
@property(weak) IBOutlet NSLayoutConstraint *constraintLeading;
@end

@implementation ItemView

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    
    return self;
}

-(void)setupViewWithItem:(MenuItem *)pItem
{
    CGRect              lRect;
    NSNumberFormatter   *lpNumberFormatter;
    
    lpNumberFormatter = [[NSNumberFormatter alloc] init];
    
    [lpNumberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    

    lRect = [pItem.desc boundingRectWithSize:CGSizeMake(_lblDesc.frame.size.width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:
                                        [UIFont fontWithName:@"Avenir-Medium"
                                                        size:19.0f]}
                                     context:nil];
    
    _constraitHeight.constant = lRect.size.height + 10;
    
    _lblTitle.text   = [pItem.name uppercaseString];
    _lblDesc.text    = pItem.desc;
    _lblPrice.text   = [lpNumberFormatter stringFromNumber:pItem.price];
    _imageView.image = [UIImage imageNamed:pItem.largeImage];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect      lRect;
    CGFloat     lTop   = 0;
    CGFloat     lLeft  = 0;
    CGFloat     lScreenRatio;
    CGFloat     lImageRatio;
    CGSize      lSize;
    
    lRect        = _imageView.frame;
    
    lScreenRatio = _imageView.frame.size.width / _imageView.frame.size.height;
    
    lImageRatio = _imageView.image.size.width / _imageView.image.size.height;
    
    if ( lScreenRatio > lImageRatio )
    {
        lSize.width = _imageView.image.size.width *
                    (_imageView.frame.size.height/_imageView.image.size.height);
        lSize.height = _imageView.frame.size.height;
    }
    else
    {
        lSize.width = _imageView.frame.size.width;
        lSize.height= _imageView.image.size.height *
                      (_imageView.frame.size.width/_imageView.image.size.width);
    }
    
    lTop = (lRect.size.height - lSize.height)/2 + 20;
    
    if ( lRect.size.height == lSize.height )
    {
        lTop = 20;
    }
    
    lLeft = 20 + (lRect.size.width - lSize.width)/2;
    
    _constraintLeading.constant = lLeft;

    _constraintTop.constant = lTop;
    
}

@end
