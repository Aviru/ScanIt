//
//  AccountViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 02/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()
{
    UIImagePickerController *picker;
    UIImage *chosenImage;
    NSData *checkImageData1;
    UIImage *deleteImg;
    BOOL delBtnTapped;
    BOOL deleteBtnAppear;
    NSString *imageURL;
    BOOL isValidfirstName,isValidLastName,isValidPhoneNumber,isValidEmail;
    CGFloat prevYAxisValue;
    NSString *firstName;
    NSString *lastName;
    NSString *shippingAddress;
    AppDelegate *appDel;
}

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [[UIApplication sharedApplication]delegate];
    
    delBtnTapped=NO;
    _AcccountView.layer.cornerRadius = 4.0f;
    _AcccountView.layer.borderWidth = 1.0f;
    _AcccountView.layer.borderColor = [UIColor clearColor].CGColor;
    _AcccountView.layer.masksToBounds = YES;
    
    _AcccountView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _AcccountView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _AcccountView.layer.shadowRadius = 0.8f;
    _AcccountView.layer.shadowOpacity = 0.5f;
    _AcccountView.layer.masksToBounds = NO;
    _AcccountView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_AcccountView.bounds cornerRadius:_AcccountView.layer.cornerRadius].CGPath;
    
    self.btnEditOutlet.layer.cornerRadius = 3.0f;
    
    if ([[self getUserDefaultValueForKey:REGISTRATIONTYPE] isEqualToString:@"Demo"])
    {
        _txtFirstName.userInteractionEnabled = NO;
        _txtLastName.userInteractionEnabled = NO;
        _txtEmail.userInteractionEnabled = NO;
        _txtMobileNumber.userInteractionEnabled = NO;
        _txtShippingAddress.userInteractionEnabled = NO;
        _editImageBtnOutlet.userInteractionEnabled = NO;
        self.btnEditOutlet.userInteractionEnabled = NO;
        _cancelBtnOutlet.hidden = YES;
    }
    else
    {
        _txtFirstName.userInteractionEnabled = NO;
        _txtLastName.userInteractionEnabled = NO;
        _txtEmail.userInteractionEnabled = NO;
        _txtMobileNumber.userInteractionEnabled = NO;
        _txtShippingAddress.userInteractionEnabled = NO;
        _editImageBtnOutlet.userInteractionEnabled = NO;
        self.btnEditOutlet.userInteractionEnabled = YES;
        _cancelBtnOutlet.hidden = YES;
    }
    
    if ([[self getUserDefaultValueForKey:PROFILEIMAGE] length] != 0)
    {
        _userImgVw.layer.cornerRadius = _userImgVw.frame.size.width / 2;
        _userImgVw.layer.masksToBounds = YES;
        _userImgVw.image = [UIImage imageWithData:[self getUserDefaultValueForKey:PROFILEIMAGE]];
    }
    else
    {
        UIImage *img =[UIImage imageNamed:@"profile_pic.png"];
        _userImgVw.image = [UIImage imageWithData:UIImagePNGRepresentation(img)];
       // [UIPasteboard generalPasteboard].image =  _userImgVw.image;
        deleteImg = _userImgVw.image;
    }

    _txtFirstName.text = [self getUserDefaultValueForKey:FIRSTNAME];
    _txtLastName.text = [self getUserDefaultValueForKey:LASTNAME];
    _txtEmail.text = [self getUserDefaultValueForKey:EMAIL];
    _txtMobileNumber.text = [self getUserDefaultValueForKey:PHONENUMBER];
    
    [_leftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_txtMobileNumber)
    {
        if (self.view.frame.origin.y == prevYAxisValue)
        {
            NSLog(@"previous text field y axis value same as now");
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            prevYAxisValue = (self.view.frame.origin.y - 90);
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 115), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            
        }
        
    }
    if (textField==_txtShippingAddress)
    {
        if (self.view.frame.origin.y == prevYAxisValue)
        {
            NSLog(@"previous text field y axis value same as now");
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            prevYAxisValue = (self.view.frame.origin.y - 80);
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 80), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            
        }
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_txtFirstName)
    {
        NSString *rawString = [_txtFirstName text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        firstName = [rawString stringByTrimmingCharactersInSet:whitespace];
        
        if (firstName.length>0)
        {
            isValidfirstName=YES;
        }
        else
        {
            isValidfirstName=NO;
            
        }
        
    }
    
    if (textField==_txtLastName)
    {
        NSString *rawString = [_txtLastName text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        lastName = [rawString stringByTrimmingCharactersInSet:whitespace];
        
        if (lastName.length>0)
        {
            isValidLastName=YES;
        }
        else
        {
            isValidLastName=NO;
            
        }
        
    }
    
    if (textField==_txtEmail) //***Email
    {
        if(textField.text.length > 0)
        {
            isValidEmail = [self validateEmail:textField.text];
        }
        
        else
        {
            isValidEmail = NO;
        }
    }

    if (textField==_txtShippingAddress)
    {
        if ([textField.text length]>0)
        {
            shippingAddress = _txtShippingAddress.text;
        }
        else
          shippingAddress = @"";
    }
    
    if (textField==_txtMobileNumber)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 115), self.view.frame.size.width, self.view.frame.size.height);
        prevYAxisValue = self.view.frame.origin.y;
        [UIView commitAnimations];
        
        if ([textField.text length]>0)
        {
            if([textField.text length] >= 10)
            {
                isValidPhoneNumber = YES;
            }
            else
                isValidPhoneNumber = NO;
        }
        else
            isValidPhoneNumber = NO;
    }
    
    if (textField==_txtShippingAddress)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 80), self.view.frame.size.width, self.view.frame.size.height);
        prevYAxisValue = self.view.frame.origin.y;
        [UIView commitAnimations];
    }
}

