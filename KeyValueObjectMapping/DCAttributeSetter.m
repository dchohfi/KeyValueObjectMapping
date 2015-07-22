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
    
    if ([value isKindOfClass:[NSNull class]]) {
        
        value = nil;
    }
    
    if([object validateValue:&value forKey:attributeName error:nil]){
        
        if(([value isKindOfClass:[NSNull class]] || value == nil) && attributeClass == [NSString class]){
            [object setValue:nil forKey:attributeName];
        }else {
            @try {
                [object setValue:value forKey:attributeName];
            }
            @catch (NSException *e) {
                [object setValue:@(0) forKey:attributeName];
            }
        }
    }
}

@end
