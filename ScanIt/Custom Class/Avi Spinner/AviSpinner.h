//
//  AviSpinner.h
//  Spinner
//
//  Created by Aviru bhattacharjee on 23/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kAviSpinnerTypeActivityIndicator;
extern NSString *const kAviSpinnerTypeCircular;
extern NSString *const kAviSpinnerTypeBeachBall;

// view will be rotating or draw full view to visualized rotation
typedef enum
{
    AviSpinTypeRotate,
    AviSpinTypeDraw
    
} AviSpinType;

//Diffrent patterns that can be set to  kAviSpinnerTypeActivityIndicator type spinner
typedef enum
{
    AviActivityIndicatorPatternStyleSolid,
    AviActivityIndicatorPatternStyleDash,
    AviActivityIndicatorPatternStyleDot,
    AviActivityIndicatorPatternStyleDashDot,
    AviActivityIndicatorPatternStylePetal,
    AviActivityIndicatorPatternStyleBox
    
} AviActivityIndicatorPatternStyle;



//This is an abstract class to create a spinner. You should use the appropriate subclass of AviSpinner to create the activity indicators of different types.
@interface AviSpinner : UIView
{
    NSTimer *_animationTimer;
    BOOL _isAnimating;
    BOOL _hidesWhenStopped;
    double _speed;
}

//Properties that applicable to all type of spinners
@property(nonatomic,readonly,assign) BOOL isAnimating;/*Indicates whether spinner is animating or not*/
@property(nonatomic, assign) BOOL hidesWhenStopped;/*Hides the spinner when spinner is not animating*/
@property(nonatomic,assign) double speed;/*Speed of the animation*/

//Property that is applicable to spinner type kAviSpinnerTypeBeachBall and kAviSpinnerTypeCircular. Setting the value on spinner type kAviSpinnerTypeActivityIndicator has no impact on the spinner.
@property(nonatomic,assign) CGFloat radius; /*Radius of the spinner. By deafult readius is set to 5 for kAviSpinnerTypeCircular and 11 for kAviSpinnerTypeBeachBall */


//Properties which are applicable to kAviSpinnerTypeActivityIndicator spinner type. Setting these attributes on other types of spinners have no impact on them.
@property(nonatomic,assign)CGFloat innerRadius;/* Default value as 6.0 will be taken if not spefified. Make sure that the inner radius is always lesser than the outer radius. */
@property(nonatomic,retain) UIColor* color; /* By default gray color is set */
@property(nonatomic,assign)CGFloat outerRadius;/* Default value as 9.0 will be taken if not spefified. Make sure that the outer radius is always greater than the inner radius. */
@property(nonatomic, assign) NSUInteger numberOfStrokes;/*By default 12 stokes are used*/
@property(nonatomic, assign) NSUInteger strokeWidth;/*2 is the default width of the eacg stoke*/
@property(nonatomic,assign) AviActivityIndicatorPatternStyle patternStyle;/*AviActivityIndicatorPatternStyleSolid is taken as the default value.*/
@property(nonatomic, assign) CGLineCap patternLineCap;/*kCGLineCapRound is taken as the default value.*/
@property(nonatomic, retain) UIImage *segmentImage;/*The image to be set as the activity indicator fin. By default no image is set. Hence the lines are set as fins. If image is set then this image is used as fins instead of lines. */


//This property used to customize the spinner created with specifying the type kAviSpinnerTypeCircular. If you set these properties to other types of spinners there will not be any impact on the spinners.
@property(nonatomic,retain) UIColor *fillColor;/*Color to be used to fill the circular path. By default white is used */
@property(nonatomic,retain) UIColor *pathColor;/*Color to be set to the circular path. By default sky blue is the color of the circular path*/
@property (nonatomic, assign)CGFloat thickness;/*By default thickness is set to 3.00*/

@property (nonatomic, assign)AviSpinType spinType;/*By default spinType is set to AviSpinTypeRotate and AviSpinTypeDraw for AviActivityIndicator.*/


//Spinner initialization method. It is recommended to use this method to create the spinners of your choice.
- (AviSpinner *)initWithSpinnerType:(NSString *) spinnerType;
+ (AviSpinner *) spinnerWithType:(NSString *) spinnerType;


//Spinner animation methods
- (void)startAnimating;
- (void)stopAnimating;


@end
