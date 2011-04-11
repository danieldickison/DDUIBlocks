//
//  DDStaticTableViewDelegate.m
//  DDStaticTableViewDemo
//
//  Created by Daniel Dickison on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DDBlockTableDelegate.h"


@interface DDBlockTableDelegate ()

@property (readwrite, nonatomic, assign) UITableView *currentTableView;
@property (readwrite, nonatomic, assign) NSIndexPath *currentIndexPath;
@property (readwrite, nonatomic, assign) UITableViewCell *currentCell;

- (DDBlockTableCellSpec *)startProcessingTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)endProcessing;

@end

@interface DDBlockTableSectionSpec ()

@property (readwrite, nonatomic, assign) DDBlockTableDelegate *tableViewDelegate;

@end

@interface DDBlockTableCellSpec ()

@property (readwrite, nonatomic, assign) DDBlockTableSectionSpec *sectionSpec;

@end


@implementation DDBlockTableDelegate

@synthesize currentTableView;
@synthesize currentCell;
@synthesize currentIndexPath;
@synthesize sectionSpecs;

- (void)dealloc
{
    [sectionSpecs release];
    [super dealloc];
}

- (DDBlockTableCellSpec *)startProcessingTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    self.currentTableView = tableView;
    self.currentIndexPath = indexPath;
    return [self cellSpecAtIndexPath:indexPath];
}

- (void)endProcessing
{
    self.currentTableView = nil;
    self.currentIndexPath = nil;
    currentCell = nil;
}

- (UITableViewCell *)currentCell
{
    if (!currentCell && self.currentIndexPath && self.currentTableView)
    {
        currentCell = [self.currentTableView cellForRowAtIndexPath:self.currentIndexPath];
    }
    return currentCell;
}

- (void)setSectionSpecs:(NSArray *)newSpecs
{
    if (newSpecs != sectionSpecs)
    {
        for (DDBlockTableSectionSpec *spec in sectionSpecs)
        {
            spec.tableViewDelegate = nil;
        }
        [sectionSpecs release];
        sectionSpecs = [newSpecs copy];
        for (DDBlockTableSectionSpec *spec in sectionSpecs)
        {
            spec.tableViewDelegate = self;
        }
    }
}

- (DDBlockTableSectionSpec *)sectionSpecAtIndex:(NSInteger)section
{
    if (section >= [sectionSpecs count]) return nil;
    else return [self.sectionSpecs objectAtIndex:section];
}

- (DDBlockTableCellSpec *)cellSpecAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *cellSpecs = [self sectionSpecAtIndex:indexPath.section].cellSpecs;
    if (indexPath.row >= [cellSpecs count]) return nil;
    else return [cellSpecs objectAtIndex:indexPath.row];
}

- (void)insertCellSpec:(DDBlockTableCellSpec *)cellSpec atIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableSectionSpec *sectionSpec = [self sectionSpecAtIndex:indexPath.section];
    NSMutableArray *newCellSpecs = [sectionSpec.cellSpecs mutableCopy];
    [newCellSpecs insertObject:cellSpec atIndex:indexPath.row];
    sectionSpec.cellSpecs = newCellSpecs;
    [newCellSpecs release];
    
    //[self.currentTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView reloadData];
}

