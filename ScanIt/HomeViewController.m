//
//  HomeViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 02/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductOptionsViewController.h"
#import "AviSpinner.h"

NSString *const kUIActivityIndicatorView = @"UIActivityIndicatorView";
NSString *const kAviActivityIndicator = @"AviActivityIndicator";
NSString *const kAviCircularSpinner = @"AviCircularSpinner";
NSString *const kAviBeachBallSpinner = @"AviBeachBallSpinner";

@interface HomeViewController ()<UITextFieldDelegate>
{
   UIImage *editedImage;
    CGPoint myPoint;
    CLLocation *myLoc;
    NSString *Name;
    NSString *queryToken;
    NSString *imageURL;
    UIImagePickerController *cameraUI;
    BOOL isOpenCameraBtnTapped;
    UIActionSheet *actionSheetPopup;
    
    AviSpinner *circularSpinner;
    
    IBOutlet UIView *searchContainerView;
    
    IBOutlet UIView *searchView;
    
    IBOutlet UIView *activityIndicatorView;
    
    IBOutlet UITextField *txtSearch;
    
}

@end

@implementation HomeViewController

- (NSManagedObjectContext *)managedObjectContext {
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
    self.navigationItem.hidesBackButton = YES;
    
    searchView.layer.cornerRadius = 4.0f;
    searchView.layer.borderWidth = 1.0f;
    searchView.layer.borderColor = [UIColor colorWithRed:193.0/255.0 green:53.0/255.0 blue:30.0/255.0 alpha:1.0].CGColor;
    searchView.layer.masksToBounds = YES;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    txtSearch.leftView = paddingView;
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    
//    self.locationManager = [CLLocationManager new];
//    self.locationManager.delegate = self;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//    {
//        [self.locationManager requestAlwaysAuthorization];
//    }
    
    [_leftBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isImageAvailable)
    {
        _capturedImgVw.image = editedImage;
        _openCameraBtnOutlet.hidden = YES;
        _lblOpenCamera.hidden = YES;
        _capturedImgVw.hidden = NO;
        _lblProcessingImage.hidden = NO;
        
        searchContainerView.hidden = YES;
        
        circularSpinner = [[AviSpinner alloc] initWithSpinnerType:kAviCircularSpinner];
        circularSpinner.hidesWhenStopped = YES;
        circularSpinner.radius = 20;
        circularSpinner.pathColor = [UIColor whiteColor];
        circularSpinner.fillColor = [UIColor darkGrayColor];
        circularSpinner.thickness = 3;
        
        [circularSpinner setBounds:CGRectMake(0, 0, 50, 50)]; //
        [circularSpinner setCenter:CGPointMake(self.view.center.x, activityIndicatorView.center.y+10)];
        
        [circularSpinner startAnimating];
        
        [self.view addSubview:circularSpinner];
        
        [self searchWithImage:editedImage];
        
    }
    
    else
    {
        _openCameraBtnOutlet.hidden = NO;
        _lblOpenCamera.hidden =NO;
        _capturedImgVw.hidden =YES;
        _lblProcessingImage.hidden = YES;
        
        searchContainerView.hidden = NO;
        
        //[self.locationManager startUpdatingLocation];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    [txtSearch resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Determine Current Location
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations //***Aviru
//{
//    NSLog(@"lat:%f",manager.location.coordinate.latitude);
//    NSLog(@"long:%f",manager.location.coordinate.longitude);
//    
//    NSLog(@"location.lastobject:%@",[locations lastObject]);
//    myLoc = manager.location;
//    
//    myPoint = CGPointMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
//    
//    [self.locationManager stopUpdatingLocation];
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_4)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 160), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 140), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (IS_IPHONE_4)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 160), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 140), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    
    return  YES;
}


#pragma mark - Button Action

- (IBAction)leftPannelAction:(id)sender
{
    
}

- (IBAction)openCameraAction:(id)sender
{
    [self.view endEditing:YES];
    
    [txtSearch resignFirstResponder];
    
    isOpenCameraBtnTapped = YES;
    
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.delegate = self;
    cameraUI.allowsEditing = YES;
    
    if (IS_OS_8_OR_LATER)
    {
        actionSheetPopup = [[UIActionSheet alloc] initWithTitle:@"Select an option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Take Photo",
                                @"Choose From Album",
                                nil];
        actionSheetPopup.tag = 1;
        [actionSheetPopup showInView:self.view];
    }
    else if (IS_OS_9_OR_LATER)
    {
        UIAlertController *AlertControllerActionSheet = [UIAlertController alertControllerWithTitle:@"Select an option:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [AlertControllerActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
            // Cancel button tappped do nothing.
            
            isOpenCameraBtnTapped = NO;
            
        }]];
        
        [AlertControllerActionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            // take photo button tapped.
            [self captureImageFromCamera];
            
        }]];
        
        [AlertControllerActionSheet addAction:[UIAlertAction actionWithTitle:@"Choose From Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            // choose photo button tapped.
            [self chooseImageFromAlbum];
            
        }]];
    }
    
}

