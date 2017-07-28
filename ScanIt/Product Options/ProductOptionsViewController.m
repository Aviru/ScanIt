//
//  ProductOptionsViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "ProductOptionsViewController.h"
#import "SuggestedRetailersListViewController.h"
#import "ProductListViewController.h"
#import "AmazonProductListingViewController.h"

#define AWSAccessKeyId @"AKIAJVWIIQX5M3HVKIYQ"

#define AWSSecretKey @"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"

#define AssociateTag @"wwwscanitappl-21"

#define Service @"AWSECommerceService"

#define Version @"2011-08-01"

#define Operation @"ItemSearch"

#define SearchIndex @"All"

@interface ProductOptionsViewController ()
{
    NSMutableData * responseData;
    NSMutableArray *arrProductInfoList;
    BOOL isLike;
    AppDelegate *appDelegate;
    NSXMLParser *xmlParser;
    BOOL isElementPresent;
    NSMutableString *amazonAssociatesURL;
}

@end

@implementation ProductOptionsViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showRetailersListBtnOutlet.layer.cornerRadius = 3.0f;
    
    isLike = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    amazonAssociatesURL = [[NSMutableString alloc]init];
    
    if (appDelegate.isFromLikePage)
    {
//         appDelegate.isFromLikePage = NO;
        _likeBtnOutlet.hidden = NO;
        _lblLikeProduct.hidden = NO;
        _likeBtnOutlet.userInteractionEnabled = NO;
        [_likeBtnOutlet setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
        _lblProductDesc.text = _productName;
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            //ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [myasset aspectRatioThumbnail];   //[rep fullResolutionImage];
            if (iref)
            {
                UIImage *largeimage = [UIImage imageWithCGImage:iref];
                _productImgVw.image = largeimage;
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can't get image - %@",[myerror localizedDescription]);
        };
        
        NSURL *asseturl = [NSURL URLWithString:_productImageUrl];
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];

       
    }
    else if (appDelegate.isFromHistoryPage)
    {
       // appDelegate.isFromHistoryPage = NO;
        
        _lblProductDesc.text = _productName;
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            //ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [myasset aspectRatioThumbnail];  //[rep fullResolutionImage];
            if (iref)
            {
                UIImage *largeimage = [UIImage imageWithCGImage:iref];
                _productImgVw.image = largeimage;
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can't get image - %@",[myerror localizedDescription]);
        };
        
        NSURL *asseturl = [NSURL URLWithString:_productImageUrl];
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"ProductDetails" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"queryToken == %@",_queryTokenForSelectedProduct];
        [request setPredicate:predicate];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryToken" ascending:YES]];
        
        NSArray *results = [context executeFetchRequest:request error:nil];
        
        NSManagedObject *product = (NSManagedObject *)[results objectAtIndex:0];
        if ([[product valueForKey:@"likeProduct"] isEqualToString:@"NO"])
        {
            _likeBtnOutlet.hidden = NO;
            _lblLikeProduct.hidden = NO;
            _likeBtnOutlet.userInteractionEnabled = YES;
        }
        else
        {
            _likeBtnOutlet.hidden = YES;
            _lblLikeProduct.hidden = YES;
 
        }
    }
    else
    {
        _likeBtnOutlet.hidden = NO;
        _lblLikeProduct.hidden = NO;
        _likeBtnOutlet.userInteractionEnabled = YES;
        _lblProductDesc.text = _productName;
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"IsFirstTime"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IsFirstTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //[self background_thread_call];
            
            [NSThread detachNewThreadSelector:@selector(SaveImageThread:) toTarget:self withObject:nil];
        }
    }
}


