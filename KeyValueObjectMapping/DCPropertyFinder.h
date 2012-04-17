//
//  DCPropertyFinder.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/17/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDynamicAttribute.h"
#import "DCReferenceKeyParser.h"

@interface DCPropertyFinder : NSObject

+ (DCPropertyFinder *) finderWithKeyParser: (DCReferenceKeyParser *) keyParser;
- (DCDynamicAttribute *) findAttributeForKey: (NSString *) key onClass: (Class) className;
- (void) setMappers: (NSArray *) mappers;


@end
