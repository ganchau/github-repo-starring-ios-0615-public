//
//  FISReposTableViewController.m
//  
//
//  Created by Joe Burgess on 5/5/14.
//
//

#import "FISReposTableViewController.h"
#import "FISReposDataStore.h"
#import "FISGithubRepository.h"
#import "FISGithubAPIClient.h"

@interface FISReposTableViewController ()
@property (strong, nonatomic) FISReposDataStore *dataStore;
@end

@implementation FISReposTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.tableView.accessibilityIdentifier=@"Repo Table View";

    self.tableView.accessibilityIdentifier = @"Repo Table View";
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.dataStore = [FISReposDataStore sharedDataStore];
    [self.dataStore getRepositoriesWithCompletion:^(BOOL success) {
        [self.tableView reloadData];
    }];
    [FISGithubAPIClient checkIfRepoIsStarredWithFullName:@"learn-co-students/lecture-code-ios-0615"
                                         CompletionBlock:^(BOOL starred) {
                                             if (starred)
                                                 NSLog(@"you starred it");
                                             else
                                                 NSLog(@"you did NOT star it");
                                         }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataStore.repositories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];

    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    cell.textLabel.text = repo.fullName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    
    [self.dataStore toggleStarForRepo:repo.fullName CompletionBlock:^(BOOL starred) {
        if (starred) {
            [self displayAlertMessage:@"You starred the repo." forRepo:repo.fullName];
        } else {
            [self displayAlertMessage:@"You unstarred the repo." forRepo:repo.fullName];
        }
    }];
    
//    [FISGithubAPIClient toggleStarForRepoWithFullName:repo.fullName
//                                      CompletionBlock:^(BOOL success) {
//                                          if (success) {
//                                              [self displayAlertMessage:@"You starred the repo." forRepo:repo.fullName];
//                                          } else {
//                                              [self displayAlertMessage:@"You unstarred the repo." forRepo:repo.fullName];
//                                          }
//                                      }];
}

- (void)displayAlertMessage:(NSString *)alertMessage forRepo:(NSString *)repoName
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:repoName
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
