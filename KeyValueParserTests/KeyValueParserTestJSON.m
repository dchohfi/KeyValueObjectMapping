//
//  KeyValueParserTestJSON.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueParserTestJSON.h"
#import "DCKeyValueParser.h"
#import "DCParserConfiguration.h"
#import "Tweet.h"
#import "User.h"
@interface KeyValueParserTestJSON()

@property(nonatomic, strong) NSMutableDictionary *jsonParsed;

@end

@implementation KeyValueParserTestJSON
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

    DCKeyValueParser * parser = [[DCKeyValueParser alloc] initWithConfiguration:config];
    
    Tweet *tweet = [parser parseJson:jsonParsed forClass:[Tweet class]];
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

@end