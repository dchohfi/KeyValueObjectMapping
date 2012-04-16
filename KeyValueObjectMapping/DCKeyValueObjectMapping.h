//
//  KeyValueObjectMapping.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCParserConfiguration.h"

@interface DCKeyValueObjectMapping : NSObject

- (id) initWithConfiguration: (DCParserConfiguration *) configuration;
- (id) parseDictionary: (NSDictionary *) dictionary forClass: (Class) class;
- (id) parseArray: (NSArray *) array forClass: (Class) class;

@end
