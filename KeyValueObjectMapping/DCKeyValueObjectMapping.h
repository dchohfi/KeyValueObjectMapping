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
- (id) parseJson: (NSDictionary *) json forClass: (Class) class;

@end
