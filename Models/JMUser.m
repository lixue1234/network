//
//  JMUser.m
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMUser.h"

@implementation JMUser

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                kGlobalPairedKey,
                @"name": @"nickname",
                @"intro": @"description",
                @"isFollow": @"is_follow"
            }];
}

- (FollowingStatus)followingStatus
{
    NSUInteger value = self.isFollow.integerValue;

    if (value == 1) {
        return FollowingStatusFollowed;
    } else if (value == 2) {
        return FollowingStatusEachOther;
    } else {
        return FollowingStatusNone;
    }
}

- (BOOL)hasFollowed
{
    return self.followingStatus & FollowingStatusFollowed;
}

- (void)setHasFollowed:(BOOL)hasFollowed
{
    FollowingStatus status = self.followingStatus;

    if (hasFollowed) {
        status |= FollowingStatusFollowed;
    } else {
        status ^= FollowingStatusFollowed;
    }

    switch (status) {
        case FollowingStatusFollowed:
            self.isFollow = @"1";
            break;

        case FollowingStatusEachOther:
            self.isFollow = @"2";
            break;

        default:
            self.isFollow = @"0";
            break;
    }
}

- (NSString<Optional> *)intro
{
    if (_intro.length <= 0) {
        return @"这家伙很懒，什么都没有留下...";
    }

    return _intro;
}

@end
