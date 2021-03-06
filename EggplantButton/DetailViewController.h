//
//  DetailViewController.h
//  EasyOut
//
//  Created by Stephanie on 4/11/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Activity.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Activity *activity;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


-(void)downloadImageWithURL:(NSURL *)imageURL setTo:(UIImageView *)imageView;

@end
