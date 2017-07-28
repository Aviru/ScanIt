//
//  ProductOptionsViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductOptionsViewController : superViewController<NSURLConnectionDelegate,NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImgVw;

@property (weak, nonatomic) IBOutlet UILabel *lblProductDesc;

@property (weak, nonatomic) IBOutlet UIButton *likeBtnOutlet;

@property (weak, nonatomic) IBOutlet UIButton *showRetailersListBtnOutlet;

@property (weak, nonatomic) IBOutlet UILabel *lblLikeProduct;

@property(strong,nonatomic)UIImage *productImage;



- (IBAction)backToHomeAction:(id)sender;

- (IBAction)likeAction:(id)sender;

- (IBAction)showRetailersListAction:(id)sender;

- (IBAction)flipKartAffiliatesAction:(id)sender;

- (IBAction)amazonAffiliatesAction:(id)sender;


@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productImageUrl;
@property(nonatomic,strong)NSString *queryTokenForSelectedProduct;

@end
