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

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass: [self class]] pathForResource:@"artists" ofType:@"json"]];
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
    [config addObjectMapping:nameMapping];
    [config addObjectMapping:idMapping];


    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[SimpleArtist class]
                                                             andConfiguration:config];
    return parser;
}

- (void)testPrimitiveFieldSerialization
{
    DCKeyValueObjectMapping *parser = [self createArtistMapping];

    SimpleArtist *artist = [[SimpleArtist alloc] init];
    artist.id = @"1";
    artist.name = @"The Beatles";

    NSDictionary * serializedArtist = [parser serializeObject:artist];
    STAssertTrue([[serializedArtist objectForKey:@"objectId"] isEqualToString:artist.id], nil);
    STAssertTrue([[serializedArtist objectForKey:@"name"] isEqualToString:artist.name], nil);
}


@end