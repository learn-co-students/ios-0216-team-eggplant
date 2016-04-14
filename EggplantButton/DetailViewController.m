//
//  DetailViewController.m
//  EggplantButton
//
//  Created by Stephanie on 4/11/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UILabel *actDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *moreDetailLabel;

@property (weak, nonatomic) IBOutlet UIView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@,NY %@", self.activity.address, self.activity.city, self.activity.postalCode];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}



@end