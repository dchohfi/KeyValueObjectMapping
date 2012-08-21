//
//  DCPropertyAggregator.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCPropertyAggregator.h"

@implementation DCPropertyAggregator
@synthesize keysToAggregate = _keysToAggregate;
@synthesize attribute = _attribute;

+ (DCPropertyAggregator *) aggregateKeys: (NSSet *) keys intoAttribute: (NSString *) attribute {
    return [[self alloc] initWithKeysToAggregate:keys intoAttribute:attribute];
}

- (id)initWithKeysToAggregate: (NSSet *) keysToAggregate intoAttribute: (NSString *) attribute  {
    self = [super init];
    if (self) {
        _keysToAggregate = keysToAggregate;
        _attribute = attribute;
    }
    return self;
}

- (NSDictionary *) aggregateKeysOnDictionary: (NSDictionary *) baseDictionary {
    NSMutableDictionary *aggregateHolder = [[NSMutableDictionary alloc] init];
    for (NSString *key in baseDictionary) {
        if([self.keysToAggregate containsObject:key]){
            [aggregateHolder setValue:[baseDictionary objectForKey:key] forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:aggregateHolder];
}

@end
