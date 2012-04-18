//
//  DCArrayOfTweetsOnUserTests.m
//  DCKeyValueObjectMappingTests
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCArrayOfTweetsOnUserTests.h"
#import "DCKeyValueObjectMapping.h"
#import "Tweet.h"
#import "User.h"

@interface DCArrayOfTweetsOnUserTests()

@property(nonatomic, strong) NSMutableDictionary *jsonParsed;

@end

@implementation DCArrayOfTweetsOnUserTests
@synthesize jsonParsed;

-(void)setUp{
    [super setUp];
    NSString *caminhoJson = [[NSBundle bundleForClass: [self class]] pathForResource:@"user" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:caminhoJson];
    
    NSError *error;
    jsonParsed = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers error:&error];
}

- (void)testShouldCreateAnUserWithTweets {
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[Tweet class] forAttribute:@"tweets" onClass:[User class]];
    DCParserConfiguration *configuration = [[DCParserConfiguration alloc] init];
    [configuration addArrayMapper:mapper];
    
    DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:configuration];
    User *user = [parser parseDictionary:jsonParsed forClass:[User class]];
    STAssertNotNil(user.tweets, @"Tweets should not be nil");
    STAssertEquals((int)user.tweets.count, 2, @"Should have 2 tweets on array of tweets");
}

@end
