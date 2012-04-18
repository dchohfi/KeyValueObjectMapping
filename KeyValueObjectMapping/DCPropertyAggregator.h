//
//  DCPropertyAggregator.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCPropertyAggregator : NSObject

@property(nonatomic, readonly) NSSet *keysToAggregate;
@property(nonatomic, readonly) NSString *attribute;

+ (DCPropertyAggregator *) aggregateKeys: (NSSet *) keys intoAttribute: (NSString *) attribute;

- (NSDictionary *) aggregateKeysOnDictionary: (NSDictionary *) baseDictionary;

@end
