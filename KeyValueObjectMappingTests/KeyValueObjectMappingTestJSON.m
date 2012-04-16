//
//  KeyValueObjectMappingTestJSON.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueObjectMappingTestJSON.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"
#import "Tweet.h"
#import "User.h"
@interface KeyValueObjectMappingTestJSON()

@property(nonatomic, strong) NSMutableDictionary *jsonParsed;

@end

@implementation KeyValueObjectMappingTestJSON
@synthesize jsonParsed;

-(void)setUp{
    [super setUp];
    NSString *caminhoJson = [[NSBundle bundleForClass: [self class]] pathForResource:@"tweet" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:caminhoJson];
    
    NSError *error;
    jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers error:&error];
}

-(void) testCreateFromJson {
    DCParserConfiguration *config = [[DCParserConfiguration alloc] init];
    config.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = config.datePattern;
    NSDate *data = [formatter dateFromString:@"Sat Apr 14 00:20:07 +0000 2012"];

    DCKeyValueObjectMapping * parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:config];
    
    Tweet *tweet = [parser parseDictionary:jsonParsed forClass:[Tweet class]];
    STAssertEqualObjects(tweet.idStr, @"190957570511478784", @"Should have same idStr");
    STAssertEqualObjects(tweet.text, @"@pedroh96 cara, comecei uma lib pra iOS, se puder dar uma olhada e/ou contribuir :D KeyValue Parse for Objective-C https://t.co/NWMMc60v", @"Should have same text");
    STAssertEqualObjects(tweet.source, @"<a href=\"http://www.osfoora.com/mac\" rel=\"nofollow\">Osfoora for Mac</a>", @"Should have same source");
    STAssertNil(tweet.inReplyToStatusIdStr, @"inRepryToStatusIdStr should be null");
    STAssertEquals(tweet.retweetCount, [NSNumber numberWithInt: 0], @"RetweetCount should be equals to 0");
    STAssertFalse(tweet.favorited, @"favorited should be false");
    STAssertFalse(tweet.retweeted, @"favorited should be false");
    STAssertEqualObjects(tweet.createdAt, data, @"CreatedAt should be equals");
    
    data = [formatter dateFromString:@"Tue Mar 31 18:01:12 +0000 2009"];
    
    User *user = tweet.user;
    STAssertEqualObjects(user.idStr, @"27924446", @"Should have same idStr for user");
    STAssertEqualObjects(user.name, @"Diego Chohfi", @"Should have same user name");
    STAssertEqualObjects(user.screenName, @"dchohfi", @"Should have same user screenName");
    STAssertEqualObjects(user.location, @"São Paulo", @"Should have same user location");
    STAssertEqualObjects(user.description, @"Instrutor na @Caelum, desenvolvedor de coração, apaixonado por música e cerveja, sempre cerveja.", @"Should have same user description");
    STAssertEqualObjects(user.url, [NSURL URLWithString:@"http://about.me/dchohfi"], @"Should have same user url");
    STAssertFalse(user.protected, @"User should be protected");
    STAssertEquals(user.followersCount, (long)380, @"Should have 380 followersCount");
    STAssertEquals(user.friendsCount, (long)183, @"Should have 183 friendsCount");
    STAssertEqualObjects(user.createdAt, data, @"Should have same createdAt date");
}

- (void)testMultipleTweets{
    Class tweetClass = [Tweet class];
    
    NSArray *arrayTweets = [NSArray arrayWithObjects:jsonParsed, jsonParsed, jsonParsed, nil];
    DCParserConfiguration *configuration = [[DCParserConfiguration alloc] init];
    configuration.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:configuration];
    NSArray *parsedArray = [parser parseArray:arrayTweets forClass:tweetClass];
    
    STAssertEquals((int)[parsedArray count], 3, @"Should have same size of tweets");
    STAssertTrue([parsedArray isKindOfClass:[NSArray class]], @"Should be a NSArray");
    STAssertFalse([parsedArray isKindOfClass:[NSMutableArray class]], @"Should not be a NSMutableArray");
    
    [parsedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STAssertEquals(tweetClass, [obj class], @"Should be a Tweet");
    }];
}

- (void)testArrayOfSpecific{
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionaryWithDictionary:[jsonParsed objectForKey:@"user"]];
    [jsonParsed removeObjectForKey:@"user"];
    
    NSArray *tweetsForUser = [NSArray arrayWithObjects:jsonParsed, jsonParsed, nil];
    [userDictionary setObject:tweetsForUser forKey:@"tweets"];
    
    
    DCParserConfiguration *configuration = [[DCParserConfiguration alloc] init];
    configuration.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    DCObjectMapping *mapping = [[DCObjectMapping alloc] initWithAttributeName:@"tweets" forKey:@"tweets" onClass:[User class]];
    
    [configuration addMapper:[[DCObjectMappingForArray alloc] initWithObjectMapping:mapping forArrayElementOfType:[Tweet class]]];
    DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:configuration];
    User *user = [parser parseDictionary:userDictionary forClass:[User class]];
    STAssertEquals((int)[user.tweets count], 2, @"Should have same Tweets array size");
}
@end