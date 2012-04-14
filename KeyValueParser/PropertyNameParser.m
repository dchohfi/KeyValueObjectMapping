//
//  PropertyNameParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "PropertyNameParser.h"

@interface PropertyNameParser()

@property(nonatomic, strong) ParserConfiguration *configuration;

@end

@implementation PropertyNameParser
@synthesize configuration;
- (id)initWithConfiguration: (ParserConfiguration *) _configuration
{
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;
}

- (NSString *) splitKeyAndMakeCamelcased: (NSString *) key {
    NSArray *splitedKeys = [key componentsSeparatedByString:configuration.splitToken];
    NSMutableString *parsedKeyName = [NSMutableString string];
    [parsedKeyName appendString:[[splitedKeys objectAtIndex:0] lowercaseString]];
    for(int i=1; i<[splitedKeys count]; i++){
        NSString *splitedKey = [splitedKeys objectAtIndex:i];
        [parsedKeyName appendString:[[splitedKey substringWithRange:NSMakeRange(0, 1)] uppercaseString]];
        [parsedKeyName appendString:[[splitedKey substringFromIndex:1] lowercaseString]];
    }
    return [NSString stringWithFormat:parsedKeyName];
}

@end