- (IBAction)searchBtnAction:(id)sender {
    
    if ([[txtSearch text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
       showToastOnBottomPosition(@"Enter what you want to search")
    }
    else
    {
        isOpenCameraBtnTapped = NO;
        [self performSegueWithIdentifier:@"showProductOptionsFromHome" sender:nil];
    }
    
}


#pragma mark - Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self captureImageFromCamera];
    }
    else if (buttonIndex == popup.cancelButtonIndex)
    {
        isOpenCameraBtnTapped = NO;
    }
    else if(buttonIndex==1)
    {
        [self chooseImageFromAlbum];
    }
}

#pragma mark - Capture Image From Camera

-(void)captureImageFromCamera
{
   #if TARGET_IPHONE_SIMULATOR
    // Simulator
    editedImage = [UIImage imageNamed:@"test_img.jpg"];
    [self searchWithImage:editedImage];
   #else
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
            
        {
            cameraUI.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:cameraUI animated:YES completion:NULL];
        
    }
    
    else
    {
        UIAlertView *a =[[UIAlertView alloc]initWithTitle:nil message:@"No camera Found" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] ;
        [a show];
    }
    
   #endif
    
}

#pragma mark

#pragma mark -Choose Image From Album

-(void)chooseImageFromAlbum
{
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:cameraUI animated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if(!image)
    {
        image = info[UIImagePickerControllerOriginalImage];
    }
    else
        _isImageAvailable = YES;
    
    editedImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - CloudSight--------

- (void)searchWithImage:(UIImage *)image {
    NSString *deviceIdentifier = [self getUserDefaultValueForKey:IMEI];  // This can be any unique identifier per device, and is optional - we like to use UUIDs
    CLLocation *location = nil; // you can use the CLLocationManager to determine the user's location
    
    // We recommend sending a JPG image no larger than 1024x1024 and with a 0.7-0.8 compression quality,
    // you can reduce this on a Cellular network to 800x800 at quality = 0.4
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
    
    NSData *compressImgData = UIImageJPEGRepresentation(image, 0.5);
    editedImage = [UIImage imageWithData:compressImgData];
    
    // Create the actual query object
    CloudSightQuery *query = [[CloudSightQuery alloc] initWithImage:imageData
                                                         atLocation:CGPointMake(0.0, 0.0)
                                                       withDelegate:self
                                                        atPlacemark:nil
                                                       withDeviceId:deviceIdentifier];
    
    // Start the query process
    [query start];
}

#pragma mark CloudSightQueryDelegate

- (void)cloudSightQueryDidFinishIdentifying:(CloudSightQuery *)query {
    
    if (query.skipReason != nil) {
        NSLog(@"Skipped: %@", query.skipReason);
    }
    else {
        //NSLog(@"Identified title: %@", query.title);
         NSLog(@"Identified name: %@", query.name);
         NSLog(@"Query token: %@", query.token);
        queryToken = query.token;
        Name = query.name;
        _isImageAvailable = NO;
        
       // [self saveImage];
        
        [self performSegueWithIdentifier:@"showProductOptionsFromHome" sender:nil];
    }
}

- (void)cloudSightQueryDidFinishUploading:(CloudSightQuery *)query
{
    NSLog(@"cloudSightQueryDidFinishUploading called");
}

- (void)cloudSightQueryDidFail:(CloudSightQuery *)query withError:(NSError *)error {
    NSLog(@"cloudSightQueryDidFail Error: %@", error);
    
    
    //[self.locationManager startUpdatingLocation];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Unable to process Image"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        _isImageAvailable = NO;
        _openCameraBtnOutlet.hidden = NO;
        _lblOpenCamera.hidden = NO;
        _capturedImgVw.hidden =YES;
        _lblProcessingImage.hidden = YES;
    }
}


#pragma mark

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [circularSpinner stopAnimating];
        
    });
    
    if ([[segue identifier] isEqualToString:@"showProductOptionsFromHome"])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        appDelegate.isFromLikePage = NO;
        appDelegate.isFromHistoryPage = NO;
        ProductOptionsViewController* productOptionsVC = [segue destinationViewController];
        
        if (isOpenCameraBtnTapped)
        {
            productOptionsVC.productImage = editedImage;
            productOptionsVC.productImageUrl = imageURL;
            productOptionsVC.queryTokenForSelectedProduct = queryToken;
            productOptionsVC.productName = Name;
            productOptionsVC.isTextSearch = NO;
        }
        
       else
       {
           productOptionsVC.productName = txtSearch.text;
           productOptionsVC.isTextSearch = YES;
       }
    }
}

@end
