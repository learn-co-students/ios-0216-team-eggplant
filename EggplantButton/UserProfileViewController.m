//
//  UserProfileViewController.m
//  EggplantButton
//
//  Created by Stephanie on 4/13/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "UserProfileViewController.h"
#import "EggplantButton-Swift.h"
#import "Firebase.h"
#import "Secrets.h"

@interface UserProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) User * user;


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRatedLabel;
@property (weak, nonatomic) IBOutlet UIStackView *numTipsGivenLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfItineraries;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FirebaseAPIClient *client = [[FirebaseAPIClient alloc]init];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
    
    [client getUserFromFirebaseWithUserID:ref.authData.uid completion:^(User * user, BOOL success) {
        
        self.user = user;
    }];
    
    self.usernameLabel.text = self.user.username;
    self.bioLabel.text = self.user.bio;
    
    
    [self setUpCamera];
    
    self.userImage.layer.cornerRadius = (self.userImage.frame.size.width)/2;
    self.userImage.clipsToBounds = YES;
    self.userImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    for (UILabel *label in @[self.numRatedLabel, self.numTipsGivenLabel, self.numOfItineraries]) {
        label.layer.cornerRadius = (label.frame.size.width)/2;
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    
}

-(void)setUpCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController * noCameraAlert =   [UIAlertController
                                               alertControllerWithTitle:@"Error"
                                               message:@"Device has no camera"
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [noCameraAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [noCameraAlert addAction:ok];
        [self presentViewController:noCameraAlert animated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.userImage.image = chosenImage;
    
//    FirebaseAPIClient *client = [[FirebaseAPIClient alloc]init];
//    
//    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
//    
//    [client saveNewImageWithImage:chosenImage completion:^(NSString * imageID) {
//
//    }];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)editPictureButtonPressed:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    UIAlertController * editPicture =   [UIAlertController
                                  alertControllerWithTitle:NULL
                                  message:NULL
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction
                         actionWithTitle:@"Take a New Profile Picture"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self takeAPictureWithPicker:picker];
                         }];
    UIAlertAction* selectPhoto = [UIAlertAction
                                actionWithTitle:@"Select Profile Picture"
                                  style: UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self selectAPictureWithPicker:picker];
                                }];
    
    UIAlertAction* cancel = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                             handler:nil];
    [editPicture addAction:takePhoto];
    [editPicture addAction:selectPhoto];
    [editPicture addAction: cancel];

    [self presentViewController:editPicture animated:YES completion:nil];
    
    
}

-(void)takeAPictureWithPicker:(UIImagePickerController *)picker {
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)selectAPictureWithPicker:(UIImagePickerController *)picker {
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
//- (IBAction)BACKButtonTapped:(id)sender {
//    
//    UIViewController * mainVC = [UIViewController ]
//    [self.navigationController popToViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
//     
//     popViewControllerAnimated:YES];
//}



@end
