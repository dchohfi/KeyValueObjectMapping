//
//  DCReferenceKeyParser.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCReferenceKeyParser.h"

@implementation DCReferenceKeyParser
@synthesize splitToken;

+ (DCReferenceKeyParser *) parserForToken: (NSString *) _splitToken {
    return [[self alloc] initWithSplitToken:_splitToken];
}

- (id)initWithSplitToken: (NSString *) _splitToken
{
    self = [super init];
    if (self) {
        splitToken = _splitToken;
    }
    return self;
}

- (NSString *) splitKeyAndMakeCamelcased: (NSString *) key {
    if(!key || [key isEqualToString:@""] || splitToken == nil)
        return @"";
    NSArray *splitedKeys = [key componentsSeparatedByString:splitToken];
    NSMutableString *parsedKeyName = [NSMutableString string];
    [parsedKeyName appendString:[[splitedKeys objectAtIndex:0] lowercaseString]];
    for(int i=1; i<[splitedKeys count]; i++){
        NSString *splitedKey = [splitedKeys objectAtIndex:i];
        [parsedKeyName appendString:[[splitedKey substringWithRange:NSMakeRange(0, 1)] uppercaseString]];
        [parsedKeyName appendString:[[splitedKey substringFromIndex:1] lowercaseString]];
    }
    return [NSString stringWithString:parsedKeyName];
}

@end
