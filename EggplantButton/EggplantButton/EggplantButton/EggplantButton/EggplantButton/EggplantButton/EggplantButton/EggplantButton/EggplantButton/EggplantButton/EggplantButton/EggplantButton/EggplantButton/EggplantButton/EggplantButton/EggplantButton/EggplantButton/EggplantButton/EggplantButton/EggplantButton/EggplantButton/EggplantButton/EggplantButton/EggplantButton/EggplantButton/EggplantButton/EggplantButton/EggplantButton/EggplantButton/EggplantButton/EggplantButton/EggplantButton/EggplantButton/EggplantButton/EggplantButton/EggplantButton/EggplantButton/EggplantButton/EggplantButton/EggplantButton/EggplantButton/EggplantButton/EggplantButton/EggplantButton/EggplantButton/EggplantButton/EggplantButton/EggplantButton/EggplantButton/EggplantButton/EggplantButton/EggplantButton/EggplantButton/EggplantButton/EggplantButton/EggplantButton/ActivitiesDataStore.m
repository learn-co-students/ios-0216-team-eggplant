//
//  ActivitiesDataStore.m
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ActivitiesDataStore.h"
#import "OpenTableAPIClient.h"
#import "Restaurant.h"
#import "TicketMasterAPIClient.h"
#import "Event.h"


@implementation ActivitiesDataStore

+ (instancetype)sharedDataStore {
    static ActivitiesDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[ActivitiesDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _restaurants = [[NSMutableArray alloc]init];
        _events = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getRestaurantsWithCompletion:(void (^)(BOOL success))completionBlock
{
    [OpenTableAPIClient getRestaurantWithCompletion:^(NSArray *restaurants) {
        
        for(NSDictionary *restaurant in restaurants) {
            
            if (!restaurants) {
                
                completionBlock(NO);
                return;
            }
            
            [self.restaurants addObject:[Restaurant restaurantFromDictionary:restaurant]];
            
        }
        
        completionBlock(YES);
    }];
    
}

-(void)getEventsForLat:(NSString *)lat lng:(NSString *)lng withCompletion: (void (^)(BOOL success))successBlock {
    
    [TicketMasterAPIClient getEventsForLat:lat lng:lng withCompletion:^(NSArray *events) {

        if (!events) {
            
            successBlock(NO);
            return;
        
        }

        for (NSDictionary *eventDictionary in events) {

            Event *newEvent = [Event eventFromDictionary:eventDictionary];
            [self.events addObject: newEvent];

             successBlock(YES);
        }
    }];
    
}

@end
