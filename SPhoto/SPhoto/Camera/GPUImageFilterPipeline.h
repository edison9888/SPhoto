

#import "SFilter.h"

@interface GPUImageFilterPipeline : NSObject

@property (strong) NSMutableArray *filters;

@property (strong) GPUImageOutput *input;
@property (strong) id <GPUImageInput> output;

- (id) initWithOrderedFilters:(NSArray*) filters input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;
- (id) initWithConfiguration:(NSDictionary*) configuration input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;
- (id) initWithConfigurationFile:(NSURL*) configuration input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;

- (void) addFilter:(SFilter*)filter;
- (void) addFilter:(SFilter*)filter atIndex:(NSUInteger)insertIndex;
- (void) replaceFilterAtIndex:(NSUInteger)index withFilter:(SFilter*)filter;
- (void) replaceAllFilters:(NSArray*) newFilters;
- (void) removeFilterAtIndex:(NSUInteger)index;
- (void) removeAllFilters;

- (UIImage *) currentFilteredFrame;
- (CGImageRef) newCGImageFromCurrentFilteredFrame;

@end
