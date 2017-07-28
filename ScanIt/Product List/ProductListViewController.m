//
//  ProductListViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 12/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductListCollectionViewCell.h"
#import "ProductDetailsViewController.h"

#define IMAGE_SIZE @"400x400"

@interface ProductListViewController ()
{
    NSMutableArray *arrProductDetails;
    NSMutableDictionary *dictProductDetails;
    int selectedRow;
}

@end

@implementation ProductListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrProductDetails = [[NSMutableArray alloc]init];
    
    [NSThread detachNewThreadSelector:@selector(myThread:) toTarget:self withObject:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ******************** CollectionViewFlowLayout Screen Adjustments *************** //
    
    self.productListCollectionVw.decelerationRate = UIScrollViewDecelerationRateFast;
    float screenRatio = [UIScreen mainScreen].bounds.size.width / 320;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setItemSize:CGSizeMake(95*screenRatio, 182*screenRatio)];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(5*screenRatio, 10*screenRatio, 0, 10*screenRatio);
    flowLayout.minimumInteritemSpacing = 5*screenRatio;
    flowLayout.minimumLineSpacing = 10*screenRatio;
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.productListCollectionVw setCollectionViewLayout:flowLayout];
    
    // ******************************************************************************* //
    
    [self.productListCollectionVw setContentOffset:CGPointZero animated:YES];
    [self.productListCollectionVw reloadData];
}

-(void) myThread:(id) obj
{
  // build up your array
    for (int i = 0; i< _arrFlipkartProductList.count; i++)
    {
        dictProductDetails = [[NSMutableDictionary alloc]init];
        
        [dictProductDetails setObject:[[[[_arrFlipkartProductList objectAtIndex:i] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"title"] forKey:@"title"];
        
        [dictProductDetails setObject:[[[[_arrFlipkartProductList objectAtIndex:i] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"productBrand"] forKey:@"productBrand"];
        
        [dictProductDetails setObject:[[[[_arrFlipkartProductList objectAtIndex:i] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"productDescription"] forKey:@"productDescription"];
        
        [dictProductDetails setObject:[[[[[_arrFlipkartProductList objectAtIndex:i] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"imageUrls"] objectForKey:IMAGE_SIZE] forKey:@"ImageURL"];
        
        [dictProductDetails setObject:[[[[[_arrFlipkartProductList objectAtIndex:i] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"sellingPrice"] objectForKey:@"currency"] forKey:@"currency"];
        
        [dictProductDetails setObject:[[[[[_arrFlipkartProductList objectAtIndex:i] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"sellingPrice"] objectForKey:@"amount"] forKey:@"amount"];
        
        [dictProductDetails setObject:[[[[_arrFlipkartProductList objectAtIndex:i] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"productUrl"] forKey:@"productUrl"];
        
        [arrProductDetails addObject:dictProductDetails];
    }
    
    [self performSelectorOnMainThread:@selector(dataDoneLoading:) withObject:arrProductDetails waitUntilDone:NO];
    
}

-(void) dataDoneLoading:(id) obj
{
    NSMutableArray *array = (NSMutableArray *) obj;
    // update your UI
    NSLog(@"done");
    [self.productListCollectionVw reloadData];
}


#pragma mark - CollectionView Delegates And Data Source Methods 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_arrFlipkartProductList.count > 0)
    {
        _productListCollectionVw.hidden = NO;
        _lblMessage.hidden = YES;
    }
    else
    {
        _productListCollectionVw.hidden = YES;
        _lblMessage.hidden = NO;
    }
    return _arrFlipkartProductList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"productListCell"
                                    forIndexPath:indexPath];

    myCell.contentView.layer.cornerRadius = 2.0f;
    myCell.contentView.layer.borderWidth = 1.0f;
    myCell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    myCell.contentView.layer.masksToBounds = YES;
    
    myCell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    myCell.layer.shadowOffset = CGSizeMake(0, 1.0f);
    myCell.layer.shadowRadius = 0.8f;
    myCell.layer.shadowOpacity = 0.5f;
    myCell.layer.masksToBounds = NO;
    myCell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:myCell.bounds cornerRadius:myCell.contentView.layer.cornerRadius].CGPath;
    
    myCell.lblProductName.text = [[[[_arrFlipkartProductList objectAtIndex:indexPath.row] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"title"];
    
    myCell.productImgVw.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
    
    NSURL *url = [NSURL URLWithString:[[[[[_arrFlipkartProductList objectAtIndex:indexPath.row] objectForKey:@"productBaseInfo"] objectForKey:@"productAttributes"] objectForKey:@"imageUrls"] objectForKey:IMAGE_SIZE]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data scale:0.5];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ProductListCollectionViewCell *myCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    if (myCell)
                    {
                       myCell.productImgVw.image = image;
                    }
                });
            }
        }
    }];
    [task resume];
    
    return myCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrProductDetails.count > 0)
    {
         selectedRow = (int)indexPath.row;
        
        [self performSegueWithIdentifier:@"showProductDetailsFromProductList" sender:nil];
    }
    else
    {
        
    }
}

#pragma mark

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showProductDetailsFromProductList"])
    {
        ProductDetailsViewController* productDetailsVC = [segue destinationViewController];
        NSMutableDictionary *dict = [arrProductDetails objectAtIndex:selectedRow];
        productDetailsVC.arrSelectedProductDetails = [[NSMutableArray alloc]init];
        [productDetailsVC.arrSelectedProductDetails addObject: dict];
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

- (IBAction)backToProductOptionsAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
