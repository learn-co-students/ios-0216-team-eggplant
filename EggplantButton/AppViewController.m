//
//  AppViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "AppViewController.h"


@interface AppViewController ()

// Container view outlet property
@property (weak, nonatomic) IBOutlet UIView *containerView;

// Current VC property for swapping VCs in the container view
@property (strong, nonatomic) UIViewController *currentViewController;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
    
    if (ref.authData) {
        UIViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:mainViewControllerStoryBoardID];
    
        [self setEmbeddedViewController:mainVC];
    }
    else {
        UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:LoginViewControllerStoryBoardID];
        [self setEmbeddedViewController:loginVC];
    }
    
    [self addNotificationObservers];
    
}

-(void)addNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backToMain)
                                                 name:mainViewControllerStoryBoardID
                                               object:nil];
    
}

-(void)backToMain {
    UIViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:mainViewControllerStoryBoardID];
    
    [self setEmbeddedViewController:mainVC];
}



-(void)setEmbeddedViewController:(UIViewController *)controller
{
    if ([self.childViewControllers containsObject:controller]) {
        return;
    }
    
    for(UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        
        if(vc.isViewLoaded) {
            [vc.view removeFromSuperview];
        }
        
        [vc removeFromParentViewController];
    }
    
    if (!controller) {
        return;
    }
    
    [self addChildViewController:controller];
    [self.containerView addSubview:controller.view];
    [controller.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [controller didMoveToParentViewController:self];
}


@end
