//
//  DCPropertyFinder.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/17/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDynamicAttribute.h"
#import "DCReferenceKeyParser.h"

@interface DCPropertyFinder : NSObject

@property(nonatomic, strong) NSArray *mappers;

+ (DCPropertyFinder *) finderWithKeyParser: (DCReferenceKeyParser *) keyParser;
- (DCDynamicAttribute *) findAttributeForKey: (NSString *) key 
                                     onClass: (Class) className;

@end
