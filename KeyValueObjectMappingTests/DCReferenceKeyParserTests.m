//
//  DCReferenceKeyParserTests.m
//  DCKeyValueObjectMappingTests
//
//  Created by Diego Chohfi on 4/17/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCReferenceKeyParserTests.h"
#import "DCReferenceKeyParser.h"

@interface DCReferenceKeyParserTests()

@property(nonatomic, strong) DCReferenceKeyParser *parser;

@end

@implementation DCReferenceKeyParserTests
@synthesize parser;

- (void)setUp{
    parser = [DCReferenceKeyParser parserForToken:@"_"];
}

- (void)testPropertyNameParserForSingleWord {
    NSString *word = @"id";
    NSString *splitedWord = [parser splitKeyAndMakeCamelcased:word];

    STAssertEqualObjects(word, splitedWord, @"Should not change the attribute name when it's a single word");
}

- (void) testPropertyNameParserForTwoWords {
    NSString *word = @"id_str";
    NSString *splitedWord = [parser splitKeyAndMakeCamelcased:word];
    
    STAssertEqualObjects(@"idStr", splitedWord, @"Should remove tokens and camelcase the expression");
}

- (void) testPropertyNameParserForThreeWords {
    NSString *word = @"created_time_at";
    NSString *splitedWord = [parser splitKeyAndMakeCamelcased:word];
    
    STAssertEqualObjects(@"createdTimeAt", splitedWord, @"Should remove tokens and camelcase the expression");
}

- (void) testPropertyNameParserForNilOrEmptyWord {
    NSString *nilWord = nil;
    NSString *emptyWord = @"";
    NSString *nilWordSplited = [parser splitKeyAndMakeCamelcased:nilWord];
    NSString *emptyWordSplited = [parser splitKeyAndMakeCamelcased:emptyWord];
    
    STAssertEqualObjects(@"", nilWordSplited, @"Should be empty NSString when the property name passed is nil");
    STAssertEqualObjects(@"", emptyWordSplited, @"Should be empty NSString when the property name passed is an empty NSString");
}

- (void) testWithEmptyToken {
    //this happen when you try parse witout config object and property doesn't exist.
    /* example
      DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [SomeClass class]  andConfiguration:nil];
    */
    parser = [DCReferenceKeyParser parserForToken:nil];
    NSString *NotExistingProperty = @"id";
    STAssertNoThrow([parser splitKeyAndMakeCamelcased:NotExistingProperty], @"shouldn't throw an exception");
}

@end
