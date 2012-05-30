//
// Created by Sergey Klimov on 5/30/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface SimpleArtist : NSObject
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, copy) NSNumber * numberInteger;
@property (nonatomic, copy) NSNumber * numberFloat;
@property (nonatomic, copy) NSURL * homePageURL;
@property (nonatomic, retain) NSArray * primitiveArray;

@end