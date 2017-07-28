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
#import "ProductOptionCollectionViewCell.h"

#define AWSAccessKeyId @"AKIAJVWIIQX5M3HVKIYQ"

#define AWSSecretKey @"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"

#define AssociateTag @"wwwscanitappl-21"

#define Service @"AWSECommerceService"

#define Version @"2011-08-01"

#define Operation @"ItemSearch"

#define SearchIndex @"All"

@interface ProductOptionsViewController ()<UITextFieldDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableData * responseData;
    NSMutableArray *arrProductInfoList;
    BOOL isLike;
    BOOL isViewUp;
    AppDelegate *appDelegate;
    NSXMLParser *xmlParser;
    BOOL isElementPresent;
    NSMutableString *amazonAssociatesURL;
    UIButton *likeBtnOutlet;
    UIButton *doneBtnOutlet;
    UIButton *showRetailersListBtnOutlet;
    UILabel *lblLikeProduct;
    UITextField *txtSearchField;
    UITextView *txtVwSearchField;
    
    
    IBOutlet UIView *txtSearchContainerView;
    
    IBOutlet UIView *imageSearchContainerView;
    
    IBOutletCollection(UITextField) NSArray *txtSerachFieldCollections;
    
    
    IBOutletCollection(UITextView) NSArray *txtVwSearchFieldCollection;
    
    
    IBOutletCollection(UIButton)NSArray *doneBtnOutletCollections;
    
    IBOutletCollection(UILabel)NSArray *lblLikeProductCollections;
    
    IBOutletCollection(UIButton)NSArray *likeBtnOutletCollections;
    
    IBOutletCollection(UIButton)NSArray *showRetailersListBtnOutletCollections;
    
    IBOutlet UIImageView *dotImgVw1;
    IBOutlet UIImageView *dotImgVw2;
    IBOutlet UIImageView *dotImgVw3;
    
    IBOutlet UICollectionView *collVwProductOption;
    
    NSMutableArray *arrProductSearchOptions;
    
    IBOutlet UILabel *lblNoResult;
    
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

