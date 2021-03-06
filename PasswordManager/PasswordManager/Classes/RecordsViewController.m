//
//  RecordsViewController.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordViewController.h"
#import "Record.h"
#import "RecordsManager.h"
#import "RecordsViewController.h"
#import "SettingsViewController.h"

static NSString *const DefaultFileNameForLocalStore = @"AwesomeFileName.dat";

@interface RecordsViewController ()
    <UITableViewDataSource,
     UITableViewDelegate,
     RecordViewControllerDelegate,
     SettingsViewControllerDelegate>

@property (nonatomic, readonly) RecordsManager *recordsManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation RecordsViewController

@synthesize recordsManager = recordsManager_;

#pragma mark - Getters

- (RecordsManager *)recordsManager
{
    if (!recordsManager_) {
        NSURL *const documentDirectoryURL =
            [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                    inDomains:NSUserDomainMask] lastObject];
        NSURL *const fileURLForLocalStore =
            [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForLocalStore];

        recordsManager_ = [[RecordsManager alloc] initWithURL:fileURLForLocalStore];
    }

    return recordsManager_;
}

#pragma mark - Actions
- (IBAction)didTouchSettingsBarButtonItem:(id)sender
{
    SettingsViewController *const rootViewController = [[SettingsViewController alloc] init];
    rootViewController.delegate = self;
    
    UINavigationController *const navigationController =
    [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender
{
    RecordViewController *const rootViewController = [[RecordViewController alloc] init];
    rootViewController.delegate = self;

    UINavigationController *const navigationController =
        [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.recordsManager records] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"

    UITableViewCell *tableViewCell =
        [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    NSDictionary *const record =
        [[self.recordsManager records] objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = [record valueForKey:kServiceName];
    tableViewCell.detailTextLabel.text = [record valueForKey:kPassword];

    return tableViewCell;

#undef REUSABLE_CELL_ID
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.recordsManager deleteRecord:self.recordsManager.records[indexPath.row]];
        [self.recordsManager synchronize];
        [tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordViewController *const rootViewController = [[RecordViewController alloc] init];
    rootViewController.delegate = self;
    
    NSDictionary *record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    rootViewController.record = record;
    
    UINavigationController *const navigationController =
    [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NewRecordViewControllerDelegate implementation

- (void)recordViewController:(RecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record
{
    if (record) {
        if (sender.record) {
            [self.recordsManager replaceRecord:sender.record withRecord:record];
        } else {
            [self.recordsManager registerRecord:record];
        }
        [self.recordsManager synchronize];

        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)sender
{
    [self.recordsManager synchronize];
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}


@end
