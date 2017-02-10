//
//  InstagramController.m
//  InstagramCoin
//
//  Created by Dreamup on 2/10/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

#import "InstagramController.h"

@interface InstagramController ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UIView                  *_progressView;
    UIWebView               *_webView;
    UIViewController        *_controller;
    UIActivityIndicatorView *_activitiyIndicator;
}
@property(strong,nonatomic)NSString *typeOfAuthentication;
@property (nonatomic, strong) void(^completionHandler)(NSDictionary *);
@property (nonatomic, strong) void(^failureHandler)(NSDictionary *);
@property(nonatomic,strong)UIDocumentInteractionController *docFile;

@end

#pragma mark - View Controller Life Cycle Method

@implementation InstagramController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:126.0/255.0 blue:163.0/255.0 alpha:1];
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    [self.view addSubview:naviView];
    
    
    //Add the cancel Button
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    [button setImage:[UIImage imageNamed:@"bt_back.png"]  forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(30, 10, 10, 60)];
    [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:button];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    
    _webView = [UIWebView new];
    //_webView.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:126.0/255.0 blue:163.0/255.0 alpha:1];
    CGRect frame = self.view.frame;
    frame.origin.y = 60;
    _webView.frame = frame;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    //Hit instagaram API;
    NSString* authURL = nil;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([_typeOfAuthentication isEqualToString:UNSIGNED]){
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URL,
                   INSTAGRAM_SCOPE];
        
    }
    else{
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URL,
                   INSTAGRAM_SCOPE];
    }
    
    
    [_webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
}
#pragma mark - Local Method

- (void)addIndicatorView {
    
    _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 80)];
    _progressView.layer.cornerRadius = 10;
    _progressView.layer.masksToBounds = YES;
    _progressView.backgroundColor = [UIColor blackColor];
    _progressView.alpha = 0.7;
    //    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(30,25, 90, 20)];
    //    lable.textColor = [UIColor grayColor];
    //    [lable setTextAlignment:NSTextAlignmentCenter];
    //    lable.font = [UIFont italicSystemFontOfSize:15.0f];
    //    lable.text = @"progress...";
    //    [_progressView addSubview:lable];
    _activitiyIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activitiyIndicator setCenter:CGPointMake(_progressView.frame.size.width/2.0, _progressView.frame.size.height/2.3)]; // I do this because I'm in landscape mode
    [_progressView addSubview:_activitiyIndicator];
    [_activitiyIndicator startAnimating];
    _progressView.center = self.view.center;
    [_webView addSubview:_progressView];
}


- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([_typeOfAuthentication isEqualToString:UNSIGNED])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URL])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: ACCESS_TOKEN ];
            [self handleAuth:[urlString substringFromIndex: range.location+range.length] withProfileInfo:nil];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URL])
        {
            // extract and handle code
            NSRange range = [urlString rangeOfString: CODE];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
}



-(void)makePostRequest:(NSString *)authToken
{
    
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URL,authToken];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // URL of the endpoint we're going to contact.
    NSURL *url = [NSURL URLWithString:END_POINT_URL];
    
    // Create a POST request with our JSON as a request body.
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:url];
    requestData.HTTPMethod = HTTP_METHOD;
    [requestData setValue:postLength forHTTPHeaderField:CONTENT_LENGTH];
    [requestData setValue:REQUEST_DATA forHTTPHeaderField:CONTENT_TYPE];
    requestData.HTTPBody   = postData;
    
    // Create a task.
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:requestData
                                                                 completionHandler:^(NSData *data,
                                                                                     NSURLResponse *response,
                                                                                     NSError *error)
                                  {
                                      if (!error)
                                      {
                                          NSDictionary  *dictionarry = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          [self handleAuth:[dictionarry valueForKey:@"access_token"] withProfileInfo:dictionarry];
                                      } else{
                                          
                                          NSLog(@"Error: %@", error.localizedDescription);
                                          [self handleAuth:nil withProfileInfo:nil];
                                      }
                                  }];
    
    // Start the task.
    [task resume];
    
}

- (void) handleAuth: (NSString*)authToken withProfileInfo:(NSDictionary *)dictionary
{
    
    NSLog(@"successfully logged in with Tocken == %@",authToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:INSTAGRAM_ACCESS_TOKEN];
    [self cancelLogin];
  
    if (dictionary) {
        _completionHandler(dictionary);
    } else _failureHandler(dictionary);

}
- (void)cancelLogin {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [_controller.childViewControllers lastObject];
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    });
}
#pragma mark -WebView Delegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
    [self addIndicatorView];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressView removeFromSuperview];
    _progressView = nil;
    [_activitiyIndicator stopAnimating];
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark - user Define Method

- (void)loginWithInstagramWithParsentViewController:(UIViewController *)controller  completionHandler:(void(^)(NSDictionary *userProfileInformation))completionHanlder failureHandler:(void(^)(NSDictionary *errorDetail))failureHandler {
    
    _controller = controller;
    [controller addChildViewController:self];
    self.view.frame = controller.view.frame;
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
    _completionHandler = completionHanlder;
    _failureHandler    = failureHandler;
}
- (void)sharePhotoWithInstagaramWithImage:(UIImage *)image parsentViewcontroller:(UIViewController *)controller{
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:DOCUMENT_FILE_PATH];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        NSFileManager *fielManager = [NSFileManager defaultManager];
        [fielManager removeItemAtPath:savePath error:nil];
    }
    BOOL save   = [UIImagePNGRepresentation(image) writeToFile:savePath atomically:YES];
    NSURL *instagramURL = [NSURL URLWithString:APP_URL];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL] && save) {
        
        self.docFile = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        self.docFile.UTI = UTI_URL;
        self.docFile.delegate = self;
        [self.docFile presentOpenInMenuFromRect:CGRectZero inView:controller.view animated:YES];
    } else {
        
        NSLog(@"%@",MESSAGE);
    }
}

#pragma mark - UIDocumentInteractionController delegateMethod

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

#pragma mark - selector method
-(void)cancel:(UIButton *)button {
    
    [self cancelLogin];
}
@end