#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isLike = NO;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    amazonAssociatesURL = [[NSMutableString alloc]init];
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:.'"];
    _productName = [[_productName componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSLog(@"%@", _productName);
    
    dotImgVw1.layer.cornerRadius = dotImgVw1.frame.size.width/2;
    dotImgVw2.layer.cornerRadius = dotImgVw2.frame.size.width/2;
    dotImgVw3.layer.cornerRadius = dotImgVw3.frame.size.width/2;
    
    
    ///LIKE
    if (appDelegate.isFromLikePage)
    {
        
        if (_isTextSearch == NO)
        {
            imageSearchContainerView.hidden = NO;
            txtSearchContainerView.hidden = YES;
            
            //appDelegate.isFromLikePage = NO;
            // _lblProductDesc.text = _productName;
            
            NSURL *url = [NSURL URLWithString:_productImageUrl];
            [_productImgVw sd_setImageWithURL:url
                             placeholderImage:[UIImage imageNamed:@"no_image_product.jpg"]
                                      options:SDWebImageRefreshCached];
           
        }
        else
        {
            imageSearchContainerView.hidden = NO; //YES;
            //txtSearchContainerView.hidden = NO;
        }
        
        
        for (likeBtnOutlet in likeBtnOutletCollections) {
            
            if (likeBtnOutlet.superview.hidden == NO) {
                likeBtnOutlet.hidden = NO;
                lblLikeProduct.hidden = NO;
                likeBtnOutlet.userInteractionEnabled = NO;
                [likeBtnOutlet setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
            }
            
        }
        
        
        /*
        for (doneBtnOutlet in doneBtnOutletCollections) {
            
            if (doneBtnOutlet.superview.superview.hidden == NO) {
                doneBtnOutlet.layer.cornerRadius = 4.0f;
                doneBtnOutlet.layer.masksToBounds = YES;
            }
        }
         */
       
        [superViewController startActivity:self.view];
        [self getProductSearchOptions];
    }
    
    
    ///HISTORY
    else if (appDelegate.isFromHistoryPage)
    {
        // appDelegate.isFromHistoryPage = NO;
        
        //  _lblProductDesc.text = _productName;
        
        if (_isTextSearch == NO)
        {
            imageSearchContainerView.hidden = NO;
           // txtSearchContainerView.hidden = YES;
            
            NSURL *url = [NSURL URLWithString:_productImageUrl];
            [_productImgVw sd_setImageWithURL:url
                                 placeholderImage:[UIImage imageNamed:@"no_image_product.jpg"]
                                          options:SDWebImageRefreshCached];
        }
        
        else
        {
            imageSearchContainerView.hidden = NO; //YES;
            //txtSearchContainerView.hidden = NO;
        }
        
        /*
        if (_isProductLiked == NO)
        {
            for (likeBtnOutlet in likeBtnOutletCollections) {
                
                if (likeBtnOutlet.superview.hidden == NO) {
                    likeBtnOutlet.hidden = NO;
                    likeBtnOutlet.userInteractionEnabled = YES;
                }
            }
            
            for (lblLikeProduct in lblLikeProductCollections) {
                
                if (lblLikeProduct.superview.hidden == NO) {
                    lblLikeProduct.hidden = NO;
                }
            }
            
        }
         */
//        else
//        {
            for (likeBtnOutlet in likeBtnOutletCollections) {
                
                if (likeBtnOutlet.superview.hidden == NO) {
                    likeBtnOutlet.hidden = YES;
                }
            }
        
        /*
            for (lblLikeProduct in lblLikeProductCollections) {
                
                if (lblLikeProduct.superview.hidden == NO) {
                    lblLikeProduct.hidden = YES;
                }
            }
         */
    //    }
        
        /*
        for (doneBtnOutlet in doneBtnOutletCollections) {
            
            if (doneBtnOutlet.superview.superview.hidden == NO) {
                doneBtnOutlet.layer.cornerRadius = 4.0f;
                doneBtnOutlet.layer.masksToBounds = YES;
            }
        }
         */
        
        [superViewController startActivity:self.view];
        [self getProductSearchOptions];
    }
   
    
    ////WHAT'S NEW
    else if (self.isFromWhatsNewPage)
    {
        self.isFromWhatsNewPage = NO;
        imageSearchContainerView.hidden = NO;
        txtSearchContainerView.hidden = YES;
        _productImgVw.image = [UIImage imageNamed:@"no_image_product.jpg"];
        
        NSURL *url = [NSURL URLWithString:self.productImageUrl];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data scale:0.5];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _productImgVw.image = image;
                    });
                }
            }
        }];
        [task resume];
        
        _lblProductDesc.text = _productName;
        
        for (likeBtnOutlet in likeBtnOutletCollections) {
            
            if (likeBtnOutlet.superview.hidden == NO) {
                likeBtnOutlet.hidden = YES;
            }
        }
        
        /*
        for (lblLikeProduct in lblLikeProductCollections) {
            
            if (lblLikeProduct.superview.hidden == NO) {
                lblLikeProduct.hidden = YES;
            }
        }
        for (doneBtnOutlet in doneBtnOutletCollections) {
            
            if (doneBtnOutlet.superview.superview.hidden == NO) {
                doneBtnOutlet.layer.cornerRadius = 4.0f;
                doneBtnOutlet.layer.masksToBounds = YES;
            }
        }
         */
        
        [superViewController startActivity:self.view];
        [self getProductSearchOptions];
    }
    
    
    else
    {
        if (_isTextSearch == NO)
        {
            imageSearchContainerView.hidden = NO;
           // txtSearchContainerView.hidden = YES;
             _productImgVw.image = self.productImage;
            
            _lblProductDesc.text = _productName;
            
            if (![[NSUserDefaults standardUserDefaults]objectForKey:@"IsFirstTime"])
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IsFirstTime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               
            }
            
        }
        else
        {
            imageSearchContainerView.hidden = NO; //YES;
           // txtSearchContainerView.hidden = NO;
            
        }
                
        [self callInformServerForHistoryOrLikeListing:NO];
        
        
        for (likeBtnOutlet in likeBtnOutletCollections) {
            
            if (likeBtnOutlet.superview.hidden == NO) {
                likeBtnOutlet.hidden = NO;
                likeBtnOutlet.userInteractionEnabled = YES;
            }
        }
        
        for (doneBtnOutlet in doneBtnOutletCollections) {
            
            if (doneBtnOutlet.superview.superview.hidden == NO) {
                doneBtnOutlet.layer.cornerRadius = 4.0f;
                doneBtnOutlet.layer.masksToBounds = YES;
            }
        }
        
        /*
        for (lblLikeProduct in lblLikeProductCollections) {
            
            if (lblLikeProduct.superview.hidden == NO) {
                lblLikeProduct.hidden = NO;
            }
        }
         */
        
    }
    
    for (showRetailersListBtnOutlet in showRetailersListBtnOutletCollections) {
        
        if (showRetailersListBtnOutlet.superview.hidden == NO) {
            showRetailersListBtnOutlet.layer.cornerRadius = 3.0f;
        }
    }
    
    for (txtVwSearchField in txtVwSearchFieldCollection) {
        
        if (txtVwSearchField.superview.superview.hidden == NO) {
            txtVwSearchField.text = _productName;
        }
    }
    
    /*
    for (txtSearchField in txtSerachFieldCollections) {
        
        if (txtSearchField.superview.superview.hidden == NO) {
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
            txtSearchField.leftView = paddingView;
            txtSearchField.leftViewMode = UITextFieldViewModeAlways;
            //txtSearchField.layer.borderWidth = 1.0f;
            //txtSearchField.layer.borderColor = [UIColor colorWithRed:193.0/255.0 green:53.0/255.0 blue:30.0/255.0 alpha:1.0].CGColor;
            txtSearchField.text = _productName;
        }
    }
     */
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isViewUp)
    {
        isViewUp = NO;
        
        if (IS_IPHONE_4) {
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 160), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        
        else if (IS_IPHONE_5)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 140), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 110), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
    
    [self.view endEditing:YES];
    if (isLike)
    {
        [self callInformServerForHistoryOrLikeListing:YES];
    }
    
}

