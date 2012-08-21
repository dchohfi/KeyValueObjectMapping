//
//  User.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic, readonly) NSString *idStr;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *screenName;
@property(nonatomic, readonly) NSString *location;
@property(nonatomic, readonly) NSString *description;
@property(nonatomic, readonly) NSURL *url;
@property(nonatomic, readonly) BOOL protected;
@property(nonatomic, readonly) long followersCount;
@property(nonatomic, readonly) long friendsCount;
@property(nonatomic, readonly) NSDate *createdAt;
@property(nonatomic, readonly) BOOL following;
@property(nonatomic, readonly) NSArray *tweets;
@property(nonatomic, strong) NSString *customText;
@property(nonatomic, readonly) NSMutableArray *params;
@end
