//
//  JMMessage.h
//  cineclient
//
//  Created by 李雪 on 2017/6/3.
//  Copyright © 2017年 Cine. All rights reserved.
//

#import "JMBaseModel.h"
#import "JMUser.h"
#import "JMPost.h"

@interface JMMessage : JMBaseModel

@property (nonatomic, copy) NSString<Optional> *ID;
@property (nonatomic, copy) NSString<Optional> *targetID;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, copy) NSString<Optional> *updatedTime;
@property (nonatomic, strong) JMUser<JMUser, Optional> *fromUser;
@property (nonatomic, strong) JMTag<JMTag, Optional> *tag;
@property (nonatomic, strong) JMPost<JMPost, Optional> *post;
@property (nonatomic, copy) NSString<Optional> *content;

@end
