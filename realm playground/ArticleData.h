//
// Created by jason9075 on 2016/2/15.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm/RLMObject.h"

@protocol RLMInt;


@interface ArticleData : RLMObject

@property NSNumber<RLMInt> *id;
@property NSString *title;
@property NSString *subtitle;

@end