//
//  User.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize idStr;
@synthesize name;
@synthesize screenName;
@synthesize location;
@synthesize description;
@synthesize url;
@synthesize protected;
@synthesize followersCount;
@synthesize friendsCount;
@synthesize createdAt;
@synthesize following;
@synthesize tweets = _tweets;
@synthesize params;
@synthesize customText;
@end
