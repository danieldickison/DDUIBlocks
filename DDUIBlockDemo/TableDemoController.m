//
//  TableDemoController.m
//  DDUIBlockDemo
//
//  Created by Daniel Dickison on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableDemoController.h"
#import "DDUIBlocks.h"


@implementation TableDemoController

- (void)viewDidLoad
{
    __block TableDemoController *blockSelf = self;
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
    tableView.tag = 42;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    
    // This is used to deselect the current row after the alerts/sheets.
    void (^deselectRow)() = ^
    {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    };
    
    // Insertions and Deletions
    
    __block DDBlockTableCellSpec *insertCell = [DDBlockTableCellSpec cellSpecWithReuseIdentifier:@"generic"];
    insertCell.configurationBlock = ^(UITableViewCell *cell)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Insert Row";
    };
    __block int newCellCounter = 0;
    insertCell.insertionBlock = ^
    {
        int thisCellNumber = newCellCounter++;
        __block DDBlockTableCellSpec *newCell = [DDBlockTableCellSpec cellSpecWithReuseIdentifier:@"generic"];
        newCell.configurationBlock = ^(UITableViewCell *cell)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = [NSString stringWithFormat:@"Temp cell #%d", thisCellNumber];
        };
        newCell.deletionBlock = ^
        {
            [newCell.sectionSpec.tableViewDelegate deleteCellSpecAtIndexPath:newCell.indexPath];
        };
        [insertCell.sectionSpec.tableViewDelegate insertCellSpec:newCell atIndexPath:insertCell.indexPath];
    };
    insertCell.selectedBlock = insertCell.insertionBlock;
    
    __block DDBlockTableSectionSpec *section1 = [DDBlockTableSectionSpec sectionSpecWithCellSpecs:insertCell, nil];
    section1.headerBlock = ^{ return @"Insertions and Deletions"; };
    
    // Accessory Views
    
    __block DDBlockTableCellSpec *detailDisclosure = [DDBlockTableCellSpec cellSpecWithReuseIdentifier:@"generic"];
    detailDisclosure.configurationBlock = ^(UITableViewCell *cell)
    {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.text = @"Detail Disclosure";
    };
    detailDisclosure.selectedBlock = ^
    {
        DDBlockAlert *alert = [DDBlockAlert alertWithTitle:@"Detail Disclosure" message:@"Selected normally."];
        [alert addCancelButtonWithTitle:@"Dismiss" handler:deselectRow];
        [alert show];
    };
    detailDisclosure.accessoryTappedBlock = ^
    {
        DDBlockAlert *alert = [DDBlockAlert alertWithTitle:@"Detail Disclosure" message:@"Detail disclosure button tapped."];
        [alert addCancelButtonWithTitle:@"Dismiss" handler:^{}];
        [alert show];
    };
    
    __block DDBlockTableCellSpec *checkCell = [DDBlockTableCellSpec cellSpecWithReuseIdentifier:@"generic"];
    __block BOOL isChecked = YES;
    checkCell.configurationBlock = ^(UITableViewCell *cell)
    {
        cell.accessoryType = (isChecked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        cell.textLabel.text = @"Check Mark";
    };
    checkCell.selectedBlock = ^
    {
        isChecked = !isChecked;
        checkCell.sectionSpec.tableViewDelegate.currentCell.accessoryType = (isChecked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        deselectRow();
    };
    
    __block DDBlockTableSectionSpec *section2 = [DDBlockTableSectionSpec sectionSpecWithCellSpecs:detailDisclosure, checkCell, nil];
    section2.headerBlock = ^{ return @"Accessory View Events"; };
    
    tableDelegate = [[DDBlockTableDelegate alloc] init];
    tableDelegate.sectionSpecs = [NSArray arrayWithObjects:section1, section2, nil];
    tableView.dataSource = tableDelegate;
    tableView.delegate = tableDelegate;
    [tableView reloadData];
    tableView.allowsSelectionDuringEditing = NO;
    
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    
    
    // Create toolbar items.
    self.toolbarItems =
    [NSArray arrayWithObjects:
     [DDBlockBarButtonItem barButtonItemWithTitle:@"Pop" style:UIBarButtonItemStyleBordered handler:^
       {
           [blockSelf.navigationController popViewControllerAnimated:YES];
       }],
     [DDBlockBarButtonItem barButtonItemWithTitle:@"Pop sans animation" style:UIBarButtonItemStyleDone handler:^
       {
           [blockSelf.navigationController popViewControllerAnimated:NO];
       }],
     nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [tableDelegate release];
    tableDelegate = nil;
}

- (void)dealloc
{
    [tableDelegate release];
    [super dealloc];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [(UITableView *)[self.view viewWithTag:42] setEditing:editing animated:animated];
}

@end
