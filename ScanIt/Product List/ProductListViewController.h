//
//  ProductListViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 12/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *productListCollectionVw;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

- (IBAction)backToProductOptionsAction:(id)sender;



@property(nonatomic,strong)NSMutableArray *arrFlipkartProductList;

@end
