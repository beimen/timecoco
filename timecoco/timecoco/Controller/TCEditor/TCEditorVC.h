//
//  TCEditorVC.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TCEditorVCAdd = 0,
    TCEditorVCEdit
    
} TCEditorVCType;

@interface TCEditorVC : UIViewController

@property (nonatomic, copy) TCDairy *editDairy;

@end
