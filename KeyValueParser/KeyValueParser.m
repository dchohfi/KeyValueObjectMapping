//
//  KeyValueParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueParser.h"
#import "GenericParser.h"
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
            NSString *className = [NSString stringWithUTF8String:getPropertyType(property)];
            Class propertyClass = NSClassFromString(className);
            if([value isKindOfClass:[NSDictionary class]]){
                value = [self parseJson:(NSDictionary *) value forClass:propertyClass];
            }
            value = [parser transformValue:value forClass:propertyClass withConfiguration:configuration];
            NSError *error;
            if([object validateValue:&value forKey:key error:&error]){
                [object setValue:value forKey:key];
            }
        }
    }
    return object;
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }        
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

@end
