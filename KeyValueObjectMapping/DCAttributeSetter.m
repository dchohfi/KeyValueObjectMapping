//
//  DCAttributeSetter.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCAttributeSetter.h"

@implementation DCAttributeSetter

+ (void)assingValue:(id)value forAttributeName: (NSString *)attributeName andAttributeClass: (Class) attributeClass onObject:(id)object {
    if([object validateValue:&value forKey:attributeName error:nil]){
        if([value isKindOfClass:[NSNull class]]){
            value = nil;
        }
        if(([value isKindOfClass:[NSNull class]] || value == nil) && attributeClass == [NSString class]){
            [object setValue:nil forKey:attributeName];
        }else {
            [object setValue:value forKey:attributeName];
        }
    }
}

@end
