//
//  Picker.h
//  Unity-iPhone
//
//  Created by thedoritos on 11/19/16.
//
//

#import <UIKit/UIKit.h>

@interface Picker : NSObject<UIDocumentPickerDelegate, UINavigationControllerDelegate>

// UnityGLViewController keeps this instance.
@property(nonatomic) UIDocumentPickerViewController* pickerController;

@property(nonatomic) NSString *outputFileName;

+ (instancetype)sharedInstance;

- (void)show:(NSString *)title outputFileName:(NSString *)name maxSize:(NSInteger)maxSize;

@end
