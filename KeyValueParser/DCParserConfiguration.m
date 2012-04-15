//
//  ParserConfiguration.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCParserConfiguration.h"

@implementation DCParserConfiguration
@synthesize datePattern, splitToken;
- (NSString *)splitToken{
    if (splitToken) {
        return splitToken;
    }else{
        return @"_";
    }
}
@end
