//
//  TCEditorVC.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TCEditorVCType) {
    TCEditorVCTypeAdd = 0,
    TCEditorVCTypeEdit,

};

@interface TCEditorVC : UIViewController

@property (nonatomic, strong) TCDairyModel *editDairy;
@property (nonatomic, assign) TCEditorVCType type;

@end
