//
//  JMTag.m
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMTag.h"

@implementation JMTag

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"user": @"User",
                @"contributors": @"contirbuters",
                @"imageURL": @"image",
                @"coinCount": @"honey",
                @"posts": @"post",
                @"postCount": @"post_count",
                @"latestPostCount": @"lastest_count"
            }];
}

#pragma mark - Property

- (NSString *)postCount
{
    return _postCount.length > 0 ? _postCount : @"0";
}

@end
