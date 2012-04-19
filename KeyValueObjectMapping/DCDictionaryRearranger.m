//
//  DCDictionaryRearranger.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCDictionaryRearranger.h"
#import "DCPropertyAggregator.h"

@implementation DCDictionaryRearranger


+ (NSDictionary *) rearrangeDictionary: (NSDictionary *) dictionary forAggregators: (NSMutableArray *) aggregators {
    aggregators = [NSMutableArray arrayWithArray:[[aggregators reverseObjectEnumerator] allObjects]];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if(aggregators && [aggregators count] > 0){
        for(int i=[aggregators count] - 1; i >= 0; --i){
            DCPropertyAggregator *aggretor = [aggregators objectAtIndex:i];
            [aggregators removeObject:aggretor];
            NSDictionary *aggregatedValues = [aggretor aggregateKeysOnDictionary:mutableDictionary];
            [mutableDictionary setValue:aggregatedValues forKey:aggretor.attribute];
        }
    }
    return mutableDictionary;
}

@end
