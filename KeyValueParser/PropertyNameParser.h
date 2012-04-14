//
//  PropertyNameParser.h
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserConfiguration.h"

@interface PropertyNameParser : NSObject
- (id)initWithConfiguration: (ParserConfiguration *) configuration;
- (NSString *) splitKeyAndMakeCamelcased: (NSString *) key;
@end
