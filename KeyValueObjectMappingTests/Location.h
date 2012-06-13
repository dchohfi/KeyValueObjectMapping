//
//  Location.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property(nonatomic, readonly) NSNumber *latitude;
@property(nonatomic, readonly) NSNumber *longitude;

-(id)initWithLatitude: (NSNumber *) latitude andLongitude: (NSNumber *) longitude;

@end
