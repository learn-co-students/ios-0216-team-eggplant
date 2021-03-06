//
//  Itinerary.m
//  EasyOut
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "Itinerary.h"
#import "Activity.h"
#import "EasyOut-Swift.h"

@implementation Itinerary

// Initialize a new Itinerary object when saving an itinerary from the main view controller
-(instancetype)initWithActivities:(NSMutableArray *)activities
                           userID:(NSString *)userID
                     creationDate:(NSDate *)creationDate
{
    self = [super init];
    
    if(self) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEEE',' MMM dd";
        NSString *dateString = [dateFormatter stringFromDate:creationDate];
        
        _itineraryID = @"";
        _activities = activities;
        _userID = userID;
        _creationDate = creationDate;
        _photos = [[NSMutableArray alloc] init];
        _ratings = [[NSMutableDictionary alloc] init];
        _tips = [[NSMutableDictionary alloc] init];
        _title = dateString;
        _durationInMins = 480;
        _priceRange = 0;
        _isPublic = NO;
    }
    
    return self;
    
}

// Initializer for Firebase dictionaries
-(instancetype)initWithFirebaseItineraryDictionary:(NSDictionary *)dictionary {
    
    NSMutableDictionary *newDictionary = [dictionary mutableCopy];
    
    NSArray *keys = [dictionary allKeys];
    
    NSMutableArray *photoKeys = [[NSMutableArray alloc] init];
//    NSMutableArray *tipKeys = [[NSMutableArray alloc] init];
//    NSMutableArray *ratingKeys = [[NSMutableArray alloc] init];
    
    // Check for empty dictionaries that Firebase may not have saved
    
    // ACTIVITIES
    if (![keys containsObject:@"activities"]) {
        [newDictionary setObject:[[NSMutableArray alloc] init] forKey:@"activities"];
    } else {
        
        NSMutableArray *activitiesArray = [[NSMutableArray alloc] init];

        for (NSDictionary *activityDictionary in newDictionary[@"activities"]) {
            
            // Convert activities in Firebase to Activity objects
            Activity *activity = [[Activity alloc] initWithFirebaseDictionary:activityDictionary];
            
            // Add new Activity objects to an array
            [activitiesArray addObject:activity];
        }
        
        // Remove activities from new Itinerary object dictionary
        [newDictionary[@"activities"] removeAllObjects];
        
        // Add activity array to newDictionary for activities key
        [newDictionary setObject:activitiesArray forKey:@"activities"];
    }
    
    // PHOTOS
    if (![keys containsObject:@"photos"]) {
        [newDictionary setObject:[[NSMutableArray alloc] init] forKey:@"photos"];
    } else {
        
        // Get all the photo keys associated with itinerary
        photoKeys = (NSMutableArray *)[dictionary[@"photos"] allKeys];
        
        // Get the image for each key
        for (NSString *key in photoKeys) {
            [FirebaseAPIClient getImageForImageID:key completion:^(UIImage *image) {
                newDictionary[@"photos"][key] = image;
            }];
        }
    }
    
    // TIPS
    if (![keys containsObject:@"tips"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"tips"];
    } else {
        NSLog(@"Tips exist for current itinerary, but we aren't getting them from Firebase");
    }
    
    // RATINGS
    if (![keys containsObject:@"ratings"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"ratings"];
    } else {
        NSLog(@"Ratings exist for current itinerary, but we aren't getting them from Firebase");
    }
    
    self = [self initWithUserID:newDictionary[@"userID"]
                    itineraryID:newDictionary[@"itineraryID"]
                          title:newDictionary[@"title"]
                   creationDate:newDictionary[@"creationDate"]
                     activities:newDictionary[@"activities"]
                         photos:newDictionary[@"photos"]
                        ratings:newDictionary[@"ratings"]
                           tips:newDictionary[@"tips"]
                 durationInMins:[newDictionary[@"durationInMins"] integerValue]
                     priceRange:[newDictionary[@"priceRange"] integerValue]
                       isPublic:[newDictionary[@"isPublic"] boolValue]
            ];
    
//    NSLog(@"%@ initialized from Firebase dictionary", newDictionary[@"title"]);
    
    return self;
}

// Designated initializer
-(instancetype)initWithUserID:(NSString *)userID
                  itineraryID:(NSString *)itineraryID
                        title:(NSString *)title
                 creationDate:(NSDate *)creationDate
                   activities:(NSMutableArray *)activities
                       photos:(NSMutableArray *)photos
                      ratings:(NSMutableDictionary *)ratings
                         tips:(NSMutableDictionary *)tips
               durationInMins:(NSUInteger)durationInMins
                   priceRange:(NSUInteger)priceRange
                     isPublic:(BOOL)isPublic
{
    
    self = [super init];
    
    if (self) {
        _userID = userID;
        _itineraryID = itineraryID;
        _title = title;
        _creationDate = creationDate;
        _activities = activities;
        _photos = photos;
        _ratings = ratings;
        _tips = tips;
        _durationInMins = durationInMins;
        _priceRange = priceRange;
        _isPublic = isPublic;
    }
    
    return self;
}

@end
