//
// Created by Sergey Klimov on 5/31/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <CoreData/CoreData.h>
#import "DCMapperManager.h"
#import "DCKeyValueObjectMapping.h"
#import "DCManagedObjectMapping.h"
#import "DCNSDateConverter.h"
#import "DCForeignKeyConverter.h"
#import "DCNSSetConverter.h"


@implementation DCMapperManager {
    NSDictionary *mappers;
    NSMutableArray *foreignKeysToPopulateWithParsers;
    NSManagedObjectContext *context;
}


- (id<DCValueConverter>) createConverterFromDictionary:(NSDictionary *)converterDict {
    NSString *converterType = [converterDict objectForKey:@"type"];
    NSDictionary *converterOptions = [converterDict objectForKey:@"options"];

    if ([converterType isEqualToString:@"foreignKey"]) {
        DCForeignKeyConverter *foreignKeyConverter = [[DCForeignKeyConverter alloc] initWithParser:nil
                                isNested:[[converterOptions objectForKey:@"isNested"] boolValue]
                       fullSerialization:[[converterOptions objectForKey:@"fullSerialization"] boolValue] ];
        [foreignKeysToPopulateWithParsers addObject:[NSArray arrayWithObjects:foreignKeyConverter,
                                                                    [converterOptions objectForKey:@"class"], nil]];
        return foreignKeyConverter;

    }
    else if ([converterType isEqualToString:@"date"]) {
       return [DCNSDateConverter dateConverterForPattern:[converterOptions valueForKey:@"pattern"]];
    }
    else if ([converterType isEqualToString:@"set"]) {
        return [[DCNSSetConverter alloc] initWithConverter:
                [self createConverterFromDictionary:[converterOptions objectForKey:@"converter"]]];
    }
    else if ([converterType isEqualToString:@"array"]) {
        return [[DCNSArrayConverter alloc] initWithConverter:
                [self createConverterFromDictionary:[converterDict objectForKey:@"converter"]]];
    }
    return nil;

}

- (DCObjectMapping *)createFieldMapperForClass:(Class)class FromDictionary:(NSDictionary *)fieldDict {
    NSString *attribute = [fieldDict objectForKey:@"attribute"];
    NSString *serializedAttribute = [fieldDict objectForKey:@"serializedAttribute"];
    if ([fieldDict objectForKey:@"converter"])
        return [DCObjectMapping mapKeyPath:serializedAttribute toAttribute:attribute onClass:class
                             converter:[self createConverterFromDictionary:[fieldDict objectForKey:@"converter"]]];
    else
        return [DCObjectMapping mapKeyPath:serializedAttribute toAttribute:attribute onClass:class];

}

- (id)createMapperForClass:(Class)class fromDictionary:(NSDictionary *)classDict {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    for (NSDictionary *fieldDict in [classDict objectForKey:@"fields"])
    {
        if ([[fieldDict objectForKey:@"primaryKey"] boolValue])  {
            config.primaryKeyName = [fieldDict objectForKey:@"serializedAttribute"];

        }

        [config addObjectMapping:[self createFieldMapperForClass: class FromDictionary:fieldDict]];
    }


    id result;
    if ([class isSubclassOfClass:[NSManagedObject class]]) {
        result = [DCManagedObjectMapping mapperForClass:[class class]
                andConfiguration:config andManagedObjectContext:context];
    } else {
        result = [DCKeyValueObjectMapping mapperForClass:[class class]
                andConfiguration:config];

    }
    return result;
}

- (id)initWithConfiguration:(NSDictionary *)configurationDictionary
{
    return [self initWithConfiguration:configurationDictionary andManagedObjectContext:nil];
}

- (id)initWithConfiguration:(NSDictionary *)configurationDictionary andManagedObjectContext:(NSManagedObjectContext
*)_context
{
    self = [super init];
    if (self) {
        context = _context;
        NSMutableDictionary *mappersDict = [NSMutableDictionary dictionary];
        foreignKeysToPopulateWithParsers = [NSMutableArray array];
        [configurationDictionary enumerateKeysAndObjectsUsingBlock:
                ^(NSString *className, NSDictionary *classDict, BOOL*stop){
                    Class class = NSClassFromString(className);
                    [mappersDict setObject:[self createMapperForClass:class fromDictionary:classDict]
                            forKey:class];
                }];

        mappers = [NSDictionary dictionaryWithDictionary:mappersDict];

        for (NSArray *keyAndClass in foreignKeysToPopulateWithParsers) {
            DCForeignKeyConverter *foreignKeyConverter = [keyAndClass objectAtIndex:0];
            NSString *className = [keyAndClass objectAtIndex:1];
            foreignKeyConverter.parser = [self mapperForClass:NSClassFromString(className)];
        }
        foreignKeysToPopulateWithParsers = nil;

    }
    return self;
}

- (id)mapperForClass:(Class)class
{
    return [mappers objectForKey:class];
}

- (DCManagedObjectMapping *)managedMapperForClass:(Class)class
{
    return [self mapperForClass:class];
}
@end