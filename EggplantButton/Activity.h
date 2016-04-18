//
//  Activity.h
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *phonenumber;
@property (strong, nonatomic) NSURL *reserveURL;

-(instancetype)initWithDictionary:(NSDictionary *)activityDictionary;

+(Activity *)activityFromDictionary:(NSDictionary *)activityDictionary;


@end