#pragma mark - Imform Sever for History Or Like

-(void)callInformServerForHistoryOrLikeListing:(BOOL)isLikeOrHistory
{
    [superViewController startActivity:self.view];
    
    NSError *error=nil;
    
    NSString * booleanString = (isLikeOrHistory) ? @"yes" : @"no";
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

    [dict setObject:booleanString forKey:@"islike"];
    [dict setObject:_productName forKey:@"product_keywords"];
    [dict setObject:[self getUserDefaultValueForKey:USERID] forKey:USERID];
    
    NSData *jsonRequestDict = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *URL=[BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST stringByAppendingString:POST_HISTORY_OR_LIKE];
    NSLog(@"POST_HISTORY_OR_LIKE_Url:%@",URL);
    
    NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    NSLog(@"***jsonCommand***%@",jsonCommand);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *postPicData =UIImageJPEGRepresentation(_productImgVw.image, 0.4) ;
        
        [formData appendPartWithFileData:postPicData
                                    name:@"ProductImage"
                                fileName:@"ProductImage.jpg"
                                mimeType:@"image/*"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
        
        /*
         Response Dictionary:: {
         ProductImage = "http://thelolstories.com/scanit/uploads/ProductImage/ProductImage_1481306164.jpg";
         UserID = 137;
         "history_id" = 2374;
         islike = no;
         message = "History saved successfully.";
         "product_keywords" = "tp link white wireless router";
         status = 1;
         }
         */
        
        //[superViewController stopActivity:self.view];
       
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
        }
        else
        {
            if (![jsonResponseDict[@"message"] isEqualToString:@"History already saved."])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:jsonResponseDict[@"message"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
           
        }
        
        if (isLike)
        {
             isLike = NO;
        }
        else
         [self getProductSearchOptions];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [superViewController stopActivity:self.view];
         
         NSLog(@"Error: %@", error);
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please try again"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
     }];
}

#pragma mark
#pragma mark New Product Serach Option Web Service
#pragma mark
-(void)getProductSearchOptions
{
    NSError *error=nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSString *formattedString = [_productName stringByReplacingOccurrencesOfString:@" " withString:@", "];
    
    [dict setObject:formattedString forKey:@"keywords"];
    
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *URL=[BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST stringByAppendingString:PRODUCT_SEARCH_OPTION];
    NSLog(@"PRODUCT_SEARCH_OPTION:%@",URL);
    
    NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    NSLog(@"***jsonCommand***%@",jsonCommand);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
        
        [superViewController stopActivity:self.view];
        
        arrProductSearchOptions = [NSMutableArray new];
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
            arrProductSearchOptions = [jsonResponseDict[@"response"][@"searchKeywords"] mutableCopy];
        }
        else
        {
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:jsonResponseDict[@"message"]
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
             */
        }
        
        
        NSDictionary *dict1 =@{@"website":@"flipkart",@"image":@"flipkart.png"};
        NSDictionary *dict2 =@{@"website":@"amazon",@"image":@"amazon_icon.png"};
        NSDictionary *dict3 =@{@"website":@"google",@"image":@"social-google-box-blue-icon.png"};
        
        [arrProductSearchOptions addObject:dict1];
        [arrProductSearchOptions addObject:dict2];
        [arrProductSearchOptions addObject:dict3];
        
        
        if (arrProductSearchOptions.count > 0) {
            
            collVwProductOption.hidden = NO;
            lblNoResult.hidden = YES;
            [collVwProductOption reloadData];
        }
        else{
            
            collVwProductOption.hidden = YES;
            lblNoResult.hidden = NO;
        }
       
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [superViewController stopActivity:self.view];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"please check your network connection"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         NSLog(@"Error: %@", error);
     }];
}



