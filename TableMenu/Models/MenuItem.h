//
//  MenuItem.h
//  TableMenu
//
//  Created by Malin on 2015-08-29.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property(strong)NSNumber  *identifier;
@property(strong)NSString  *name;
@property(strong)NSString  *desc;
@property(strong)NSString  *shortDesc;
@property(strong)NSNumber  *price;
@property(strong)NSString  *smallImage;
@property(strong)NSString  *largeImage;

@end
