//
//  ActivityCardView.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantDataStore.h"

@class Restaurant;
@interface ActivityCardView : UIView

@property (strong, nonatomic) Restaurant *restaurant;

@end
 