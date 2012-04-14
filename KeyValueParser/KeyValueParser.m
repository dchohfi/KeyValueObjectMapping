//
//  KeyValueParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueParser.h"
#import "GenericParser.h"
#import "DynamicAttribute.h"
#import <objc/runtime.h>

@interface KeyValueParser()
@property(nonatomic, strong) ParserConfiguration *configuration;
@end

@implementation KeyValueParser
@synthesize configuration;

- (id) initWithConfiguration: (ParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;   
}
- (id) parseJson: (NSDictionary *) json forClass: (Class) class{
    NSObject *object = [[class alloc] init];
    NSArray *keys = [json allKeys];
    GenericParser *parser = [[GenericParser alloc] init];
    for (NSString *key in keys) {
        id value = [json valueForKey:key];
        objc_property_t property = class_getProperty(class, [key UTF8String]);
        if (property) {
            NSString *attributeDetails = [NSString stringWithUTF8String:property_getAttributes(property)];
            DynamicAttribute *dynamicAttribute = [[DynamicAttribute alloc] initWithAttributeDescription: attributeDetails];
            if([value isKindOfClass:[NSDictionary class]]){
                value = [self parseJson:(NSDictionary *) value forClass:[dynamicAttribute attributeClass]];
            }
            value = [parser transformValue:value forClass:[dynamicAttribute attributeClass] withConfiguration:configuration];
            NSError *error;
            if([object validateValue:&value forKey:key error:&error]){
                [object setValue:value forKey:key];
            }
        }
    }
    return object;
}

@end
