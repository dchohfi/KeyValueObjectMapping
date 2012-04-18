//
//  DCDictionaryRearranger.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCDictionaryRearranger : NSObject

+ (NSDictionary *) rearrangeDictionary: (NSDictionary *) dictionary forAggregators: (NSMutableArray *) aggregators;

@end
