//
//  SuggestedRetailerDetailsViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 13/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "SuggestedRetailerDetailsViewController.h"
#import "SuggestedRetailerWebSiteViewController.h"
#import "CurrentOfferCollectionViewCell.h"

@interface SuggestedRetailerDetailsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *urlToHit;
    NSString *imgUrl;
    
    NSMutableArray *arrDictImages;
    
    NSMutableArray *arrImages;
    
    IBOutlet UILabel *lblOffer;
    
    IBOutlet UICollectionView *currentOffersCollectionView;
    
}

@end

@implementation SuggestedRetailerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrDictImages = [[NSMutableArray alloc]init];
    arrImages = [[NSMutableArray alloc]init];
    
    
    // ******************** CollectionViewFlowLayout Screen Adjustments *************** //
    
    currentOffersCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    float screenRatio = [UIScreen mainScreen].bounds.size.width / 320;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setItemSize:CGSizeMake(88*screenRatio, 88*screenRatio)];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(5*screenRatio, 10*screenRatio, 0, 10*screenRatio);
    flowLayout.minimumInteritemSpacing = 5*screenRatio;
    flowLayout.minimumLineSpacing = 10*screenRatio;
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [currentOffersCollectionView setCollectionViewLayout:flowLayout];
    
    _lblShopName.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_name"];
    
    _lblShopAddress.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_address"];
    
    _lblContact.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_phone_number"];
    
    _lblTimings.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_timings"];
    
    _lblWebSite.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"website"];
    
    if ([[[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_offer"] length] > 0) {
        
        lblOffer.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_offer"];
    }
    else
        lblOffer.text = @"No Offer available currently";
    
    if ([[[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_images"] count] > 0) {
        
        arrDictImages = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_images"];
        
        imgUrl = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"image_path"];
        
//        for (int i = 0; i< arrDictImages.count; i++)
//        {
//            
//            NSString *imageURL = [imgUrl stringByAppendingString:[[arrDictImages objectAtIndex:i] objectForKey:@"image"]];
//            
//            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                if (data) {
//                    UIImage *image = [UIImage imageWithData:data scale:0.5];
//                    if (image) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                            [arrImages addObject:image];
//                            
//                            if (arrImages.count == arrDictImages.count) {
//                                [currentOffersCollectionView reloadData];
//                            }
//                        });
//                    }
//                }
//            }];
//            [task resume];
//        }
    }
    
    NSLog(@"arrDictImages:%@",arrDictImages);
    
    
    __weak typeof(self) weakSelf = self;
    
    _lblWebSite.detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        
        if([string containsString:@"http"] || [string containsString:@"https"])
        {
            string = [string substringFromIndex:0];
            urlToHit = string;
            
            [weakSelf performSelector:@selector(visitUrlFromSuggestedRetailerDetails) withObject:nil];
            
        }
    };
}



#pragma mark - CollectionView Delegates And Data Source Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (arrDictImages.count > 0)
    {
        currentOffersCollectionView.hidden = NO;
    }
    else
    {
        currentOffersCollectionView.hidden = YES;
    }
    return arrDictImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CurrentOfferCollectionViewCell *myCell = [collectionView
                                             dequeueReusableCellWithReuseIdentifier:@"offerCell"
                                             forIndexPath:indexPath];
    
    [myCell.activityIndicator startAnimating];
    
    if (arrImages.count == arrDictImages.count) {
        
        myCell.offerImgView.image = [arrImages objectAtIndex:indexPath.row];
    }
    else
    {
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[imgUrl stringByAppendingString:[[arrDictImages objectAtIndex:indexPath.row] objectForKey:@"image"]]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data scale:0.2];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CurrentOfferCollectionViewCell *myCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                        if (myCell)
                        {
                            if (myCell.tag == indexPath.row) {
                                
                                myCell.offerImgView.image = image;
                                
                                [arrImages addObject:image];
                                
                                myCell.activityIndicator.hidden = YES;
                                
                                [myCell.activityIndicator stopAnimating];
                            }
                        }
                    });
                }
            }
        }];
        [task resume];
    }

    
        /*
        [WebImageOperations processImageDataWithURLString:[imgUrl stringByAppendingString:[[arrDictImages objectAtIndex:indexPath.row] objectForKey:@"image"]] andBlock:^(NSData *imageData) {
            if (self.view.window) {
                UIImage *image = [UIImage imageWithData:imageData];
                
                myCell.offerImgView.image = image;
                
            }
            
        }];
         */

    
   // myCell.offerImgView.image = [arrImages objectAtIndex:indexPath.row];
    
    return myCell;
}
#pragma mark

#pragma mark - Visit the link

- (void)visitUrlFromSuggestedRetailerDetails
{
    [self performSegueWithIdentifier:@"showRetailerWebsiteFromRetailerDetails" sender:nil];
}

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showRetailerWebsiteFromRetailerDetails"])
    {
        SuggestedRetailerWebSiteViewController* retailerWebVC = [segue destinationViewController];
        retailerWebVC.URL = urlToHit;
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

#pragma mark - Button Action

- (IBAction)backToSuggestedRetailers:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callUsAction:(id)sender
{
    NSURL *phoneUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:[[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_phone_number"]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
@end
