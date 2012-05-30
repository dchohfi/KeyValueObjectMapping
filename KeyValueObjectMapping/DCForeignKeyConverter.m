//
// Created by Sergey Klimov on 5/30/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCForeignKeyConverter.h"
#import "DCKeyValueObjectMapping.h"

@implementation DCForeignKeyConverter {

}
- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute
{
    DCKeyValueObjectMapping *parser = attribute.objectMapping.parser;
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

- (BOOL)canTransformValueForClass:(Class)class
{
    return YES; //fixme
}


@end