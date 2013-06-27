//
//  DCCustomParserTests.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 9/3/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCCustomParserTests.h"
#import "DCCustomParser.h"
#import "User.h"
#import "Tweet.h"
@implementation DCCustomParserTests

- (void) testShouldCreateAnDCCustomInitialize {
    DCCustomParserBlock customBlock = ^(__weak NSDictionary *dictionary, __weak NSString *attributeName, __weak Class destinationClass, __weak id value){
        return value;
    };
    DCCustomParser *customParser = [[DCCustomParser alloc] initWithBlockParser:customBlock
                                                              forAttributeName:@"user_name"
                                                            onDestinationClass:[User class]];
                                    
    BOOL valid = [customParser isValidToPerformBlockOnAttributeName:@"user_name" forClass:[User class]];
    BOOL invalid = [customParser isValidToPerformBlockOnAttributeName:@"user_name" forClass:[Tweet class]];
    STAssertTrue(valid, @"should be valid to perform block on a tweet class");
    STAssertFalse(invalid, @"shouldn't be valid to perform block on a person class");
}


@end
