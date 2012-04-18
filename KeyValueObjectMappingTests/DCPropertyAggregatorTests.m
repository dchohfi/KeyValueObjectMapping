//
//  DCPropertyAggregatorTests.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/18/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCPropertyAggregatorTests.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"
#import "Bus.h"
@implementation DCPropertyAggregatorTests

- (void) testAggregateProperties {
    NSString *busName = @"R. Dr. Neto De Araujo, 311";
    NSNumber *latitude = [NSNumber numberWithInt:-123];
    NSNumber *longitude = [NSNumber numberWithInt:-321];
    NSMutableDictionary *dictionaryToParse = [[NSMutableDictionary alloc] init];
    [dictionaryToParse setObject:busName forKey:@"name"];
    [dictionaryToParse setObject:latitude forKey:@"latitude"];
    [dictionaryToParse setObject:longitude forKey:@"longitude"];
    
    DCPropertyAggregator *aggregator = [DCPropertyAggregator aggregateKeys:[NSSet setWithObjects:@"latitude", @"longitude", nil] intoAttribute:@"location"];
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addAggregator:aggregator];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Bus class] andConfiguration:configuration];
    Bus *bus = [parser parseDictionary:dictionaryToParse];
    STAssertNotNil(bus.location, @"Should be able to create a location using aggregator");
    STAssertEqualObjects(bus.name, busName, @"Should be equals");
    STAssertEquals(bus.location.latitude, latitude, @"Should be equals");
    STAssertEquals(bus.location.longitude, longitude, @"Should be equals");
}



@end
