//
//  DCParserConfigurationTest.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 8/21/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCParserConfigurationTest.h"
#import "DCParserConfiguration.h"
#import "DCCustomInitialize.h"
#import "Tweet.h"
#import "User.h"
@implementation DCParserConfigurationTest

- (void) testCreateCustomTweetWithBlock {
    DCCustomInitializeBlock block = ^id(__weak Class classToGenerate, NSDictionary *values, id parentObject){
        STAssertEquals(classToGenerate, [Tweet class], @"classToGenerate should be an tweet");
        Tweet *tweet = [[Tweet alloc] init];
        tweet.text = @"Should be an text";
        return tweet;
    };
    
    DCCustomInitialize *initializer = [[DCCustomInitialize alloc] initWithBlockInitialize:block
                                                                                 forClass:[Tweet class]];
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addCustomInitializersObject:initializer];
    
    Tweet *tweet = [configuration instantiateObjectForClass:[Tweet class] withValues:nil];
    STAssertTrue([tweet.text isEqualToString: @"Should be an text"], @"should have the same text passed on custom initialize");
}

- (void) testCreateObjectWithNormalInitialize {
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    
    Tweet *tweet = [configuration instantiateObjectForClass:[Tweet class] withValues:nil];
    STAssertNotNil(tweet, @"should create an tweet when no custom initialize is used");
}

- (void) testWrongSplitTocken {
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    configuration.splitToken = @".";
    STAssertFalse([configuration.splitToken isEqualToString:@"."], @"splitToken value should not have change");
    
    configuration.nestedPrepertiesSplitToken = @"|";
    configuration.splitToken = @".";
    STAssertTrue([configuration.splitToken isEqualToString:@"."], @"splitToken value should have change");
}

@end
