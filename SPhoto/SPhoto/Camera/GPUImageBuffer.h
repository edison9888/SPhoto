#import "SFilter.h"

@interface GPUImageBuffer : SFilter
{
    NSMutableArray *bufferedTextures;
}

@property(readwrite, nonatomic) NSUInteger bufferSize;

@end
