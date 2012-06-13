//
//  DCNSSetConverter.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 6/13/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCValueConverter.h"

@class DCParserConfiguration;
@interface DCNSSetConverter : NSObject <DCValueConverter>

+ (DCNSSetConverter *) setConverterForConfiguration: (DCParserConfiguration *) configuration;

@end
