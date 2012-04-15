//
//  NSArrayParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCNSArrayParser.h"
#import "DCSimpleParser.h"

@interface DCNSArrayParser()

@property(nonatomic, strong) DCParserConfiguration *configuration;

@end

@implementation DCNSArrayParser
@synthesize configuration;

- (id)initWithConfiguration:(DCParserConfiguration *)_configuration{
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;   
}

- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute {
    BOOL validValues = ![[[values objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]];
    
    if(validValues){
        DCSimpleParser *simpleParser = [[DCSimpleParser alloc] init];
        NSMutableArray *valuesHolder = [NSMutableArray array];
        for(id value in values){
            DCDynamicAttribute *valueClassAsAttribute = [[DCDynamicAttribute alloc] initWithClass:[value class]];
            [valuesHolder addObject:[simpleParser transformValue:value forDynamicAttribute:valueClassAsAttribute]];
        }
        return [NSArray arrayWithArray:valuesHolder];
    }
    return nil;
}
- (BOOL)canTransformValueForClass:(Class) classe {
    return [classe isSubclassOfClass:[NSArray class]];
}
@end
