//
//  ConstantHandle.h
//  InstagramCoin
//
//  Created by Dreamup on 2/10/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

#ifndef ConstantHandle_h
#define ConstantHandle_h

//set User authentication and url
#define INSTAGRAM_AUTHURL @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl  @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID @"529fb5748fb44d2ba2177d1aa0900362"// 205f0bf8b50a4d0eaa71b7f35fbe7e9c
#define INSTAGRAM_CLIENTSERCRET @"27d0b75d2e6048c1968cfb63b4b50e2f"// 7b4cb492a064457a892e8e93125feabf
#define INSTAGRAM_REDIRECT_URL  @"http://trams.co.kr"//https://www.facebook.com/Rango0o0o0
#define INSTAGRAM_ACCESS_TOKEN  @"access_token"
#define INSTAGRAM_SCOPE         @"likes+comments+relationships+basic+public_content"

//Contant Url
#define ACCESS_TOKEN    @"#access_token="
#define UNSIGNED        @"UNSIGNED"
#define CODE            @"code="
#define END_POINT_URL   @"https://api.instagram.com/oauth/access_token"
#define HTTP_METHOD     @"POST"
#define CONTENT_LENGTH  @"Content-Length"
#define REQUEST_DATA    @"application/x-www-form-urlencoded"
#define CONTENT_TYPE    @"Content-Type"

//share Photo Constant
#define DOCUMENT_FILE_PATH @"Documents/originalImage.ig"
#define APP_URL   @"instagram://app"
#define UTI_URL   @"com.instagram.exclusivegram"
#define MESSAGE   @"Instagram not installed in this device!\nTo share image please install instagram."


#endif /* ConstantHandle_h */