#pragma mark
#pragma mark Collection view layout things
#pragma mark

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width,height;
    width = 70;
    height = 70;
    return CGSizeMake(width,height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

/*
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}
 */

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,10,0,10);  // top, left, bottom, right
}


#pragma mark
#pragma mark collection view delegate
#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return arrProductSearchOptions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    ProductOptionCollectionViewCell *myCell = [collectionView
                                             dequeueReusableCellWithReuseIdentifier:@"productOptionCell"
                                             forIndexPath:indexPath];
    
    myCell.contentView.layer.cornerRadius = 8.0f;
    myCell.contentView.layer.borderWidth = 1.0f;
    myCell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    myCell.contentView.layer.masksToBounds = YES;
    
    myCell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    myCell.layer.shadowOffset = CGSizeMake(0.5, 0.5f);
    myCell.layer.shadowRadius = 2.0f;
    myCell.layer.shadowOpacity = 0.5f;
    myCell.layer.masksToBounds = NO;
    myCell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:myCell.bounds cornerRadius:myCell.contentView.layer.cornerRadius].CGPath;
    
    
    if ([arrProductSearchOptions[indexPath.row][@"website"] isEqualToString:@"flipkart"] || [arrProductSearchOptions[indexPath.row][@"website"] isEqualToString:@"amazon"] || [arrProductSearchOptions[indexPath.row][@"website"] isEqualToString:@"google"])
    {
        [myCell.activityIndicator stopAnimating];
        myCell.imgVwProductSearchType.image = [UIImage imageNamed:arrProductSearchOptions[indexPath.row][@"image"]];
    }
    else
    {
        [myCell.activityIndicator startAnimating];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:arrProductSearchOptions[indexPath.row][@"image"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data scale:0.5];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ProductOptionCollectionViewCell *myCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                        if (myCell)
                        {
                            [myCell.activityIndicator stopAnimating];
                            myCell.imgVwProductSearchType.image = image;
                        }
                    });
                }
            }
        }];
        [task resume];
    }
    
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if (_productName.length == 0) {
        
        showToastOnBottomPosition(@"Enter what you want to search")
    }
    else
    {
        
        if ([arrProductSearchOptions[indexPath.row][@"website"] isEqualToString:@"flipkart"])
        {
            [self flipKartAffiliatesAction:nil];
        }
        else if ([arrProductSearchOptions[indexPath.row][@"website"] isEqualToString:@"amazon"])
        {
            [self amazonAffiliatesAction:nil];
        }
        else if ([arrProductSearchOptions[indexPath.row][@"website"] isEqualToString:@"google"])
        {
            [self googleSearchBtnAction:nil];
        }
        else
        {
            NSString *strSearch = arrProductSearchOptions[indexPath.row][@"website"];
            NSString *str;
            if ([strSearch rangeOfString:@"q=#1234567#"
                                 options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                NSLog(@"found the q=#1234567#");
                NSString *strReplace = [NSString stringWithFormat:@"q=%@",_productName];
                str = [strSearch stringByReplacingOccurrencesOfString:@"q=#1234567#"
                                                           withString:strReplace];
            }
            else
                str = strSearch;
            
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self.navigationController pushViewController:webViewController animated:YES];
        }       
        
    }
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isViewUp = YES;
    
    if (IS_IPHONE_4) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 160), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    else if (IS_IPHONE_5)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 140), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 110), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
   
}


- (IBAction)txtSearchEditChange:(id)sender {
    
    for (txtSearchField in txtSerachFieldCollections) {
        
        if (txtSearchField.superview.superview.hidden == NO) {
            
            if ([[txtSearchField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0){
                
                _productName = txtSearchField.text;
            }
            else
                _productName = @"";
        }
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isViewUp = NO;
    
    if (IS_IPHONE_4) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 160), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    else if (IS_IPHONE_5)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 140), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 110), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];
    
    return  YES;
}

 */
 
#pragma mark - Text View Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    for (txtVwSearchField in txtVwSearchFieldCollection) {
        
        txtVwSearchField.text = @"";
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isViewUp = YES;
    
    if (IS_IPHONE_4) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 160), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    else if (IS_IPHONE_5)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 140), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 110), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }

}

