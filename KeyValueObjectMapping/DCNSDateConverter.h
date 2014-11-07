//
//  DCNSDateConverter.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCValueConverter.h"
@interface DCNSDateConverter : NSObject <DCValueConverter>

+ (DCNSDateConverter *) dateConverterForPattern: (NSString *) pattern locale:(NSLocale *)locale;

@end
