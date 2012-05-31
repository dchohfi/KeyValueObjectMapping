//
// Created by Sergey Klimov on 5/30/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCForeignKeyConverter.h"
#import "DCKeyValueObjectMapping.h"

@implementation DCForeignKeyConverter {

}
@synthesize fullSerialization,parser;


- (id) initWithParser:(DCKeyValueObjectMapping*) _parser fullSerialization: (BOOL) _fullSerialization {
    self = [super init];
    if (self) {
        parser = _parser;
        fullSerialization = _fullSerialization;
    }
    return self;
}
- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute
{
    id result =  [parser findObjectByPrimaryKeyValue:value];
    if (!result) {
        result = [parser createObjectWithPrimaryKeyValue:value];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDCKeyValueObjectMappingObjectLazyCreateNotification object:nil
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         parser.classToGenerate, @"class",
                                                         value, @"primaryKey"
                                                                                  ,nil]];

    }
    return result;
}


- (id) serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return [parser serializeObject:value];
}

- (BOOL)canTransformValueForClass:(Class)class
{
    return YES; //fixme
}


@end