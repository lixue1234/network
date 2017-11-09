//
//  JMTag.h
//  cineclient
//
//  Created by WeiHan on 5/14/17.
//  Copyright © 2017 Cine. All rights reserved.
//

#import "JMBaseModel.h"

@class JMUser;
@protocol JMUser, JMPost;

@interface JMTag : JMBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) JMUser<Optional> *user;
@property (nonatomic, copy) NSArray<JMUser, Optional> *contributors;
@property (nonatomic, copy) NSString<Optional> *imageURL;
@property (nonatomic, copy) NSString<Optional> *hot;
@property (nonatomic, copy) NSString<Optional> *star;
@property (nonatomic, copy) NSString<Optional> *coinCount;
@property (nonatomic, copy) NSString<Optional> *postCount;
@property (nonatomic, copy) NSString<Optional> *latestPostCount;
@property (nonatomic, strong) NSArray<JMPost, Optional> *posts;

@end

@protocol JMTag
@end
