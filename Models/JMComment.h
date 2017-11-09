//
//  JMComment.h
//  cineclient
//
//  Created by 李雪 on 2017/5/15.
//  Copyright © 2017年 Cine. All rights reserved.
//

#import "JMBaseModel.h"
#import "JMUser.h"

@class JMPost;

@protocol JMComment
@end

@interface JMComment : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString<Optional> *nickname;
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *voteCount;
@property (nonatomic, copy) NSString<Optional> *commentCount;
@property (nonatomic, copy) NSString<Optional> *commentId;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, strong) JMUser<Optional> *user;
@property (nonatomic, strong) JMPost<Optional> *post;
@property (nonatomic, strong) NSString<Optional> *isVoted;
@property (nonatomic, copy) NSString<Optional> *location;
@property (nonatomic, copy) NSString<Optional> *modifyTime;
@property (nonatomic, copy) NSString<Optional> *postId;
@property (nonatomic, copy) NSString<Optional> *receiver;
@property (nonatomic, copy) NSString<Optional> *time;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSArray<JMComment, Optional> *subCommentList;

@property (nonatomic, assign, readonly) BOOL hasVoted;
- (void)setHasVoted:(BOOL)hasVoted;
@end
