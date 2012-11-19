//
//  Tweet.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
@synthesize createdAt;
@synthesize idStr;
@synthesize text;
@synthesize source;
@synthesize truncated;
@synthesize inReplyToStatusIdStr;
@synthesize inReplyToUserIdStr;
@synthesize inReplyToScreenName;
@synthesize user;
@synthesize retweetCount;
@synthesize favorited;
@synthesize retweeted;
@synthesize data;
@synthesize property = _property;
@end