- (void)deleteCellSpecAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableSectionSpec *sectionSpec = [self sectionSpecAtIndex:indexPath.section];
    NSMutableArray *newCellSpecs = [sectionSpec.cellSpecs mutableCopy];
    [newCellSpecs removeObjectAtIndex:indexPath.row];
    sectionSpec.cellSpecs = newCellSpecs;
    [newCellSpecs release];
    
    //[self.currentTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionSpecs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self sectionSpecAtIndex:section].cellSpecs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DDBlockTableSectionSpec *sectionSpec = [self sectionSpecAtIndex:section];
    if (sectionSpec.headerBlock) return sectionSpec.headerBlock();
    else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    DDBlockTableSectionSpec *sectionSpec = [self sectionSpecAtIndex:section];
    if (sectionSpec.footerBlock) return sectionSpec.footerBlock();
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self startProcessingTableView:tableView indexPath:indexPath];
    CGFloat height;
    if (cellSpec.heightBlock) height = cellSpec.heightBlock();
    else height = tableView.rowHeight;
    [self endProcessing];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self startProcessingTableView:tableView indexPath:indexPath];
    self.currentCell = [tableView dequeueReusableCellWithIdentifier:cellSpec.reuseIdentifier];
    if (!self.currentCell)
    {
        if (cellSpec.creationBlock)
            self.currentCell = cellSpec.creationBlock();
        else
            self.currentCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSpec.reuseIdentifier] autorelease];
    }
    cellSpec.configurationBlock(self.currentCell);
    UITableViewCell *cell = self.currentCell;
    [self endProcessing];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self cellSpecAtIndexPath:indexPath];
    return (cellSpec.insertionBlock != NULL || cellSpec.deletionBlock != NULL);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self cellSpecAtIndexPath:indexPath];
    if (cellSpec.insertionBlock != NULL) return UITableViewCellEditingStyleInsert;
    else if (cellSpec.deletionBlock != NULL) return UITableViewCellEditingStyleDelete;
    else return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self startProcessingTableView:tableView indexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleInsert &&
        cellSpec.insertionBlock)
    {
        cellSpec.insertionBlock();
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete &&
             cellSpec.deletionBlock)
    {
        cellSpec.deletionBlock();
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self startProcessingTableView:tableView indexPath:indexPath];
    NSIndexPath *path = indexPath;
    if (!cellSpec.selectedBlock) path = nil;
    [self endProcessing];
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self startProcessingTableView:tableView indexPath:indexPath];
    cellSpec.selectedBlock();
    [self endProcessing];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self startProcessingTableView:tableView indexPath:indexPath];
    if (cellSpec.deselectedBlock) cellSpec.deselectedBlock();
    [self endProcessing];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    DDBlockTableCellSpec *cellSpec = [self startProcessingTableView:tableView indexPath:indexPath];
    if (cellSpec.accessoryTappedBlock) cellSpec.accessoryTappedBlock();
    [self endProcessing];
}

@end


@implementation DDBlockTableSectionSpec

@synthesize cellSpecs;
@synthesize footerBlock;
@synthesize headerBlock;
@synthesize tableViewDelegate;

- (void)dealloc
{
    [cellSpecs release];
    [footerBlock release];
    [headerBlock release];
    [super dealloc];
}

+ (DDBlockTableSectionSpec *)sectionSpecWithCellSpecs:(DDBlockTableCellSpec *)firstObj, ...
{
    NSMutableArray *specs = [NSMutableArray array];
    va_list args;
    va_start(args, firstObj);
    for (DDBlockTableCellSpec *spec = firstObj; spec != nil; spec = va_arg(args, DDBlockTableCellSpec *))
    {
        [specs addObject:spec];
    }
    DDBlockTableSectionSpec *spec = [[[self alloc] init] autorelease];
    spec.cellSpecs = specs;
    return spec;
}

- (NSUInteger)sectionIndex
{
    return [self.tableViewDelegate.sectionSpecs indexOfObject:self];
}

- (void)setCellSpecs:(NSArray *)newSpecs
{
    if (newSpecs != cellSpecs)
    {
        for (DDBlockTableCellSpec *spec in cellSpecs)
        {
            spec.sectionSpec = nil;
        }
        [cellSpecs release];
        cellSpecs = [newSpecs copy];
        for (DDBlockTableCellSpec *spec in cellSpecs)
        {
            spec.sectionSpec = self;
        }
    }
}

@end


@implementation DDBlockTableCellSpec

@synthesize accessoryTappedBlock;
@synthesize creationBlock;
@synthesize configurationBlock;
@synthesize deletionBlock;
@synthesize deselectedBlock;
@synthesize heightBlock;
@synthesize insertionBlock;
@synthesize selectedBlock;
@synthesize sectionSpec;
@synthesize reuseIdentifier;

- (void)dealloc
{
    [accessoryTappedBlock release];
    [creationBlock release];
    [configurationBlock release];
    [deletionBlock release];
    [deselectedBlock release];
    [heightBlock release];
    [insertionBlock release];
    [selectedBlock release];
    [reuseIdentifier release];
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)identifier
{
    if ((self = [super init]))
    {
        reuseIdentifier = [identifier copy];
    }
    return self;
}

- (id)init
{
    return [self initWithReuseIdentifier:nil];
}

+ (DDBlockTableCellSpec *)cellSpecWithReuseIdentifier:(NSString *)identifier
{
    return [[[self alloc] initWithReuseIdentifier:identifier] autorelease];
}

- (NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:[self.sectionSpec.cellSpecs indexOfObject:self]
                              inSection:self.sectionSpec.sectionIndex];
}

@end