-(void) textViewDidChange:(UITextView *)textView
{
    for (txtVwSearchField in txtVwSearchFieldCollection) {
        
        if(txtVwSearchField.text.length == 0)
        {
            txtVwSearchField.text = @"Enter Keywords";
            [txtVwSearchField resignFirstResponder];
            if (isViewUp)
            {
                isViewUp = NO;
                
                if (IS_IPHONE_4) {
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDuration:0.4];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 160), self.view.frame.size.width, self.view.frame.size.height);
                    [UIView commitAnimations];
                }
                
                else if (IS_IPHONE_5)
                {
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDuration:0.4];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 140), self.view.frame.size.width, self.view.frame.size.height);
                    [UIView commitAnimations];
                }
                
                else
                {
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDuration:0.4];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 110), self.view.frame.size.width, self.view.frame.size.height);
                    [UIView commitAnimations];
                }
            }
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
    {
        if (isViewUp)
        {
            isViewUp = NO;
            
            if (IS_IPHONE_4) {
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.4];
                [UIView setAnimationBeginsFromCurrentState:YES];
                self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 160), self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
            }
            
            else if (IS_IPHONE_5)
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.4];
                [UIView setAnimationBeginsFromCurrentState:YES];
                self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 140), self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
            }
            
            else
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.4];
                [UIView setAnimationBeginsFromCurrentState:YES];
                self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 110), self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
            }
        }
        
        for (txtVwSearchField in txtVwSearchFieldCollection) {
            
            if(txtVwSearchField.text.length == 0)
            {
                txtVwSearchField.text = @"Enter Keywords";
            }
        }
        
    
        [textView resignFirstResponder];
        return NO; // or true, whetever you's like
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    for (txtVwSearchField in txtVwSearchFieldCollection) {
        
        if (txtVwSearchField.superview.superview.hidden == NO) {
            
            txtVwSearchField.text = textView.text;
            
            if ([[txtVwSearchField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0){
                
                if ([txtVwSearchField.text isEqualToString:@"Enter Keywords"]) {
                    _productName = @"";
                }
                else
                 _productName = txtVwSearchField.text;
            }
            else
                _productName = @"";
        }
    }
}

#pragma mark - Button Action

- (IBAction)doneBtnAction:(id)sender {
    
    if (isViewUp)
    {
        isViewUp = NO;
        
        if (IS_IPHONE_4) {
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 160), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        
        else if (IS_IPHONE_5)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 140), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 110), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
    
    [self.view endEditing:YES];
}


- (IBAction)backToHomeAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"IsFirstTime"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)likeAction:(id)sender
{
    if (isLike)
    {
        for (likeBtnOutlet in likeBtnOutletCollections) {
            
            if (likeBtnOutlet.superview.hidden == NO) {
                [likeBtnOutlet setBackgroundImage:[UIImage imageNamed:@"like_blank.png"] forState:UIControlStateNormal];
            }
        }
        
        isLike = NO;
    }
    else
    {
        for (likeBtnOutlet in likeBtnOutletCollections) {
            
            if (likeBtnOutlet.superview.hidden == NO) {
                [likeBtnOutlet setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
            }
        }
        
        isLike = YES;
    }
}

- (IBAction)showRetailersListAction:(id)sender
{
    if ([_productName isEqualToString:@""]) {
        
         showToastOnBottomPosition(@"Enter search text to find Sellers")
    }
    else
     [self performSegueWithIdentifier:@"showSuggestedRetailersFromProductOptionsPage" sender:nil];
}

- (IBAction)googleSearchBtnAction:(id)sender
{
    
    NSString *strGoogleSearch;
    
    if (_productName.length == 0) {
        
        showToastOnBottomPosition(@"Enter what you want to search")
    }
    else
    {
#if TARGET_OS_SIMULATOR
  strGoogleSearch = [NSString stringWithFormat:@"http://www.google.co.in/search?q=%@",_productName]; //www.google.com
#else
  strGoogleSearch = [NSString stringWithFormat:@"http://www.google.co.in/search?q=%@&hl=%@", _productName, [[NSLocale preferredLanguages] objectAtIndex:0]];
#endif
        
        
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[strGoogleSearch stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
}


- (IBAction)flipKartAffiliatesAction:(id)sender
{
    if (_productName.length == 0) {
        
        showToastOnBottomPosition(@"Enter what you want to search")
    }
    else
    {
        [self getFlipkartAffiliatesDetailst];
        
    }
}

- (IBAction)amazonAffiliatesAction:(id)sender
{
    
    if (_productName.length == 0) {
        
        showToastOnBottomPosition(@"Enter what you want to search")
    }
    else
    {
        [superViewController startActivity:self.view];
        
        amazonAssociatesURL = [[NSMutableString alloc]init];
        
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