#pragma mark - Touch Event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Button Action

- (IBAction)EditAction:(id)sender
{
    if ([_btnEditOutlet.titleLabel.text isEqualToString:@"Edit"])
    {
        _txtFirstName.userInteractionEnabled = YES;
        _txtLastName.userInteractionEnabled = YES;
        _txtEmail.userInteractionEnabled = YES;
        _txtMobileNumber.userInteractionEnabled = YES;
         _editImageBtnOutlet.userInteractionEnabled = YES;
        _txtShippingAddress.userInteractionEnabled = YES;
        [_btnEditOutlet setTitle:@"Save" forState:UIControlStateNormal] ;
        _cancelBtnOutlet.hidden = NO;
        
        if (![_txtFirstName.text isEqualToString:@""])
        {
            isValidfirstName = YES;
        }
        if (![_txtLastName.text isEqualToString:@""])
        {
            isValidLastName = YES;
        }
        if (![_txtEmail.text isEqualToString:@""])
        {
            isValidEmail = YES;
        }
        if (![_txtMobileNumber.text isEqualToString:@""])
        {
            isValidPhoneNumber = YES;
        }
        if ([_txtShippingAddress.text isEqualToString:@""])
        {
            shippingAddress = @"";
        }
    }
   else
   {
      if (!isValidfirstName)
       {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Please enter valid First Name"
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
       }
       else if (!isValidLastName)
       {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Please enter valid Last Name"
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
       }
       
       else if (!isValidEmail)
       {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Please Ensure that you have entered correct Email"
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
       }
       
       else if (!isValidPhoneNumber)
       {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Please enter valid Mobile Number. The number must be atleast 10 digits"
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
       }
       
       else
       {
           [superViewController startActivity:self.view];
           [_btnEditOutlet setTitle:@"Edit" forState:UIControlStateNormal] ;
            NSMutableDictionary *EditUserInfoDict = [NSMutableDictionary dictionary];
           if(delBtnTapped==NO)
           {
              [EditUserInfoDict setObject:@"N" forKey:@"delete_image"];
           }
           else if (delBtnTapped==YES)
           {
              [EditUserInfoDict setObject:@"Y" forKey:@"delete_image"];
           }
           
           [EditUserInfoDict setObject:[self getUserDefaultValueForKey:USERID] forKey:USERID];
           [EditUserInfoDict setObject:_txtFirstName.text forKey:FIRSTNAME];
           [EditUserInfoDict setObject:_txtLastName.text forKey:LASTNAME];
           [EditUserInfoDict setObject:_txtEmail.text forKey:EMAIL];
           [EditUserInfoDict setObject:_txtMobileNumber.text forKey:PHONENUMBER];
           [EditUserInfoDict setObject:shippingAddress forKey:ADDRESS];
           
           
               [self editUserInfoDetails:EditUserInfoDict];
           
       }
  
   }
    
}

