//
//  JMUser.h
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMBaseModel.h"

typedef NS_ENUM (NSUInteger, FollowingStatus) {
    FollowingStatusNone = 0,
    FollowingStatusFollowed = 1 << 0,
    FollowingStatusFollowingMe = 1 << 1,
    FollowingStatusEachOther = FollowingStatusFollowingMe | FollowingStatusFollowed
};

@interface JMUser : JMBaseModel

@property (nonatomic, copy) NSString<Optional> *ID;
@property (nonatomic, copy) NSString<Optional> *avatar;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *intro;
@property (nonatomic, copy) NSString<Optional> *isFollow;

@property (nonatomic, assign, readonly) BOOL hasFollowed;
@property (nonatomic, assign, readonly) FollowingStatus followingStatus;

- (void)setHasFollowed:(BOOL)hasFollowed;

@end

@protocol JMUser
@end
