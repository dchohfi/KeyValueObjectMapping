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
@implementation DCCustomInitializeTest

- (void) testShouldCreateAnDCCustomInitialize {
    DCCustomInitializeBlock customBlock = ^(__weak Class classOfObjectToGenerate, NSDictionary *values) {
        return [[classOfObjectToGenerate alloc] init];
    };
    DCCustomInitialize *customInitialize = [[DCCustomInitialize alloc] initWithBlockInitialize:customBlock forClass:[Tweet class]];
    BOOL valid = [customInitialize validToPerformBlock:[Tweet class]];
    BOOL invalid = [customInitialize validToPerformBlock:[Person class]];
    STAssertTrue(valid, @"should be valid to perform block on a tweet class");
    STAssertFalse(invalid, @"shouldn't be valid to perform block on a person class");
}

@end