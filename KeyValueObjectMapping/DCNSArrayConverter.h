//
//  DCNSArrayConverter.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCValueConverter.h"

@class DCParserConfiguration;
@class DCKeyValueObjectMapping;

@interface DCNSArrayConverter : NSObject <DCValueConverter>


@property (strong, readonly) id <DCValueConverter> converter;


+ (DCNSArrayConverter *) arrayConverterForConfiguration: (DCParserConfiguration *)configuration;

- (id)initWithConverter:(id <DCValueConverter>)_converter;

@end
