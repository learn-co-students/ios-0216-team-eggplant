//
//  User.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "User.h"

@interface User ()

@property (strong, nonatomic) NSString *uniqueID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSMutableArray *savedItineraries;
@property (strong, nonatomic) NSMutableDictionary *preferences;
@property (strong, nonatomic) NSMutableDictionary *ratings;
@property (strong, nonatomic) NSMutableDictionary *tips;
@property (strong, nonatomic) NSData *profilePhoto;
@property (nonatomic) NSUInteger reputation;

@end

@implementation User

-(instancetype)init {
    self = [self initWithUniqueID:@"8455b42e-e7d0-49cb-bcce-2e03331b402f"];
    if (self) {
        
    }
    
    return self;
}

-(instancetype) initWithEmail:(NSString *)email
                     password:(NSString *)password {
    
    self = [super init];
    
    if (self) {
        _uniqueID = @"id";
        _username = @"testUsername";
        _email = email;
        _bio = @"lol wut";
        _location = @"over there";
        _savedItineraries = [@[] mutableCopy];
        _preferences = [@{} mutableCopy];
        _ratings = [@{} mutableCopy];
        _tips = [@{} mutableCopy];
        _profilePhoto = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/16245367?v=3&s=460"]];
        _reputation = 1;
    }
    
    NSLog(@"User initialized");
    
    return self;
}

-(instancetype)initWithUniqueID:(NSString *)uniqueID {
    
    self = [super init];
    
    if (self) {
        _uniqueID = uniqueID;
        _username = @"testUsername";
        _email = @"test@test.test";
        _bio = @"lol wut";
        _location = @"over there";
        _savedItineraries = [@[] mutableCopy];
        _preferences = [@{} mutableCopy];
        _ratings = [@{} mutableCopy];
        _tips = [@{} mutableCopy];
        _profilePhoto = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/16245367?v=3&s=460"]];
        _reputation = 1;
    }
    
    NSLog(@"User initialized");
    
    return self;

}

@end
