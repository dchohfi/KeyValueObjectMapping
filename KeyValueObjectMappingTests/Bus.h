//
//  Bus.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Bus : NSObject

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) Location *location;

-(id)initWithName: (NSString *)name andLocation: (Location *) location;

@end
