//
//  ParserConfiguration.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCParserConfiguration.h"

@implementation DCParserConfiguration
@synthesize datePattern, splitToken;

- (id)init
{
    self = [super init];
    if (self) {
        self.splitToken = @"_";
        self.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    }
    return self;
}
@end
