//
//  AOPHackingSet.m
//  cineclient
//
//  Created by WeiHan on 28/06/2017.
//  Copyright © 2017 Cine. All rights reserved.
//

#import <Aspects/Aspects.h>
#import "AOPHackingSet.h"
#import "TagImageView.h"
#import "TagAnchorView.h"
#import "TagInfoViewController.h"
#import "ViewControllerHelper.h"

@implementation AOPHackingSet

+ (void)load
{
    [TagImageView aspect_hookSelector:NSSelectorFromString(@"coordinateDidTapped:")
                          withOptions:AspectPositionInstead
                           usingBlock:^(id < AspectInfo > info) {
        TagAnchorView *anchorView = info.arguments.firstObject;
        NSArray *tagItems = [info.instance valueForKey:@"tagItems"];
        CoordinateData *data = tagItems[anchorView.tag];

        TagInfoViewController *tagInfoVC = [TagInfoViewController new];
        tagInfoVC.targetID = data.ID;
        [[ViewControllerHelper topViewController].navigationController pushViewController:tagInfoVC
                                                                                 animated:YES];
    }
                                error:nil];
}

@end