-(void) SaveImageThread:(id) obj
{
   __block UIImage *img;
   
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library addAssetsGroupAlbumWithName:@"ScanIt" resultBlock:^(ALAssetsGroup *group)
         {
             
             NSLog(@"Adding Folder:'ScanIt', success: %s", group.editable ? "Success" : "Already created: Not Success");
             
             //        Handler(group,nil);
             
         } failureBlock:^(NSError *error)
         {
             
             NSLog(@"Error: Adding on Folder");
             
         }];
        
        NSData *imgData = UIImageJPEGRepresentation(_productImage, 0.4);
        
        img = [UIImage imageWithData:imgData];
        
        [library saveImage:img toAlbum:@"ScanIt" completion:^(NSURL *assetURL, NSError *error)
         {
             NSLog(@"image saved to Album");
             
             NSManagedObjectContext *context = [self managedObjectContext];
             
             NSManagedObject *prodDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ProductDetails" inManagedObjectContext:context];
             
             [prodDetails setValue:_productName forKey:@"productName"];
             [prodDetails setValue:[assetURL absoluteString]  forKey:@"imageUrl"];
             [prodDetails setValue:[self getUserDefaultValueForKey:USERID] forKey:@"userId"];
             [prodDetails setValue:_queryTokenForSelectedProduct forKey:@"queryToken"];
             [prodDetails setValue:@"NO" forKey:@"likeProduct"];
             
             NSError *DBerror = nil;
             // Save the object to persistent store
             if (![context save:&DBerror]) {
                 NSLog(@"Can't Save! %@ %@", DBerror, [DBerror localizedDescription]);
             }
             else
             {
                 NSLog(@"Data added to database successfully");
                // _productImgVw.image = img;
                  [self performSelectorOnMainThread:@selector(ImageDoneLoading:) withObject:img waitUntilDone:NO];
                 
                 // [superViewController stopActivity:self.view];
                 
                 // [self performSegueWithIdentifier:@"showProductOptionsFromHome" sender:nil];
             }
             
         }
         
         
                   failure:^(NSError *error)
         {
             [superViewController stopActivity:self.view];
             UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Saving Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [alertMsg show];
         }];
        
    });
    
}

-(void) ImageDoneLoading:(id) obj
{
    _productImgVw.image = obj;
    // update your UI
    NSLog(@"done");
}

-(void)background_thread_call
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library addAssetsGroupAlbumWithName:@"ScanIt" resultBlock:^(ALAssetsGroup *group)
         {
             
             NSLog(@"Adding Folder:'ScanIt', success: %s", group.editable ? "Success" : "Already created: Not Success");
             
             //        Handler(group,nil);
             
         } failureBlock:^(NSError *error)
         {
             
             NSLog(@"Error: Adding on Folder");
             
         }];
        
        NSData *imgData = UIImageJPEGRepresentation(_productImage, 0.4);
        
        UIImage *img = [UIImage imageWithData:imgData];
        
        [library saveImage:img toAlbum:@"ScanIt" completion:^(NSURL *assetURL, NSError *error)
         {
             NSLog(@"image saved to Album");
             
             NSManagedObjectContext *context = [self managedObjectContext];
             
             NSManagedObject *prodDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ProductDetails" inManagedObjectContext:context];
             
             [prodDetails setValue:_productName forKey:@"productName"];
             [prodDetails setValue:[assetURL absoluteString]  forKey:@"imageUrl"];
             [prodDetails setValue:[self getUserDefaultValueForKey:USERID] forKey:@"userId"];
             [prodDetails setValue:_queryTokenForSelectedProduct forKey:@"queryToken"];
             [prodDetails setValue:@"NO" forKey:@"likeProduct"];
             
             NSError *DBerror = nil;
             // Save the object to persistent store
             if (![context save:&DBerror]) {
                 NSLog(@"Can't Save! %@ %@", DBerror, [DBerror localizedDescription]);
             }
             else
             {
                 NSLog(@"Data added to database successfully");
                 _productImgVw.image = img;
                 
                 // [superViewController stopActivity:self.view];
                 
                 // [self performSegueWithIdentifier:@"showProductOptionsFromHome" sender:nil];
             }
             
         }
         
         
                   failure:^(NSError *error)
         {
             [superViewController stopActivity:self.view];
             UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Saving Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [alertMsg show];
         }];
        
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isLike)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"ProductDetails" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(likeProduct == 'NO') AND (queryToken == %@)",_queryTokenForSelectedProduct];
        [request setPredicate:predicate];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryToken" ascending:YES]];
        
        NSArray *results = [context executeFetchRequest:request error:nil];
        
        NSManagedObject *product = (NSManagedObject *)[results objectAtIndex:0];
        
        [product setValue:@"YES" forKey:@"likeProduct"];
        
        NSError *saveError = nil;
        
        if (![product.managedObjectContext save:&saveError])
        {
            NSLog(@"Unable save managed object");
            NSLog(@"%@, %@", saveError, saveError.localizedDescription);
        }
        else
            NSLog(@"saved object to database  successfully");
        
        isLike = NO;
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

