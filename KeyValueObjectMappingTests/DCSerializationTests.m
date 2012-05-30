//
// Created by Sergey Klimov on 5/30/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCSerializationTests.h"
#import "DCKeyValueObjectMapping.h"
#import "SimpleArtist.h"


@implementation DCSerializationTests {

    NSArray *artistsFixture;
}

- (void)setUp
{

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass: [self class]]
                                                          pathForResource:@"simpleArtists" ofType:@"json"]];
    NSError *error;
    artistsFixture = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers error:&error];
}

- (DCKeyValueObjectMapping *)createArtistMapping
{
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.primaryKeyName = @"objectId";

    DCObjectMapping *nameMapping = [DCObjectMapping mapKeyPath:@"name" toAttribute:@"name" onClass:[SimpleArtist class]];
    DCObjectMapping *idMapping = [DCObjectMapping mapKeyPath:@"objectId" toAttribute:@"id" onClass:[SimpleArtist class]];
    DCObjectMapping *dateMapping = [DCObjectMapping mapKeyPath:@"birthday" toAttribute:@"birthday" onClass:[SimpleArtist
                                                                                                          class]];
    DCObjectMapping *homePageURLMapping = [DCObjectMapping mapKeyPath:@"homePageURL" toAttribute:@"homePageURL"
                                                       onClass:[SimpleArtist class]];
    DCObjectMapping *numberIntegerMapping = [DCObjectMapping mapKeyPath:@"numberInteger" toAttribute:@"numberInteger"
                                                              onClass:[SimpleArtist class]];

    DCObjectMapping *numberFloatMapping = [DCObjectMapping mapKeyPath:@"numberFloat" toAttribute:@"numberFloat"
                                                                    onClass:[SimpleArtist class]];
    [config addObjectMapping:nameMapping];
    [config addObjectMapping:idMapping];
    [config addObjectMapping:dateMapping];
    [config addObjectMapping:homePageURLMapping];
    [config addObjectMapping:numberIntegerMapping];
    [config addObjectMapping:numberFloatMapping];


    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[SimpleArtist class]
                                                             andConfiguration:config];
    return parser;
}

- (void)testSimpleFieldSerialization
{
    DCKeyValueObjectMapping *parser = [self createArtistMapping];

    SimpleArtist *artist = [[SimpleArtist alloc] init];
    artist.id = @"1";
    artist.name = @"The Beatles";

    NSDictionary * serializedArtist = [parser serializeObject:artist];
    STAssertTrue([[serializedArtist objectForKey:@"objectId"] isEqualToString:artist.id], nil);
    STAssertTrue([[serializedArtist objectForKey:@"name"] isEqualToString:artist.name], nil);
}



- (void)testPrimitiveFieldSerializationSanity
{
    DCKeyValueObjectMapping *parser = [self createArtistMapping];

    NSDictionary * artistFixture = [artistsFixture lastObject];
    SimpleArtist *artist = [parser parseDictionary:artistFixture];


    NSDictionary * serializedArtist = [parser serializeObject:artist];
//    STAssertTrue([serializedArtist allKeys].count== [artistFixture allKeys].count, nil);

    STAssertTrue([[serializedArtist objectForKey:@"objectId"] isEqualToString:
            [artistFixture objectForKey:@"objectId"]], nil);
    STAssertTrue([[serializedArtist objectForKey:@"name"] isEqualToString:
            [artistFixture objectForKey:@"name"]], nil);
    STAssertTrue([[serializedArtist objectForKey:@"homePageURL"] isEqualToString:
        [artistFixture objectForKey:@"homePageURL"]], nil);
    STAssertTrue([[serializedArtist objectForKey:@"birthday"] isEqualToString:
        [artistFixture objectForKey:@"birthday"]], nil);
    STAssertTrue([[serializedArtist objectForKey:@"numberInteger"] isEqualToNumber:
        [artistFixture objectForKey:@"numberInteger"]], nil);
    STAssertTrue([[serializedArtist objectForKey:@"numberFloat"] isEqualToNumber:
        [artistFixture objectForKey:@"numberFloat"]], nil);

//    STAssertTrue([[serializedArtist objectForKey:@"primitiveArray"] isEqualToArray:
//        [artistFixture objectForKey:@"primitiveArray"]], nil);

}




@end