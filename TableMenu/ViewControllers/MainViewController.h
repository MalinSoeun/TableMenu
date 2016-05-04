//
//  MainViewController.h
//  TableMenu
//
//  Created by Malin on 2015-08-29.
//  Copyright (c) 2015 Malin Soeun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCategoryButton.h"
#import "ItemViewController.h"


@interface MainViewController : UIViewController< MenuCategoryButtonDelegate,
UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate,
UIAlertViewDelegate,UICollectionViewDelegateFlowLayout>
{
   
    
}


@end
