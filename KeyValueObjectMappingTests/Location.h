//
//  Location.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property(nonatomic, readonly) NSDecimalNumber *latitude;
@property(nonatomic, readonly) NSDecimalNumber *longitude;

@end