- (IBAction)editImageAction:(id)sender
{
    //UIActionSheet *popUp = [[UIActionSheet alloc]initWithTitle:@"Select an option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"Take Photo",@"Choose From Album", nil];
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    UIActionSheet* popup = [[UIActionSheet alloc] init];
    // sheet.title = @"Illustrations";
    popup.delegate = self;
    popup.cancelButtonIndex = [popup addButtonWithTitle:@"Cancel"];
    [popup addButtonWithTitle:@"Take Photo"];
    [popup addButtonWithTitle:@"Choose From Album"];
    
   // UIImage *pasteBoardImg = [UIPasteboard generalPasteboard].image;
    
    if ([self image:_userImgVw.image isEqualTo:deleteImg])
    {
         deleteBtnAppear=NO;
    }
    
    else
    {
        deleteBtnAppear=YES;
        popup.destructiveButtonIndex= [popup addButtonWithTitle:@"Delete"];
    }
    
    popup.tag = 1;
    [popup showInView:self.view];
}

- (IBAction)cancelAction:(id)sender
{
    _txtFirstName.userInteractionEnabled = NO;
    _txtLastName.userInteractionEnabled = NO;
    _txtEmail.userInteractionEnabled = NO;
    _txtMobileNumber.userInteractionEnabled = NO;
    _editImageBtnOutlet.userInteractionEnabled = NO;
    _txtShippingAddress.userInteractionEnabled = NO;
    _cancelBtnOutlet.hidden = YES;
    [_btnEditOutlet setTitle:@"Edit" forState:UIControlStateNormal];
    
    if ([[self getUserDefaultValueForKey:PROFILEIMAGE] length] != 0)
    {
        _userImgVw.image = [UIImage imageWithData:[self getUserDefaultValueForKey:PROFILEIMAGE]];
    }
    else
    {
        UIImage *img =[UIImage imageNamed:@"profile_pic.png"];
        _userImgVw.image = [UIImage imageWithData:UIImagePNGRepresentation(img)];
    }
    
}

#pragma mark - Web service

