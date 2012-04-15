//
//  KeyValueParser.h
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCParserConfiguration.h"

@interface DCKeyValueParser : NSObject

- (id) initWithConfiguration: (DCParserConfiguration *) configuration;
- (id) parseJson: (NSDictionary *) json forClass: (Class) class;

@end
