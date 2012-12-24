#import "SFilter.h"

extern NSString * const kGPUImageLuminanceFragmentShaderString;
extern NSString * const kGPUImageNearbyTexelSamplingVertexShaderString;
extern NSString * const kGPUImageSobelEdgeDetectionFragmentShaderString;

/**
 * @brief 素描效果
 */
@interface SSketchFilter : SFilter {
    GLuint secondFilterOutputTexture;
    
    GLProgram *secondFilterProgram;
    GLint secondFilterPositionAttribute, secondFilterTextureCoordinateAttribute;
    GLint secondFilterInputTextureUniform, secondFilterInputTextureUniform2;
    
    GLuint secondFilterFramebuffer;
    
    GLint texelWidthUniform, texelHeightUniform;
    BOOL hasOverriddenImageSizeFactor;
}

@property(readwrite, nonatomic) CGFloat texelWidth;
@property(readwrite, nonatomic) CGFloat texelHeight;

@end
