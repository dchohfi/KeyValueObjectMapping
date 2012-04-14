//
//  ParserConfiguration.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "ParserConfiguration.h"

@implementation ParserConfiguration
@synthesize datePattern, splitToken;
- (NSString *)splitToken{
    if (splitToken) {
        return splitToken;
    }else{
        return @"_";
    }
}
@end
