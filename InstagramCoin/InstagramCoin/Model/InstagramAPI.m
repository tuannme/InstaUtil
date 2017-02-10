//
//  InstagramAPI.m
//  InstagramCoin
//
//  Created by Dreamup on 2/10/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

#import "InstagramAPI.h"
#import "AFNetworking.h"
#import "ConstantHandle.h"

static InstagramAPI *instagramAI = nil;

@implementation InstagramAPI

+ (id) shareInstance{
    if(instagramAI == nil){
        instagramAI = [[InstagramAPI alloc] init];
    }
    return instagramAI;
}

- (void) callAPIGetFeed:(NSString*)userID completion:(void(^)(id))completion{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:INSTAGRAM_ACCESS_TOKEN];
    NSString *path = userID == nil ?
    [NSString stringWithFormat:@"users/self/media/recent/?access_token=%@",token] : [NSString stringWithFormat:@"users/%@/media/recent/?access_token=%@",token,userID];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            id data = [responseObject objectForKey:@"data"];
            if(data){
                completion(data);
            }
            
            
//            // check status code if 200 mean success, otherwise show alert failure
//            NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
//            if(status == 200){
//               
//            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil);
        NSLog(@"error : %@",error);
    }];

}

- (void) callAPIGetUser:(NSString*)userID completion:(void(^)(id))completion{
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:INSTAGRAM_ACCESS_TOKEN];
    NSString *path = userID == nil ?
        [NSString stringWithFormat:@"users/self/?access_token=%@",token] : [NSString stringWithFormat:@"users/%@/?access_token=%@",token,userID];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){

            id data = [responseObject objectForKey:@"data"];
            if(data){
                completion(data);
            }
            
            // check status code if 200 mean success, otherwise show alert failure
//            NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
//            if(status == 200){
//                id data = [responseObject objectForKey:@"data"];
//                completion(data);
//            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil);
        NSLog(@"error : %@",error);
    }];

}


@end
