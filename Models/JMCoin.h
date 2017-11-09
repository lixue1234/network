//
//  JMCoin.h
//  cineclient
//
//  Created by WeiHan on 5/19/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMBaseModel.h"
#import "JMMovie.h"
#import "JMTag.h"

@protocol JMPost;


@interface JMCoin : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *targetID;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *coinCount;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, strong) JMMovie<Optional> *movie;
@property (nonatomic, strong) JMTag<Optional> *tag;
@property (nonatomic, strong) NSArray<JMPost, Optional> *posts;

@end
