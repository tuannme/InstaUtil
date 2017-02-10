//
//  InstagramAPI.h
//  InstagramCoin
//
//  Created by Dreamup on 2/10/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramAPI : NSObject

+ (id) shareInstance;

- (void) callAPIGetFeed:(NSString*)path completion:(void(^)(id))completion;
- (void) callAPIGetUser:(NSString*)path completion:(void(^)(id))completion;


@end
