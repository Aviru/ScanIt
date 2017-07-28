//
//  PurchaseDetailsViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 20/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "PurchaseDetailsViewController.h"
#import "PurchaseInvoiceViewController.h"

@interface PurchaseDetailsViewController ()
{
     NSString *urlToHit;
}

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end

@implementation PurchaseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _lblProductName.text = [[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:@"product_name"];
    _lblProductDesc.text = [[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:@"product_description"];
    _lblProductPrice.text = [[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:@"price"];
    _lblPurchaseDate.text = [[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:@"Purchase Date"];
    _lblEcommerceSiteName.text = [[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:@"Ecommerce"];
    _lblInvoiceNumber.text = [[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:@"invoice_number"];
    _lblInvoiceLink.text = [[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:@"Pdf Link"];
    NSURL *url = [NSURL URLWithString:[[_arrPurchaseHistoryDetails objectAtIndex:0] objectForKey:PROFILEIMAGE]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data scale:0.5];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                        _purchasedProductImgVw.image = image;
                });
            }
        }
    }];
    [task resume];
    
    __weak typeof(self) weakSelf = self;
    
    _lblInvoiceLink.detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        
        if([string containsString:@"http"] || [string containsString:@"https"])
        {
            string = [string substringFromIndex:0];
            urlToHit = string;
            
            [weakSelf performSelector:@selector(visitUrlFromPurchaseDetails) withObject:nil];
            
        }
    };
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Visit the link

- (void)visitUrlFromPurchaseDetails
{
    [self performSegueWithIdentifier:@"showPurchaseInvoiceFromPurchaseDetails" sender:nil];
    
   // [webview loadData:PdfContent MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];

}

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPurchaseInvoiceFromPurchaseDetails"])
    {
        PurchaseInvoiceViewController* purchaseInvoiceVC = [segue destinationViewController];
        purchaseInvoiceVC.URL = urlToHit;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backToPurchaseListAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
