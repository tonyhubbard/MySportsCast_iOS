//
//  UIImageView+Network.m
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import "UIImageView+Network.h"
#import "FTWCache.h"
#import <objc/runtime.h>
#import "UIImageView+Network.h"
#import "NSString+MD5.h"

static char URL_KEY;


@implementation UIImageView(Network)

@dynamic imageURL;

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key {
    //here key is url.
	self.imageURL = url;
	self.image = [UIImage imageNamed:@"placeHolder.png"];
	
    NSString *keyStr = [key MD5Hash];
	NSData *cachedData = [FTWCache objectForKey:keyStr];
	if (cachedData) {   
 	   self.imageURL   = nil;
 	   self.image      = [UIImage imageWithData:cachedData];
	   return;
	}

	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSData *data = [NSData dataWithContentsOfURL:url];
		
		UIImage *imageFromData = [UIImage imageWithData:data];
		
		[FTWCache setObject:data forKey:keyStr];

		if (imageFromData) {
			if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					self.image = imageFromData;
				});
			}
		}
		self.imageURL = nil;
	});
}

- (void) setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
	return objc_getAssociatedObject(self, &URL_KEY);
}

-(void)loagImageFromURLInHigh:(NSString *)url{
    NSURL *imageURL = [NSURL URLWithString:url];
	NSString *key = [url MD5Hash];
	NSData *data = [FTWCache objectForKey:key];
	if (data) {
		UIImage *image = [UIImage imageWithData:data];
		//imgLoading.image = image;
        self.image=image;
	}
    else {
		self.image = [UIImage imageNamed:@"placeHolder.png"];
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
		dispatch_async(queue, ^{
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			[FTWCache setObject:data forKey:key];
			UIImage *image = [UIImage imageWithData:data];
			dispatch_sync(dispatch_get_main_queue(), ^{
				self.image = image;
			});
		});
        
    }
}

-(void)loagImageFromURL:(NSString *)url{
    
    if(url != nil)
    {
        
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *imageURL = [NSURL URLWithString:url];
	NSString *key = [url MD5Hash];
	NSData *data = [FTWCache objectForKey:key];
	if (data) {
		UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
        
	}
    else {

		self.image = [UIImage imageNamed:@"profile_image"];
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
		dispatch_async(queue, ^{
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			[FTWCache setObject:data forKey:key];
			UIImage *image = [UIImage imageWithData:data];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.image = image;
			});
		});
    
        }
    }
}
-(void)removeImageFromURLKey:(NSString *)key{
    if ([key length]) {
        [FTWCache removeImage:[self getDocumentLocalPath:key]];

    }
}

-(NSString *)getDocumentLocalPath:(NSString *)pdfURL{
    
    pdfURL = [pdfURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *key = [pdfURL MD5Hash];
    return [FTWCache getDocumentPath:key];
}
-(NSString*)getImageFromKey:(NSString *)urlKey{
    
    return [FTWCache getDocumentPath:urlKey];
}


- (double) detectCollisionsInArray:(NSMutableArray*)objects
{
    NSInteger count = [objects count];
    if (count > 0)
    {
        double time = CFAbsoluteTimeGetCurrent();
        
        
        
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        for (int i = 0; i < count; i++)
        {
            
            NSString  *url = [[[objects objectAtIndex:i] objectForKey:@"downloadImage"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *imageURL = [NSURL URLWithString:url];
            NSString *key = [url MD5Hash];
            
            
            dispatch_group_async(group, queue, ^{
                for (int j = i + 1; j < count; j++)
                {
                    dispatch_group_async(group, queue, ^{
                        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                        [FTWCache setObject:data forKey:key];
                        UIImage *image = [UIImage imageWithData:data];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            self.image = image;
                        });
                    });
                }
            });
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        return CFAbsoluteTimeGetCurrent() - time;
    }
    return 0;
}

@end
