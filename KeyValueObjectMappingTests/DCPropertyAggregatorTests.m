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
#import "DCDictionaryRearranger.h"
#import "DCPropertyAggregator.h"
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
    
    NSSet *keys = [NSSet setWithObjects:@"latitude", @"longitude", nil];
    DCPropertyAggregator *aggregator = [DCPropertyAggregator aggregateKeys:keys
                                                             intoAttribute:@"location"];
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addAggregator:aggregator];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Bus class]
                                                             andConfiguration:configuration];
    Bus *bus = [parser parseDictionary:dictionaryToParse];
    STAssertNotNil(bus.location, @"Should be able to create a location using aggregator");
    STAssertEqualObjects(bus.name, busName, @"Should be equals");
    STAssertEqualObjects(bus.location.latitude, latitude, @"Should be equals");
    STAssertEqualObjects(bus.location.longitude, longitude, @"Should be equals");
}

- (void) testAggregateMultipleRules {
    NSString *busName = @"R. Dr. Neto De Araujo, 311";
    NSNumber *latitude = [NSNumber numberWithInt:-123];
    NSNumber *longitude = [NSNumber numberWithInt:-321];
    NSNumber *distance = [NSNumber numberWithInt:100];
    NSMutableDictionary *dictionaryToParse = [[NSMutableDictionary alloc] init];
    [dictionaryToParse setObject:busName forKey:@"name"];
    [dictionaryToParse setObject:latitude forKey:@"latitude"];
    [dictionaryToParse setObject:longitude forKey:@"longitude"];
    [dictionaryToParse setObject:distance forKey:@"distance"];

    DCPropertyAggregator *aggregteLatLong = [DCPropertyAggregator aggregateKeys:[NSSet setWithObjects:@"latitude", @"longitude", nil] intoAttribute:@"point"];

    DCPropertyAggregator *aggregatePointDist = [DCPropertyAggregator aggregateKeys:[NSSet setWithObjects:@"point", @"distance", nil] intoAttribute:@"location"];

    DCParserConfiguration* configuration = [DCParserConfiguration configuration];
    [configuration addAggregator:aggregteLatLong];
    [configuration addAggregator:aggregatePointDist];
    NSDictionary *aggregatedDict = [DCDictionaryRearranger rearrangeDictionary:dictionaryToParse forConfiguration:configuration];
    STAssertNotNil(aggregatedDict, @"Should be able to create a location using aggregator");
    STAssertEqualObjects([aggregatedDict objectForKey:@"name"], busName, @"Should be equals");
    STAssertEqualObjects([[aggregatedDict objectForKey:@"location"] objectForKey:@"distance"], distance, @"Should be equals");
    STAssertEqualObjects([[[aggregatedDict objectForKey:@"location"] objectForKey:@"point"] objectForKey:@"latitude"], latitude, @"Should be equals");
    STAssertEqualObjects([[[aggregatedDict objectForKey:@"location"] objectForKey:@"point"] objectForKey:@"longitude"], longitude, @"Should be equals");
}



@end
