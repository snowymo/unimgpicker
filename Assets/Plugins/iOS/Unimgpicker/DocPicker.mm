//
//  Picker.mm
//  Unity-iPhone
//
//  Created by Zhenyi He on 11/1/17.
//
//

#import "DocPicker.h"

#pragma mark Config

const char* CALLBACK_OBJECT = "Unimgpicker";
const char* CALLBACK_METHOD = "OnComplete";
const char* CALLBACK_METHOD_FAILURE = "OnFailure";

const char* MESSAGE_FAILED_PICK = "Failed to pick the doc";
const char* MESSAGE_FAILED_FIND = "Failed to find the doc";
const char* MESSAGE_FAILED_COPY = "Failed to copy the doc";

#pragma mark Picker

@implementation Picker

+ (instancetype)sharedInstance {
    static Picker *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[Picker alloc] init];
    });
    return instance;
}

- (void)show:(NSString *)title outputFileName:(NSString *)name maxSize:(NSInteger)maxSize {
	NSLog(@"In show function() before pickerCtrl check");
    if (self.pickerController != nil) {
    	NSLog(@"In show function() pickerCtrl not nil");
        UnitySendMessage(CALLBACK_OBJECT, CALLBACK_METHOD_FAILURE, MESSAGE_FAILED_PICK);
        return;
    }
    
    self.pickerController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.item"] inMode:UIDocumentPickerModeImport];
    self.pickerController.delegate = self;
    
    //self.pickerController.allowsEditing = NO;
    //self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIViewController *unityController = UnityGetGLViewController();
    [unityController presentViewController:self.pickerController animated:YES completion:^{
        self.outputFileName = name;
    }];
}

#pragma mark UIDocPickerControllerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    if(!urls[0].isFileURL){
    	UnitySendMessage(CALLBACK_OBJECT, CALLBACK_METHOD_FAILURE, MESSAGE_FAILED_FIND);
        [self dismissPicker];
        return;
	}

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count == 0) {
        UnitySendMessage(CALLBACK_OBJECT, CALLBACK_METHOD_FAILURE, MESSAGE_FAILED_COPY);
        [self dismissPicker];
        return;
    }

    NSString *fileName = self.outputFileName;
    NSString *fileSavePath = [(NSString *)[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSError* error = nil;
    NSString * filedata = [NSString stringWithContentsOfURL:urls[0] encoding:NSUTF8StringEncoding error:&error];

	if (filedata == nil) {
		// an error occurred
        UnitySendMessage(CALLBACK_OBJECT, CALLBACK_METHOD_FAILURE, MESSAGE_FAILED_COPY);
        [self dismissPicker];
        return;
	}

    BOOL success = [filedata writeToFile:fileSavePath atomically:YES];
    if (success == NO) {
        UnitySendMessage(CALLBACK_OBJECT, CALLBACK_METHOD_FAILURE, MESSAGE_FAILED_COPY);
        [self dismissPicker];
        return;
    }
    
    UnitySendMessage(CALLBACK_OBJECT, CALLBACK_METHOD, [fileSavePath UTF8String]);
    
    [self dismissPicker];

}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    UnitySendMessage(CALLBACK_OBJECT, CALLBACK_METHOD_FAILURE, MESSAGE_FAILED_PICK);
    
    [self dismissPicker];
}

- (void)dismissPicker
{
	NSLog(@"In dismissPicker function()");
    self.outputFileName = nil;
    
    if (self.pickerController != nil) {
    	NSLog(@"In dismissPicker function() pickerCtrl not nil");
    	//[controller dismissViewControllerAnimated:YES completion:nil]
        [self.pickerController dismissViewControllerAnimated:YES completion:^{
            self.pickerController = nil;
            NSLog(@"In dismissPicker function() assign pickerCtrl to nil");
        }];
    }
    if (self.pickerController != nil){
    	NSLog(@"In dismissPicker function() pickerCtrl not nil still");
    	self.pickerController = nil;

    }
}

@end

#pragma mark Unity Plugin

extern "C" {
    void Undocpicker_show(const char* title, const char* outputFileName, int maxSize) {
    	NSLog(@"In Undocpicker_show function()");
        Picker *picker = [Picker sharedInstance];
        NSLog(@"In Undocpicker_show after sharedInstance");
        [picker show:[NSString stringWithUTF8String:title] outputFileName:[NSString stringWithUTF8String:outputFileName] maxSize:(NSInteger)maxSize];
    }
}
