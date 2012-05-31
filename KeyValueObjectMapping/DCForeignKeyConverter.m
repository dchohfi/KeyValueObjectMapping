//
// Created by Sergey Klimov on 5/30/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCForeignKeyConverter.h"
#import "DCKeyValueObjectMapping.h"
#import "DCDynamicAttribute.h"

@implementation DCForeignKeyConverter {

}
@synthesize isNested, fullSerialization, parser;




- (id) initWithParser:(DCKeyValueObjectMapping*) _parser isNested:(BOOL)_isNested fullSerialization: (BOOL)
        _fullSerialization {
    self = [super init];
    if (self) {
        parser = _parser;
        isNested = _isNested;
        fullSerialization = _fullSerialization;
    }
    return self;
}

- (id)initWithParser:(DCKeyValueObjectMapping *)_parser fullSerialization:(BOOL)_fullSerialization
{
    return [self initWithParser:_parser isNested:NO fullSerialization:_fullSerialization];
}

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute
{
    id result;
    if (!isNested) {
        NSString *primaryKey = value;
        result =  [parser findObjectByPrimaryKeyValue:primaryKey];
        if (!result) {
            result = [parser createObjectWithPrimaryKeyValue:primaryKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDCKeyValueObjectMappingObjectLazyCreateNotification object:nil
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                      parser.classToGenerate, @"class",
                                                                      value, @"primaryKey"
                                                                               ,nil]];

        }

    } else {
        result = [parser parseDictionary:value];
    }
    return result;
}


- (id) serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    if (fullSerialization)
        return [parser serializeObject:value];
    else
        return [value valueForKeyPath:parser.primaryKeyAttribute.objectMapping.attributeName];
}

- (BOOL)canTransformValueForClass:(Class)class
{
    return YES; //fixme
}


@end