//
//  FilterViewController.m
//  EasyOut
//
//  Created by Stephanie on 4/13/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"Back button tapped");
}

@end
