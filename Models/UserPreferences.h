//
//  UserPreferences.h
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const LoginInfoKeyUserID;
FOUNDATION_EXPORT NSString *const LoginInfoKeyAccessToken;
FOUNDATION_EXPORT NSString *const LoginInfoKeyUsername;
FOUNDATION_EXPORT NSString *const LoginInfoKeyPassword;

NSDictionary<NSString *, NSString *> * GetLoginInfo();
void SetLoginInfo(NSDictionary<NSString *, NSString *> *info);

void SetFlagForPlayVideoInWWANMode(BOOL flag);
BOOL FShouldPlayVideoInWWANMode();

void SetHistoricalTagList(NSArray *array);
NSArray * GetHistoricalTagList();

void SetHistoricalMovieList(NSArray *array);
NSArray * GetHistoricalMovieList();
