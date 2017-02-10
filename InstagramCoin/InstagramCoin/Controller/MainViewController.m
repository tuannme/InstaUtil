//
//  MainViewController.m
//  InstagramCoin
//
//  Created by Dreamup on 2/10/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

#import "MainViewController.h"
#import "InstagramController.h"
#import "InstagramAPI.h"

//https://api.instagram.com/v1/users/self/?access_token=ACCESS-TOKEN
@interface MainViewController ()

@property(nonatomic,strong) InstagramController *instagramHandler ;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[InstagramAPI shareInstance] callAPIGetFeed:path completion:^(id data){
//        
//    }];

    [[InstagramAPI shareInstance] callAPIGetFeed:nil  completion:^(id data){
        
        NSLog(@"%@",data);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
