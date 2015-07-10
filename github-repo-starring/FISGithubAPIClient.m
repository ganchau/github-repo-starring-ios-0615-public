//
//  FISGithubAPIClient.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import <AFNetworking.h>

@implementation FISGithubAPIClient
NSString *const GITHUB_API_URL=@"https://api.github.com";

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}

+ (void)checkIfRepoIsStarredWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL starred))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/starred/%@?access_token=%@", GITHUB_API_URL, fullName,  GITHUB_ACCESS_TOKEN];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // data is the body
    // response is the header
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            
                                            NSHTTPURLResponse *headerResponse = (NSHTTPURLResponse *)response;
                                            NSLog(@"Check repo if starred, STATUS: %lu", headerResponse.statusCode);
                                            
                                            // if the http respnse code is 204, we starred the repo, 404 = not starred
                                            if (headerResponse.statusCode == 204) {
                                                completionBlock(YES);
                                            } else {
                                                completionBlock(NO);
                                            }
                                        }];
    [task resume];
}

+ (void)starRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL success))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/starred/%@?access_token=%@", GITHUB_API_URL, fullName, GITHUB_ACCESS_TOKEN];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // using request to perform a 'PUT'
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                NSHTTPURLResponse *headerResponse = (NSHTTPURLResponse *)response;
                                                NSLog(@"Star the repo, STATUS: %lu", headerResponse.statusCode);

                                                // if the http respnse code is 204, starring the repo is successful
                                                if (headerResponse.statusCode == 204) {
                                                    completionBlock(YES);
                                                } else {
                                                    completionBlock(NO);
                                                }
                                            }];
    [task resume];
}

+ (void)unstarRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL success))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/starred/%@?access_token=%@", GITHUB_API_URL, fullName, GITHUB_ACCESS_TOKEN];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // using request to perform a 'DELETE'
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                NSHTTPURLResponse *headerResponse = (NSHTTPURLResponse *)response;
                                                NSLog(@"Star the repo, STATUS: %lu", headerResponse.statusCode);
                                                
                                                // if the http respnse code is 204, starring the repo is successful
                                                if (headerResponse.statusCode == 204) {
                                                    completionBlock(YES);
                                                } else {
                                                    completionBlock(NO);
                                                }
                                            }];
    [task resume];
}

@end
