//
//  UserInfoModel.m
//  cineclient
//
//  Created by WeiHan on 5/11/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "UserInfoModel.h"
#import "UserPreferences.h"

BOOL NoVideoDurationLimitForCurrentUser;

@interface UserInfoModel ()

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *backgroundURL;
@property (nonatomic, assign) BOOL isFemale;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *fansCount;
@property (nonatomic, copy) NSString *voteCount;
@property (nonatomic, copy) NSString *followingCount;
@property (nonatomic, copy) NSString *postCount;
@property (nonatomic, copy) NSString *interactCount;
@property (nonatomic, copy) NSString *coinCount;
@property (nonatomic, assign) PlatformTypeOption platformType;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NSMutableSet<id<UserInfoModelDelegate> > *delegates;

@end

@implementation UserInfoModel

#pragma mark - Public

+ (instancetype)sharedInstance
{
    static UserInfoModel *gUserInfo = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        gUserInfo = [UserInfoModel new];
        gUserInfo.delegates = [NSMutableSet new];
        NSDictionary *infoDict = GetLoginInfo();
        gUserInfo.userID = infoDict[LoginInfoKeyUserID];
        gUserInfo.username = infoDict[LoginInfoKeyUsername];
        gUserInfo.accessToken = infoDict[LoginInfoKeyAccessToken];
    });

    return gUserInfo;
}

- (BOOL)loadUserIDAndToken:(NSDictionary *)dictResult
{
    NSString *strUserID = GetValueFromDictionary(dictResult, @"userid");
    NSString *strAccessToken = GetValueFromDictionary(dictResult, @"token");
    BOOL result = strUserID.length > 0 && strAccessToken.length > 0;

    SetLoginInfo(@{
        LoginInfoKeyUserID: strUserID ? : @"",
        LoginInfoKeyAccessToken: strAccessToken ? : @""
    });

    self.userID = strUserID;
    self.accessToken = strAccessToken;

    return result;
}

- (BOOL)loadUserStatusInfo:(NSDictionary *)dictResult
{
    self.username = GetValueFromDictionary(dictResult, @"username");
    self.nickname = GetValueFromDictionary(dictResult, @"nickname");

    if (self.nickname.length <= 0 && self.userID.length > 0) {
        self.nickname = [NSString stringWithFormat:@"用户%@", self.userID];
    }

    self.avatarURL = GetValueFromDictionary(dictResult, @"avatar");
    self.backgroundURL = GetValueFromDictionary(dictResult, @"background");
    self.isFemale = [dictResult[@"gender"] isEqualToString:@"1"];
    self.city = dictResult[@"city"];
    self.signature = dictResult[@"description"];
    self.fansCount = [dictResult[@"fansNum"] description];
    self.voteCount = [dictResult[@"voteCount"] description];
    self.followingCount = [dictResult[@"followNum"] description];
    self.postCount = [dictResult[@"postNum"] description];
    self.interactCount = [dictResult[@"interactNum"] description];
    self.coinCount = [dictResult[@"honeyNum"] description];
    self.isFollow = [[NSString stringWithFormat:@"%@", dictResult[@"isFollow"]] isEqualToString:@"1"];

    NoVideoDurationLimitForCurrentUser = [dictResult[@"no_video_limit"] isEqualToNumber:@1];

    // Force to callback at this time.
    [self callbackTrigger:^(id < UserInfoModelDelegate > delegate) {
        if ([delegate respondsToSelector:@selector(userInfoModel:isLogin:)]) {
            [delegate userInfoModel:self
                            isLogin:[self hasLogin]];
        }
    }];

    return YES;
}

- (BOOL)loadThirdPartyLoginUserStausInfo:(NSDictionary *)dictResult;
{
    self.userID = GetValueFromDictionary(dictResult, @"userid");
    self.accessToken = GetValueFromDictionary(dictResult, @"token");
    self.nickname = GetValueFromDictionary(dictResult, @"nickname");
    self.avatarURL = GetValueFromDictionary(dictResult, @"avatar");
    self.isFemale = [dictResult[@"gender"] isEqualToString:@"1"];
    self.city = GetValueFromDictionary(dictResult, @"city");

    NSString *platform = GetValueFromDictionary(dictResult, @"platformType");

    if (platform.length > 0) {
        switch ([platform intValue]) {
            case 0:
                self.platformType = PlatformTypeOptionOfWechat;
                break;

            case 1:
                self.platformType = PlatformTypeOptionOfWeibo;
                break;

            case 2:
                self.platformType = PlatformTypeOptionOfQQ;
                break;

            default:
                break;
        }
    }

    // Force to callback at this time.
    [self callbackTrigger:^(id < UserInfoModelDelegate > delegate) {
        if ([delegate respondsToSelector:@selector(userInfoModel:isLogin:)]) {
            [delegate userInfoModel:self
                            isLogin:[self hasLogin]];
        }
    }];

    return YES;
}

- (BOOL)hasLogin
{
    return !(IsNullString(self.userID) || IsNullString(self.accessToken));
}

- (void)logout
{
    self.userID = nil;
    self.username = nil;
    self.nickname = nil;
    self.avatarURL = nil;
    self.backgroundURL = nil;
    self.isFemale = NO;
    self.city = nil;
    self.signature = nil;
    self.fansCount = nil;
    self.voteCount = nil;
    self.followingCount = nil;
    self.postCount = nil;
    self.interactCount = nil;
    self.coinCount = nil;
    self.accessToken = nil;

    SetLoginInfo(@{
        LoginInfoKeyPassword: @"",
        LoginInfoKeyAccessToken: @""
    });
}

- (void)addDelegate:(id<UserInfoModelDelegate>)delegate
{
    @synchronized(self) {
        [self.delegates addObject:delegate];
    }

    // trigger the isLogin delegate method manually at the first time
    if ([delegate respondsToSelector:@selector(userInfoModel:isLogin:)]) {
        [delegate userInfoModel:self
                        isLogin:[self hasLogin]];
    }
}

- (void)removeDelegate:(id<UserInfoModelDelegate>)delegate
{
    @synchronized(self) {
        [self.delegates removeObject:delegate];
    }
}

#pragma mark - Property

- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;

    BOOL isLogin = accessToken.length > 0;

    [self callbackTrigger:^(id < UserInfoModelDelegate > delegate) {
        if ([delegate respondsToSelector:@selector(userInfoModel:isLogin:)]) {
            [delegate userInfoModel:self
                            isLogin:isLogin];
        }
    }];
}

- (NSString *)followingCount
{
    return _followingCount.length > 0 ? _followingCount : @"0";
}

- (NSString *)fansCount
{
    return _fansCount.length > 0 ? _fansCount : @"0";
}

-(NSString *)voteCount
{
    return _voteCount.length > 0 ? _voteCount : @"0";
}

- (NSString *)postCount
{
    return _postCount.length > 0 ? _postCount : @"0";
}

- (NSString *)interactCount
{
    return _interactCount.length > 0 ? _interactCount : @"0";
}

- (NSString *)coinCount
{
    return _coinCount.length > 0 ? _coinCount : @"0";
}

#pragma mark - Private

- (void)callbackTrigger:(void (^)(id<UserInfoModelDelegate>))callback
{
    if (!callback) {
        return;
    }

    NSSet<id<UserInfoModelDelegate> > *delegateCopy = nil;

    @synchronized(self) {
        // for safe copy
        delegateCopy = [self.delegates copy];
    }

    [delegateCopy enumerateObjectsUsingBlock:^(id < UserInfoModelDelegate > obj, BOOL *stop) {
        callback(obj);
    }];
}

@end
