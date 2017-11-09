//
//  UserPreferences.m
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "UserPreferences.h"
#import <UserDefaultsHelper/UserDefault.h>

#pragma mark - Keys

NSString *const LoginInfoKeyUserID = @"LoginInfoKeyUserID";
NSString *const LoginInfoKeyAccessToken = @"LoginInfoKeyAccessToken";
NSString *const LoginInfoKeyUsername = @"LoginInfoKeyUsername";
NSString *const LoginInfoKeyPassword = @"LoginInfoKeyPassword";

#define UserKey(__KEY__) @"Cine." #__KEY__

#define kSTRKey_LoginInfo           UserKey(LoginInfo)
#define kSTRKey_Token               UserKey(Token)
#define kSTRKey_PlayVideoInWiFiMode UserKey(PlayVideoInWiFiMode)
#define kSTRKey_HistoricalTagList   UserKey(HistoricalTagList)
#define kSTRKey_HistoricalMovieList UserKey(HistoricalMovieList)
#define kSTRKey_AgreeStatement UserKey(AgreeStatement)

#pragma mark - Functions

NSDictionary<NSString *, NSString *> * GetLoginInfo()
{
    return UserDefaultDictionary(kSTRKey_LoginInfo);
}

void SetLoginInfo(NSDictionary<NSString *, NSString *> *info)
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:UserDefaultDictionary(kSTRKey_LoginInfo)];

    for (NSString *key in info.allKeys) {
        dict[key] = info[key];
    }

    SetUserDefaultObject(kSTRKey_LoginInfo, dict);
}

NSString * GetUserAccessToken()
{
    return UserDefaultString(kSTRKey_Token);
}

void SetUserAccessToken(NSString *token)
{
    SetUserDefaultObject(kSTRKey_Token, token);
}

void SetFlagForPlayVideoInWWANMode(BOOL flag)
{
    SetUserDefaultBool(kSTRKey_PlayVideoInWiFiMode, flag);
}

BOOL FShouldPlayVideoInWWANMode()
{
    id value = UserDefaultObject(kSTRKey_PlayVideoInWiFiMode);

    if (!value) {
        return NO;
    }

    return [value boolValue];
}

void SetHistoricalTagList(NSArray *array)
{
    SetUserDefaultObject(kSTRKey_HistoricalTagList, array);
}

NSArray * GetHistoricalTagList()
{
    return UserDefaultArray(kSTRKey_HistoricalTagList);
}

void SetHistoricalMovieList(NSArray *array)
{
    SetUserDefaultObject(kSTRKey_HistoricalMovieList, array);
}

NSArray * GetHistoricalMovieList()
{
    return UserDefaultArray(kSTRKey_HistoricalMovieList);
}
