//
//  Tweet.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property(nonatomic, readonly) NSDate *createdAt;
@property(nonatomic, readonly) NSString *idStr;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, readonly) NSString *source;
@property(nonatomic, readonly) BOOL truncated;
@property(nonatomic, readonly) NSString *inReplyToStatusIdStr;
@property(nonatomic, readonly) NSString *inReplyToUserIdStr;
@property(nonatomic, readonly) NSString *inReplyToScreenName;
@property(nonatomic, readonly) User *user;
@property(nonatomic, readonly) NSNumber *retweetCount;
@property(nonatomic, readonly) BOOL favorited;
@property(nonatomic, readonly) BOOL retweeted;
@property(nonatomic, strong) NSDate *data;
@property(nonatomic, strong) NSString *property;
@end
