
//
//  SettingsViewController.h
//  PasswordManager
//
//  Created by Admin on 14.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate <NSObject>


@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
