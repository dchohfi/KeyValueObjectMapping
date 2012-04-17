//
//  DCPropertyFinder.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/17/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDynamicAttribute.h"
#import "DCPropertyNameParser.h"

@interface DCPropertyFinder : NSObject

+ (DCPropertyFinder *) finderWithNameParser: (DCPropertyNameParser *) _nameParser ;
- (DCDynamicAttribute *) findAttributeForKey: (NSString *) key onClass: (Class) class;

@end
