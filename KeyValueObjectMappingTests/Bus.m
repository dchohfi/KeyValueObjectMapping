//
//  Bus.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "Bus.h"

@implementation Bus
@synthesize name, location;

-(id)initWithName: (NSString *) _name andLocation: (Location *) _location {
    self = [super init];
    if (self) {
        name = _name;
        location = _location;
    }
    return self;
}

@end