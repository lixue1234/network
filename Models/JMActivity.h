//
//  JMActivity.h
//  cineclient
//
//  Created by WeiHan on 5/18/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMBaseModel.h"

@class JMVote, JMComment, JMPost, JMTag, JMMovie;

typedef NS_ENUM (NSUInteger, ActivityOption) {
    ActivityOptionPost = 1,
    ActivityOptionComment,
    ActivityOptionVote,
    ActivityOptionCoin
};

@interface JMActivity : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *targetID;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) JMVote<Optional> *vote;
@property (nonatomic, strong) JMComment<Optional> *comment;
@property (nonatomic, strong) JMPost<Optional> *post;
@property (nonatomic, strong) JMTag<Optional> *tag;
@property (nonatomic, strong) JMMovie<Optional> *movie;

@property (nonatomic, assign, readonly) ActivityOption typeOption;

@end
