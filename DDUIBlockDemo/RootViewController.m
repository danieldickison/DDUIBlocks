//
//  RootViewController.m
//  DDUIBlockDemo
//
//  Created by Daniel Dickison on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DDUIBlocks.h"
#import "TableDemoController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation RootViewController


- (void)dealloc
{
    [tableDelegate release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        // Create toolbar items.
        self.toolbarItems =
        [NSArray arrayWithObjects:
         [DDBlockBarButtonItem barButtonItemWithTitle:@"Foo" style:UIBarButtonItemStyleBordered handler:^
           {
               DDBlockAlert *alert = [DDBlockAlert alertWithTitle:@"Foo!" message:@"You tapped Foo."];
               [alert addCancelButtonWithTitle:@"Dismiss" handler:^{}];
               [alert show];
           }],
         [DDBlockBarButtonItem barButtonItemWithTitle:@"Bar" style:UIBarButtonItemStyleDone handler:^
           {
               DDBlockAlert *alert = [DDBlockAlert alertWithTitle:@"Bar!" message:@"You tapped Bar."];
               [alert addCancelButtonWithTitle:@"Dismiss" handler:^{}];
               [alert show];
           }],
         nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Note that each cell and section spec should be declared with the __block modifier. This prevents a retain loop if you need to refer to the cell spec within one of its own callback blocks. Without __block, the block retains the cell spec, and the cell spec retains the block, resulting in a leak.
    // Also, if you need to refer to self or an ivar of self, you should create a local __block variable pointing to self, for much the same reason.
    
    __block RootViewController *blockSelf = self;
    
    __block DDBlockTableCellSpec *tableCellSpec = [DDBlockTableCellSpec cellSpecWithReuseIdentifier:@"generic"];
    tableCellSpec.configurationBlock = ^(UITableViewCell *cell)
    {
        cell.textLabel.text = @"DDBlockTableDelegate";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    tableCellSpec.selectedBlock = ^()
    {
        TableDemoController *tableController = [[[TableDemoController alloc] init] autorelease];
        [self.navigationController pushViewController:tableController animated:YES];
    };
    
    // This is used to deselect the current row after the alerts/sheets.
    void (^deselectRow)() = ^()
    {
        [blockSelf.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    };
    
    // DDBlockAlert Demo
    
    __block DDBlockTableCellSpec *alertCellSpec = [DDBlockTableCellSpec cellSpecWithReuseIdentifier:@"generic"];
    alertCellSpec.configurationBlock = ^(UITableViewCell *cell)
    {
        cell.textLabel.text = @"DDBlockAlert";
        cell.accessoryType = UITableViewCellAccessoryNone;
    };
    alertCellSpec.selectedBlock = ^()
    {
        DDBlockAlert *alert = [DDBlockAlert alertWithTitle:@"DDBlockAlert" message:@"Hello there."];
        [alert addButtonWithTitle:@"Another" handler:^
         {
             DDBlockAlert *another = [DDBlockAlert alertWithTitle:@"Another" message:@"Turtles all the way down."];
             [another addCancelButtonWithTitle:@"Dismiss" handler:deselectRow];
             [another show];
         }];
        [alert addCancelButtonWithTitle:@"Cancel" handler:deselectRow];
        [alert show];
    };
    
    // DDBlockActionSheet Demo
    
    __block DDBlockTableCellSpec *sheetCellSpec = [DDBlockTableCellSpec cellSpecWithReuseIdentifier:@"generic"];
    sheetCellSpec.configurationBlock = ^(UITableViewCell *cell)
    {
        cell.textLabel.text = @"DDBlockActionSheet";
        cell.accessoryType = UITableViewCellAccessoryNone;
    };
    sheetCellSpec.selectedBlock = ^()
    {
        DDBlockActionSheet *sheet = [DDBlockActionSheet actionSheetWithTitle:@"DDBlockActionSheet"];
        [sheet addDestructiveButtonWithTitle:@"Destruct!" handler:^{
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            deselectRow();
        }];
        [sheet addButtonWithTitle:@"Normal" handler:deselectRow];
        [sheet addCancelButtonWithTitle:@"Cancel" handler:deselectRow];
        [sheet showInView:self.view];
    };
    
    // Set up the table datasource/delegate.
    
    __block DDBlockTableSectionSpec *section1 = [DDBlockTableSectionSpec sectionSpecWithCellSpecs:
                                                 tableCellSpec, alertCellSpec, sheetCellSpec, nil];
    
    tableDelegate = [[DDBlockTableDelegate alloc] init];
    tableDelegate.sectionSpecs = [NSArray arrayWithObjects:section1, nil];
    self.tableView.dataSource = tableDelegate;
    self.tableView.delegate = tableDelegate;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [tableDelegate release];
    tableDelegate = nil;
}

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

@end
