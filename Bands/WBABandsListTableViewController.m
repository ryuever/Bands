//
//  WBABandsListTableViewController.m
//  Bands
//
//  Created by ryu on 2014/10/13.
//  Copyright (c) 2014年 ryu. All rights reserved.
//

#import "WBABandsListTableViewController.h"
#import "WBABand.h"
#import "WBABandDetailsViewController.h"

static NSString *bandsDictionarytKey = @"BABandsDictionarytKey";

@interface WBABandsListTableViewController ()

@end

@implementation WBABandsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBandsDictionary];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"from viewWillAppear in WBABandListTableViewController");
    
//    if (self.bandInfoViewController && self.bandInfoViewController.saveBand) {
//        [self addNewBand:self.bandInfoViewController.bandObject];
//        self.bandInfoViewController = nil;
//    }
    
//    if (self.bandInfoViewController) {
//        if (self.bandInfoViewController.saveBand)
//        {
//            [self addNewBand:self.bandInfoViewController.bandObject];
//            [self.tableView reloadData];
//        }
//        self.bandInfoViewController = nil;
//    }
    
    if (self.bandInfoViewController) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        if (self.bandInfoViewController.saveBand) {
            if (selectedIndexPath) {
                [self updateBandObject:self.bandInfoViewController.bandObject atIndexPath:selectedIndexPath];
                [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
            }
            else
                [self addNewBand:self.bandInfoViewController.bandObject];
            [self.tableView reloadData];
        }
        else if (selectedIndexPath)
            [self deleteBandAtIndexPath:selectedIndexPath];
        self.bandInfoViewController = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    return 1;
    return self.bandsDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    return 10;
    
    NSString *firstLetter = [self.firstLettersArray objectAtIndex:section];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:firstLetter];
    
    return bandsForLetter.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *firstLetter = [self.firstLettersArray objectAtIndex:indexPath.section];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:firstLetter];
    
    WBABand *bandObject = [bandsForLetter objectAtIndex:indexPath.row];
//     Configure the cell...
    cell.textLabel.text = bandObject.name;
    return cell;
}

- (IBAction)addBandTouched:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.bandInfoViewController = (WBABandDetailsViewController *)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier:@"bandDetails"];
    
    [self presentViewController:self.bandInfoViewController animated:NO completion:nil];
}



- (void)addNewBand:(WBABand*)bandObject
{
    NSString *bandNameFirstLetter = [bandObject.name substringToIndex:1];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:bandNameFirstLetter];
    
    if(!bandsForLetter)
        bandsForLetter = [NSMutableArray array];
    
    [bandsForLetter addObject:bandObject];
    [bandsForLetter sortUsingSelector:@selector(compare:)];
    [self.bandsDictionary setObject:bandsForLetter forKey:bandNameFirstLetter];
    
    if(![self.firstLettersArray containsObject:bandNameFirstLetter])
    {
        [self.firstLettersArray addObject:bandNameFirstLetter];
        [self.firstLettersArray sortUsingSelector:@selector(compare:)];
    }
    
    [self saveBandsDictionary];
}

- (void)saveBandsDictionary
{
    NSData *bandsDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:self.bandsDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:bandsDictionaryData forKey:bandsDictionarytKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadBandsDictionary
{
    NSData *bandsDictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:bandsDictionarytKey];
    
    if(bandsDictionaryData)
    {
        self.bandsDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:bandsDictionaryData];
        self.firstLettersArray = [NSMutableArray arrayWithArray:self.bandsDictionary.allKeys];
        [self.firstLettersArray sortUsingSelector:@selector(compare:)];
    }
    else
    {
        self.bandsDictionary = [NSMutableDictionary dictionary];
        self.firstLettersArray = [NSMutableArray array];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [self.firstLettersArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSLog(@"sectionIndexTitlesForTableView : %@", self.firstLettersArray);
    return self.firstLettersArray;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteBandAtIndexPath:indexPath];
    }
}

- (void)deleteBandAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionHeader = [self.firstLettersArray objectAtIndex:indexPath.section];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:sectionHeader];
    [bandsForLetter removeObjectAtIndex:indexPath.row];
    
    if (bandsForLetter.count == 0) {
        [self.firstLettersArray removeObject:sectionHeader];
        [self.bandsDictionary removeObjectForKey:sectionHeader];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [self.bandsDictionary setObject:bandsForLetter forKey:sectionHeader];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self saveBandsDictionary];
}

- (void)updateBandObject:(WBABand *)bandObject atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSString *sectionHeader = [self.firstLettersArray objectAtIndex:selectedIndexPath.section];
    NSMutableArray *bandsForSection = [self.bandsDictionary objectForKey:sectionHeader];
    [bandsForSection removeObjectAtIndex:indexPath.row];
    [bandsForSection addObject:bandObject];
    [bandsForSection sortUsingSelector:@selector(compare:)];
    [self.bandsDictionary setObject:bandsForSection forKey:sectionHeader];
    [self saveBandsDictionary];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSString *sectionHeader = [self.firstLettersArray objectAtIndex:selectedIndexPath.section];
    NSMutableArray *bandsForSection = [self.bandsDictionary objectForKey:sectionHeader];
    WBABand *bandObject = [bandsForSection objectAtIndex:selectedIndexPath.row];
    
    self.bandInfoViewController = segue.destinationViewController;
    self.bandInfoViewController.bandObject = bandObject;
    self.bandInfoViewController.saveBand = YES;
}

//- (int)tableview:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *) title atIndex:(NSInteger)index
//{
//    NSLog(@"in sectionForSectionIndexTitle");
//    NSLog(@"section index is %ld",[self.firstLettersArray indexOfObject:title]);
//    return [self.firstLettersArray indexOfObject:title];
//    
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