- (IBAction)backToHomeAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"IsFirstTime"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)likeAction:(id)sender
{
    if (isLike)
    {
      [_likeBtnOutlet setBackgroundImage:[UIImage imageNamed:@"like_blank.png"] forState:UIControlStateNormal];
        isLike = NO;
    }
    else
    {
       [_likeBtnOutlet setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        isLike = YES;
    }
}

- (IBAction)showRetailersListAction:(id)sender
{
    [self performSegueWithIdentifier:@"showSuggestedRetailersFromProductOptionsPage" sender:nil];
}

- (IBAction)flipKartAffiliatesAction:(id)sender
{
    [self getFlipkartAffiliatesDetailst];
}

- (IBAction)amazonAffiliatesAction:(id)sender
{
    [superViewController startActivity:self.view];
    
    RWMAmazonProductAdvertisingManager *manager = [[RWMAmazonProductAdvertisingManager alloc] initWithAccessKeyID:AWSAccessKeyId secret:AWSSecretKey];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [@{
                                         @"Service" : Service,
                                         @"Operation" : Operation,
                                         @"SearchIndex" : SearchIndex,
                                         @"Keywords" : _productName,   //@"men's black polo shirt"
                                         @"AssociateTag" : AssociateTag
                                         } mutableCopy];
    
    
    [manager enqueueRequestOperationWithMethod:@"GET" parameters:[parameters copy] success:^(id responseObject)
     {
         NSError *error=nil;
         NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"Request Successful, response '%@'", responseStr);
         NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         NSLog(@"Response Dictionary:: %@",jsonResponseDict);
         
         [superViewController stopActivity:self.view];
         
         xmlParser=[[NSXMLParser alloc]initWithData:responseObject];
         [xmlParser setDelegate:self];
         [xmlParser setShouldResolveExternalEntities:YES];
         
         if([xmlParser parse])
         {
             NSLog(@"Parsing Finished");
             NSLog(@"amazonAssociatesURL: %@",amazonAssociatesURL);
             
             SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:amazonAssociatesURL];
             [self.navigationController pushViewController:webViewController animated:YES];
             
            // [self performSegueWithIdentifier:@"showAmazonProductListFromProductOptions" sender:nil];
         }
         else
         {
             NSLog(@"Parsing Failed");
         }
         
     }
    failure:^(NSError *error)
     {
         [superViewController stopActivity:self.view];
         NSLog(@"Error: %@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please try again"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
    
}

#pragma mark - NSXMLParserDelegates

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"MoreSearchResultsUrl"])
    {
        NSLog(@"elementName: %@",elementName);
        
        isElementPresent = YES;
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isElementPresent)
    {
        NSLog(@"foundCharacters: %@",string);
        [amazonAssociatesURL appendString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"MoreSearchResultsUrl"])
    {
        NSLog(@"EndElement elementName: %@",elementName);
        isElementPresent = NO;
        
    }
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Parser error %@ ",[parseError description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[parseError description]
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark - Flipkart Affiliates Web Service

-(void)getFlipkartAffiliatesDetailst
{
    [superViewController startActivity:self.view];
    
    NSString *urlPostString = [NSString stringWithFormat:@"%@query=%@&resultCount=%d",FLIPKART_AFFILIATE_LINK,
                               _productName,10];
    
     NSLog(@"urlPostString:%@",urlPostString);
    
    NSURL *postURL = [NSURL URLWithString:[urlPostString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL];
   
    responseData = [NSMutableData dataWithCapacity: 0];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"scanitapp" forHTTPHeaderField:@"Fk-Affiliate-Id"];
    [request setValue:@"61589204e4344159aa894dd76d9d6f2e" forHTTPHeaderField:@"Fk-Affiliate-Token"];
    
    //[request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }

    
}


#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

// This method is used to receive the data which we get using post method.

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    [responseData appendData:data];
    
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [superViewController stopActivity:self.view];
    responseData = [[NSMutableData alloc]init];
    
    NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please try again"
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [superViewController stopActivity:self.view];
    
    arrProductInfoList = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSString *retVal = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"retVal=%@",retVal);
    NSMutableDictionary *jsonResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSLog(@"Response data %@",jsonResponseDict);
    
    arrProductInfoList = [jsonResponseDict[@"productInfoList"] mutableCopy];
    
    [self performSegueWithIdentifier:@"showProductListFromProductOptions" sender:nil];
    
}


#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSuggestedRetailersFromProductOptionsPage"])
    {
        SuggestedRetailersListViewController* suggestedRetailersVC = [segue destinationViewController];
        suggestedRetailersVC.productName = _productName;
    }
    else if ([[segue identifier] isEqualToString:@"showProductListFromProductOptions"])
    {
        ProductListViewController* productListVC = [segue destinationViewController];
        productListVC.arrFlipkartProductList = arrProductInfoList;
    }
    
    else if ([[segue identifier] isEqualToString:@"showAmazonProductListFromProductOptions"])
    {
        AmazonProductListingViewController* amazonProductListVC = [segue destinationViewController];
        amazonProductListVC.amazonProductListURL = amazonAssociatesURL;
    }
}


@end
