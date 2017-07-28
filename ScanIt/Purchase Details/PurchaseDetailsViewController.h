//
//  PurchaseDetailsViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 20/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseDetailsViewController : UIViewController<UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblProductDesc;

@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblPurchaseDate;

@property (weak, nonatomic) IBOutlet UILabel *lblEcommerceSiteName;

@property (weak, nonatomic) IBOutlet UILabel *lblInvoiceNumber;

@property (weak, nonatomic) IBOutlet STTweetLabel *lblInvoiceLink;

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@property (weak, nonatomic) IBOutlet UIImageView *purchasedProductImgVw;


- (IBAction)backToPurchaseListAction:(id)sender;


@property(strong,nonatomic)NSMutableArray *arrPurchaseHistoryDetails;

@end