-(void)editUserInfoDetails:(NSMutableDictionary *)editInfoDict
{
    NSError *error=nil;
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:editInfoDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *URL=[BASEURL stringByAppendingString:EDITPROFILE];
    
    NSLog(@"EDITPROFILE_URL:%@",URL);
    
    NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    NSLog(@"***jsonCommand***%@",jsonCommand);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSData *postPicData =UIImagePNGRepresentation(_userImgVw.image) ;
         
         [formData appendPartWithFileData:postPicData
                                     name:PROFILEIMAGE
                                 fileName:@"profilePic.png"
                                 mimeType:@"image/*"];
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
        
        [superViewController stopActivity:self.view];
        
              /*Response Dictionary:: {
               ProfileImage = "http://thelolstories.com/scanit/uploads/user_cover_photos/thumb/user_1458246891.png";
               UserID = 22;
               message = "Profile edited successfully.";
               status = 1;
               }
         */
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
            if ([self image:_userImgVw.image isEqualTo:deleteImg]) //checkImageData1
            {
                [self setUserDefaultValue:@"" ForKey:PROFILEIMAGE];
                
                [self setUserDefaultValue:UIImagePNGRepresentation(_userImgVw.image) ForKey:@"CheckEmptyImage"];
            }
            else
              [self setUserDefaultValue:UIImagePNGRepresentation(_userImgVw.image) ForKey:PROFILEIMAGE];
            
            [self setUserDefaultValue:_txtFirstName.text ForKey:FIRSTNAME];
            [self setUserDefaultValue:_txtLastName.text ForKey:LASTNAME];
            [self setUserDefaultValue:_txtEmail.text ForKey:EMAIL];
            [self setUserDefaultValue:_txtMobileNumber.text ForKey:PHONENUMBER];
            [self setUserDefaultValue:shippingAddress ForKey:ADDRESS];
            
            [self.view makeToast:@"Profile Edited Successfully" duration:2.0 position:CSToastPositionBottom];
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


#pragma mark - Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
       
    }
    
    if(buttonIndex==1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
                
            {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            }
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
        
        else {
            UIAlertView *a =[[UIAlertView alloc]initWithTitle:nil message:@"No camera Found" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] ;
            [a show];
        }
        
    }
    else if(buttonIndex==2)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:NULL];
        
        
    }
    
    else if(buttonIndex==3)
    {
        if (deleteBtnAppear==YES)
        {
            // [_profileImageView applyPhotoFrame];
            UIImage *img =[UIImage imageNamed:@"profile_pic.png"];
            
            _userImgVw.image = [UIImage imageWithData:UIImageJPEGRepresentation(img,0.0)];
            
           // [UIPasteboard generalPasteboard].image = _userImgVw.image;
            
            deleteImg = _userImgVw.image;
            
            delBtnTapped=YES;
            
        }
        
        else
        {
           
        }
    }

}

#pragma mark - ImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)Imgpicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *img = info[UIImagePickerControllerEditedImage];
    
    chosenImage = [UIImage imageWithData:UIImagePNGRepresentation(img)];
    
    imageURL = nil;
    
    if([Imgpicker sourceType]==UIImagePickerControllerSourceTypeCamera)
    {
        ALAssetsLibraryWriteImageCompletionBlock completeBlock = ^(NSURL *assetURL, NSError *error){
            if (!error) {
#pragma mark get image url from camera capture.
                
                if (assetURL==nil)
                {
                    imageURL=@"";
                }
                else
                {
                    imageURL = [NSString stringWithFormat:@"%@",assetURL];
                    
                    _userImgVw.layer.cornerRadius = _userImgVw.frame.size.width / 2;
                    _userImgVw.layer.masksToBounds = YES;

                    
                    _userImgVw.image = chosenImage;
                    
                    
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    
                    [library addAssetsGroupAlbumWithName:@"ScanIt" resultBlock:^(ALAssetsGroup *group)
                     {
                         
                         NSLog(@"Adding Folder:'ScanIt', success: %s", group.editable ? "Success" : "Already created: Not Success");
                         
                         //        Handler(group,nil);
                         
                     } failureBlock:^(NSError *error)
                     {
                         
                         NSLog(@"Error: Adding on Folder");
                         
                     }];
                    
                    
                    
                    [library saveImage:_userImgVw.image toAlbum:@"ScanIt" completion:^(NSURL *assetURL, NSError *error)
                     {
                         NSLog(@"image saved to Album");
                         
                     }
                     
                     
                    failure:^(NSError *error)
                     {
                         UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Saving Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         
                         [alertMsg show];
                     }];

                    
                    
                }
            }
        };
        
        
        if(chosenImage)
        {
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum :[chosenImage CGImage]
                                       orientation:(ALAssetOrientation)[chosenImage imageOrientation]
                                   completionBlock:completeBlock];
        }
        
    }
    else
    {
        NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        imageURL = [NSString stringWithFormat:@"%@",assetURL];
        
        _userImgVw.layer.cornerRadius = _userImgVw.frame.size.width / 2;
        _userImgVw.layer.masksToBounds = YES;
        
        _userImgVw.image = chosenImage;
    }
    
    [Imgpicker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Check Image equality

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}


@end
