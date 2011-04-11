//
//  DDBlockAlert.h
//  DDUIBlockDemo
//
//  Created by Daniel Dickison on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBlockAlert : NSObject <UIAlertViewDelegate>
{
@private
    UIAlertView *alertView;
    NSMutableArray *buttonHandlers;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message;
+ (DDBlockAlert *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title handler:(void(^)())handler;
- (void)addCancelButtonWithTitle:(NSString *)title handler:(void(^)())handler;
- (void)show;
- (void)dismissWithClickedButtonIndex:(NSUInteger)buttonIndex animated:(BOOL)animated;

@end


@interface DDBlockActionSheet : NSObject <UIActionSheetDelegate>
{
@private
    UIActionSheet *actionSheet;
    NSMutableArray *buttonHandlers;
}

- (id)initWithTitle:(NSString *)title;
+ (DDBlockActionSheet *)actionSheetWithTitle:(NSString *)title;

- (void)addButtonWithTitle:(NSString *)title handler:(void(^)())handler;
- (void)addCancelButtonWithTitle:(NSString *)title handler:(void(^)())handler;
- (void)addDestructiveButtonWithTitle:(NSString *)title handler:(void(^)())handler;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromToolbar:(UIToolbar *)toolbar;
- (void)showInView:(UIView *)view;

@end

