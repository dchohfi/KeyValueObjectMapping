//
//  DCCustomInitializeTest.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 8/21/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCCustomInitializeTest.h"
#import "DCCustomInitialize.h"
#import "Tweet.h"
#import "Person.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation DCCustomInitializeTest

- (void)testShouldCreateAnDCCustomInitialize {
    DCCustomInitializeBlock customBlock = ^(__weak Class classOfObjectToGenerate, NSDictionary *values, id parentObject) {
        return [[classOfObjectToGenerate alloc] init];
    };
    DCCustomInitialize *customInitialize = [[DCCustomInitialize alloc] initWithBlockInitialize:customBlock forClass:[Tweet class]];
    BOOL valid = [customInitialize isValidToPerformBlock:[Tweet class]];
    BOOL invalid = [customInitialize isValidToPerformBlock:[Person class]];
    STAssertTrue(valid, @"should be valid to perform block on a tweet class");
    STAssertFalse(invalid, @"shouldn't be valid to perform block on a person class");
}


- (void)testShouldRetrieveParentObject {
    
    NSString *jsonPath = [[NSBundle bundleForClass: [self class]] pathForResource:@"tweet" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = config.datePattern;
    
    DCKeyValueObjectMapping * parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:config];
    
    
    __block Tweet *parentTweet;
    DCCustomInitializeBlock customBlock = ^(__weak Class classOfObjectToGenerate, NSDictionary *values, id parentObject) {
        id object = [[classOfObjectToGenerate alloc] init];
        parentTweet = parentObject;
        return object;
    };
    DCCustomInitialize *customInitialize = [[DCCustomInitialize alloc] initWithBlockInitialize:customBlock forClass:[User class]];
    [config addCustomInitializersObject:customInitialize];
    
    [parser parseDictionary:json];
    
    NSLog(@"%@", [parentTweet idStr]);
    STAssertTrue([[parentTweet idStr] isEqualToString:@"190957570511478784"], @"idStr should be 190957570511478784");
}

@end