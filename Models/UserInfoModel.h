//
//  UserInfoModel.h
//  cineclient
//
//  Created by WeiHan on 5/11/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IsUserLogin [[UserInfoModel sharedInstance] hasLogin]

FOUNDATION_EXPORT BOOL NoVideoDurationLimitForCurrentUser;

#pragma mark - UserInfoModelDelegate

@class UserInfoModel;

@protocol UserInfoModelDelegate <NSObject>

@optional

/**
 *    @brief Called when user login, logout and switch user identify.
 *
 *    @param userInfo new user info model
 *    @param isLogin  login status
 */
- (void)userInfoModel:(UserInfoModel *)userInfo isLogin:(BOOL)isLogin;

@end

typedef NS_ENUM (NSUInteger, PlatformTypeOption) {
    PlatformTypeOptionOfWechat = 0,
    PlatformTypeOptionOfWeibo,
    PlatformTypeOptionOfQQ
};

#pragma mark - UserInfoModel

@interface UserInfoModel : NSObject

@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, copy, readonly) NSString *avatarURL;
@property (nonatomic, copy, readonly) NSString *backgroundURL;
@property (nonatomic, assign, readonly) BOOL isFemale;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *signature;
@property (nonatomic, copy, readonly) NSString *fansCount;
@property (nonatomic, copy, readonly) NSString *voteCount;
@property (nonatomic, copy, readonly) NSString *followingCount;
@property (nonatomic, copy, readonly) NSString *postCount;
@property (nonatomic, copy, readonly) NSString *interactCount;
@property (nonatomic, copy, readonly) NSString *coinCount;
@property (nonatomic, assign) BOOL isFollow;

@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, assign, readonly) PlatformTypeOption platformType;

+ (instancetype)sharedInstance;

- (BOOL)loadUserIDAndToken:(NSDictionary *)dictResult;

- (BOOL)loadUserStatusInfo:(NSDictionary *)dictResult;

- (BOOL)loadThirdPartyLoginUserStausInfo:(NSDictionary *)dictResult;

- (BOOL)hasLogin;

- (void)logout;

- (void)addDelegate:(id<UserInfoModelDelegate>)delegate;

- (void)removeDelegate:(id<UserInfoModelDelegate>)delegate;

@end
