//
//  FISReposDataStore.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISReposDataStore.h"
#import "FISGithubAPIClient.h"
#import "FISGithubRepository.h"

@implementation FISReposDataStore
+ (instancetype)sharedDataStore {
    static FISReposDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISReposDataStore alloc] init];
    });

    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _repositories=[NSMutableArray new];
    }
    return self;
}

-(void)getRepositoriesWithCompletion:(void (^)(BOOL))completionBlock
{
    [FISGithubAPIClient getRepositoriesWithCompletion:^(NSArray *repoDictionaries) {
        for (NSDictionary *repoDictionary in repoDictionaries) {
            [self.repositories addObject:[FISGithubRepository repoFromDictionary:repoDictionary]];
        }
        completionBlock(YES);
    }];
}

- (void)toggleStarForRepo:(id)fullName CompletionBlock:(void (^)(BOOL))completionBlock
{
    // Check if the repo is starred
    // if it is starred, unstar it & call back with NO
    // if it isn't starred, star it & call back with YESS
    [FISGithubAPIClient checkIfRepoIsStarredWithFullName:fullName CompletionBlock:^(BOOL starred) {
        if (starred) {
            [FISGithubAPIClient unstarRepoWithFullName:fullName CompletionBlock:^(BOOL success) {
                // currently starred, unstar it
                completionBlock(NO);
            }];
        } else {
            [FISGithubAPIClient starRepoWithFullName:fullName CompletionBlock:^(BOOL success) {
                // currently unstarred, star it
                completionBlock(YES);
            }];
        }
    }];
}

@end
