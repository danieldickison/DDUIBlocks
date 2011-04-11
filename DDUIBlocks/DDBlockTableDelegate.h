//
//  DDStaticTableViewDelegate.h
//  DDStaticTableViewDemo
//
//  Created by Daniel Dickison on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDBlockTableCellSpec;
@class DDBlockTableSectionSpec;
@class DDBlockTableDelegate;


typedef id (^DDBlockTableIdBlock)();
typedef void (^DDBlockTableVoidBlock)();
typedef int (^DDBlockTableIntBlock)();
typedef CGFloat (^DDBlockTableFloatBlock)();
typedef void (^DDBlockTableCellConfigBlock)(UITableViewCell *cell);



@interface DDBlockTableDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *sectionSpecs;
- (DDBlockTableSectionSpec *)sectionSpecAtIndex:(NSInteger)section;
- (DDBlockTableCellSpec *)cellSpecAtIndexPath:(NSIndexPath *)indexPath;

// If these are called from a cell spec callback, it is automatically animated in the current table view. Otherwise, the caller is responsible for reloading the data in the table view. This can only be used to insert a row into an existing section.
- (void)insertCellSpec:(DDBlockTableCellSpec *)cellSpec atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteCellSpecAtIndexPath:(NSIndexPath *)indexPath;

@property (readonly, nonatomic, assign) NSIndexPath *currentIndexPath;
@property (readonly, nonatomic, assign) UITableViewCell *currentCell;
@property (readonly, nonatomic, assign) UITableView *currentTableView;

@end



@interface DDBlockTableSectionSpec : NSObject

+ (DDBlockTableSectionSpec *)sectionSpecWithCellSpecs:(DDBlockTableCellSpec *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

// Return an NSString. No support currently for returning arbitrary UIViews.
@property (nonatomic, copy) DDBlockTableIdBlock headerBlock;
@property (nonatomic, copy) DDBlockTableIdBlock footerBlock;

@property (nonatomic, copy) NSArray *cellSpecs;
@property (readonly, nonatomic, assign) DDBlockTableDelegate *tableViewDelegate;
@property (readonly, nonatomic) NSUInteger sectionIndex;

@end



@interface DDBlockTableCellSpec : NSObject
{
@private
    NSString *reuseIdentifier;
}

- (id)initWithReuseIdentifier:(NSString *)identifier;
+ (DDBlockTableCellSpec *)cellSpecWithReuseIdentifier:(NSString *)identifier;

// configurationBlock is the only required callback. Use cellSpec.sectionSpec.tableViewDelegate.currentCell to access the cell instance.
@property (nonatomic, copy) DDBlockTableCellConfigBlock configurationBlock;

@property (nonatomic, copy) DDBlockTableFloatBlock heightBlock;
@property (nonatomic, copy) DDBlockTableVoidBlock insertionBlock;
@property (nonatomic, copy) DDBlockTableVoidBlock deletionBlock;

@property (nonatomic, copy) DDBlockTableIdBlock creationBlock;
@property (nonatomic, copy) DDBlockTableVoidBlock selectedBlock;
@property (nonatomic, copy) DDBlockTableVoidBlock deselectedBlock;
@property (nonatomic, copy) DDBlockTableVoidBlock accessoryTappedBlock;

@property (readonly, nonatomic) NSString *reuseIdentifier;

// The "parent" section spec object. This gets set automatically when a cell spec is added to a section spec.
@property (readonly, nonatomic, assign) DDBlockTableSectionSpec *sectionSpec;

// Only valid when this is part of a section spec in a DDBlockTableViewDelegate.
@property (readonly, nonatomic) NSIndexPath *indexPath;

@end
