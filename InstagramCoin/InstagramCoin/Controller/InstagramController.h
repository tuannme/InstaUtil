//
//  InstagramController.h
//  InstagramCoin
//
//  Created by Dreamup on 2/10/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantHandle.h"

@interface InstagramController : UIViewController

- (void)loginWithInstagramWithParsentViewController:(UIViewController *)controller  completionHandler:(void(^)(NSDictionary *userProfileInformation))completionHanlder failureHandler:(void(^)(NSDictionary *errorDetail))failureHandler;

- (void)sharePhotoWithInstagaramWithImage:(UIImage *)image parsentViewcontroller:(UIViewController *)controller;

@end
