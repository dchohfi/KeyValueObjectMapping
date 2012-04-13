//
//  NSArrayParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "NSArrayParser.h"
#import "GenericParser.h"

@interface NSArrayParser()

@property(nonatomic, strong)ParserConfiguration *configuration;

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

- (id)transformValue:(id)values{
    BOOL validValues = ![[[values objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]];
    
    if(validValues){
        GenericParser *genericParser = [[GenericParser alloc] init];
        NSMutableArray *valuesHolder = [NSMutableArray array];
        for(id value in values){
            NSLog(@"VALOR DO ARRAY %@", value);
            Class valueClass = [value class];
            [valuesHolder addObject:[genericParser transformValue:value forClass:valueClass withConfiguration:configuration]];
        }
        return [NSArray arrayWithArray:valuesHolder];
    }
    return nil;
}
- (BOOL)canTransformValueForClass:(Class) classe {
    return [classe isSubclassOfClass:[NSArray class]];
}
@end
