//
//  PropertyNameParser.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCPropertyNameParser.h"

@implementation DCPropertyNameParser
@synthesize splitToken;
- (id)initWithSplitToken: (NSString *) _splitToken
{
    self = [super init];
    if (self) {
        splitToken = _splitToken;
    }
    return self;
}

- (NSString *) splitKeyAndMakeCamelcased: (NSString *) key {
    if(!key || [key isEqualToString:@""])
        return @"";
    NSArray *splitedKeys = [key componentsSeparatedByString:splitToken];
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
