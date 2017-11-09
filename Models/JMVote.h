//
//  JMVote.h
//  cineclient
//
//  Created by 李雪 on 2017/5/15.
//  Copyright © 2017年 Cine. All rights reserved.
//

#import "JMBaseModel.h"
#import "JMUser.h"

@class JMPost;

@interface JMVote : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, copy) NSString<Optional> *modifyTime;
@property (nonatomic, copy) NSString<Optional> *nickname;
@property (nonatomic, copy) NSString<Optional> *avatar;
@property (nonatomic, strong) JMPost<Optional> *post;
@property (nonatomic, strong) JMUser<JMUser, Optional> *user;
@property (nonatomic, copy) NSString<Optional> *isFollowed;
@property (nonatomic, assign, readonly) BOOL hasFollowed;
- (void)setHasFollowed:(BOOL)hasFollowed;

@end

@protocol JMVote
@end
