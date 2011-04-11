//
//  DDBlockAlert.m
//  DDUIBlockDemo
//
//  Created by Daniel Dickison on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DDBlockAlert.h"


@implementation DDBlockAlert

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
{
    if ((self = [super init]))
    {
        alertView = [[UIAlertView alloc] init];
        alertView.title = title;
        alertView.message = message;
        alertView.delegate = self;
        buttonHandlers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}

+ (DDBlockAlert *)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[[self alloc] initWithTitle:title message:message] autorelease];
}

- (void)dealloc
{
    [alertView release];
    [buttonHandlers release];
    [super dealloc];
}

- (void)addButtonWithTitle:(NSString *)title handler:(void(^)())handler
{
    [alertView addButtonWithTitle:title];
    [buttonHandlers addObject:[[handler copy] autorelease]];
}

- (void)addCancelButtonWithTitle:(NSString *)title handler:(void(^)())handler
{
    [self addButtonWithTitle:title handler:handler];
    alertView.cancelButtonIndex = alertView.numberOfButtons - 1;
}

- (void)show
{
    [self retain];
    [alertView show];
}

- (void)dismissWithClickedButtonIndex:(NSUInteger)buttonIndex animated:(BOOL)animated
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^handler)() = [buttonHandlers objectAtIndex:buttonIndex];
    handler();
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self release];
}

@end


@implementation DDBlockActionSheet

- (id)initWithTitle:(NSString *)title
{
    if ((self = [super init]))
    {
        actionSheet = [[UIActionSheet alloc] init];
        actionSheet.title = title;
        actionSheet.delegate = self;
        buttonHandlers = [[NSMutableArray alloc] initWithCapacity:8];
    }
    return self;
}

+ (DDBlockActionSheet *)actionSheetWithTitle:(NSString *)title
{
    return [[[self alloc] initWithTitle:title] autorelease];
}

- (void)dealloc
{
    [actionSheet release];
    [buttonHandlers release];
    [super dealloc];
}

- (void)addButtonWithTitle:(NSString *)title handler:(void(^)())handler
{
    [actionSheet addButtonWithTitle:title];
    [buttonHandlers addObject:[[handler copy] autorelease]];
}

- (void)addCancelButtonWithTitle:(NSString *)title handler:(void(^)())handler
{
    [self addButtonWithTitle:title handler:handler];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
}

- (void)addDestructiveButtonWithTitle:(NSString *)title handler:(void(^)())handler
{
    [self addButtonWithTitle:title handler:handler];
    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    [self retain];
    [actionSheet showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    [self retain];
    [actionSheet showFromRect:rect inView:view animated:animated];
}

- (void)showFromTabBar:(UITabBar *)view
{
    [self retain];
    [actionSheet showFromTabBar:view];
}

- (void)showFromToolbar:(UIToolbar *)toolbar
{
    [self retain];
    [actionSheet showFromToolbar:toolbar];
}

- (void)showInView:(UIView *)view
{
    [self retain];
    [actionSheet showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^handler)() = [buttonHandlers objectAtIndex:buttonIndex];
    handler();
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self release];
}

@end
