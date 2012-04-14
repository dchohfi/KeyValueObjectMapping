//
//  KeyValueParserTestJSON.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueParserTestJSON.h"
#import "KeyValueParser.h"
#import "ParserConfiguration.h"
#import "Tweet.h"
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
    ParserConfiguration *config = [[ParserConfiguration alloc] init];
    config.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    
    KeyValueParser * parser = [[KeyValueParser alloc] initWithConfiguration:config];
    Tweet *tweet = [parser parseJson:jsonParsed forClass:[Tweet class]];
    
}

@end
