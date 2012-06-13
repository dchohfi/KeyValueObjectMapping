//
//  Location.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "Location.h"

@implementation Location
@synthesize latitude, longitude;

-(id)initWithLatitude: (NSNumber *) _latitude andLongitude: (NSNumber *) _longitude {
    self = [super init];
    if (self) {
        latitude = _latitude;
        longitude = _longitude;
    }
    return self;    
}

@end
