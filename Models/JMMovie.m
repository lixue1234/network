//
//  JMMovie.m
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMMovie.h"

@implementation JMMovie

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"posts": @"post",
                @"contributors": @"contributer",
                @"coinCount": @"honey",
                @"latestPostCount": @"lastest_count",
                @"totalPostCount": @"amount",
                @"contributeCount": @"contribute_count",
                @"postCount": @"post_count"
            }];
}

#pragma mark - Property

- (NSString<Optional> *)coinCount
{
    return _coinCount.length > 0 ? _coinCount : @"0";
}

- (NSString<Optional> *)latestPostCount
{
    return _latestPostCount.length > 0 ? _latestPostCount : @"0";
}

- (NSString<Optional> *)totalPostCount
{
    return _totalPostCount.length > 0 ? _totalPostCount : @"0";
}

- (NSString<Optional> *)contributeCount
{
    return _contributeCount.length > 0 ? _contributeCount : @"0";
}

- (NSString<Optional> *)postCount
{
    return _postCount.length > 0 ? _postCount : @"0";
}

@end
