//
//  RootViewController.m
//  InstagramCoin
//
//  Created by Dreamup on 2/10/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

#import "RootViewController.h"
#import "InstagramController.h"


@interface RootViewController ()
@property(nonatomic,strong) InstagramController *instagramHandler ;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:INSTAGRAM_ACCESS_TOKEN];
    
    if(token == nil){
        
        _loginBt.layer.cornerRadius = 5.0f;
        _loginBt.clipsToBounds = YES;
        
    }else{
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithInstagram:(id)sender {
    
    _instagramHandler = [[InstagramController alloc] init];
    [_instagramHandler loginWithInstagramWithParsentViewController:self completionHandler:^(NSDictionary *userProfileInformation) {
        NSLog(@"userProfileInformation : %@",userProfileInformation);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        });
        
    } failureHandler:^(NSDictionary *errorDetail) {
        NSLog(@"%@",errorDetail);
    }];
    
}
- (IBAction)shareWithInstagram:(id)sender {
    
    _instagramHandler = [InstagramController new];
    UIImage *image = [UIImage imageNamed:@"flower-197343_960_720.jpg"];
    [_instagramHandler sharePhotoWithInstagaramWithImage:image parsentViewcontroller:self];
}




- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

@end
