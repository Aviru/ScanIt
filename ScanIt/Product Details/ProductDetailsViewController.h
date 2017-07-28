//
//  ProductDetailsViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 12/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailsViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectedProductImgVw;

@property (weak, nonatomic) IBOutlet UILabel *lblSelectedProductName;

@property (weak, nonatomic) IBOutlet UILabel *lblBrandName;

@property (weak, nonatomic) IBOutlet UILabel *lblProductDesc;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollVw;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblNamePrice;


@property (weak, nonatomic) IBOutlet UIButton *purchaseBtnOutlet;


- (IBAction)backToProductListAction:(id)sender;

- (IBAction)purchaseAction:(id)sender;


@property(nonatomic,strong)NSMutableArray *arrSelectedProductDetails;

@end
