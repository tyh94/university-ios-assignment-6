//
//  NewRecordViewController.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordViewController;

/**
 *  The protocol describing the duties the instance of @c NewRecordViewController
 *  are able to delegate.
 */
@protocol RecordViewControllerDelegate <NSObject>

/**
 *  Notifies the receiver that the sender has finished its job.
 *
 *  @param[in]  record  The record the user wants to register.
 *                      If the user has pressed 'Cancel',
 *                      the @c record is @b nil.
 */
- (void)recordViewController:(RecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record;

@end

@interface RecordViewController : UIViewController

/**
 *  Returns the object that handles the delegated duties.
 */
@property (nonatomic, weak) id<RecordViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDictionary *record;

@end
