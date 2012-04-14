//
//  NSArrayParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "NSArrayParser.h"
#import "SimpleParser.h"

@interface NSArrayParser()

@property(nonatomic, strong) ParserConfiguration *configuration;

@end

@implementation NSArrayParser
@synthesize configuration;

- (id)initWithConfiguration:(ParserConfiguration *)_configuration{
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;   
}

- (id)transformValue:(id)values forDynamicAttribute:(DynamicAttribute *)attribute {
    BOOL validValues = ![[[values objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]];
    
    if(validValues){
        SimpleParser *simpleParser = [[SimpleParser alloc] init];
        NSMutableArray *valuesHolder = [NSMutableArray array];
        for(id value in values){
            DynamicAttribute *valueClassAsAttribute = [[DynamicAttribute alloc] initWithClass:[value class]];
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
