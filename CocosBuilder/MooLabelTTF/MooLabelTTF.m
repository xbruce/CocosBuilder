//
//  MooLabelTTF.m
//  CocosBuilder
//
//  Created by Bruce Xiao on 13-12-4.
//
//

#import "MooLabelTTF.h"
#import "CCFileUtils.h"
#import "JSONKit.h"
#import "CCLabelTTF.h"

@interface MooLabelTTF()

- (NSString *) getFontName:(NSString *)fontName;

@end

@implementation MooLabelTTF

- (id) init {
    return [self initWithString:@"" fontName:@"Helvetica" fontSize:12];
}

- (id) initWithString:(NSString *)str fontName:(NSString *)name fontSize:(CGFloat)size {
    if ((self = [super init])) {
        _fontName = name;
        _fontSIze = size;
        [self setString:str];
    }
    return self;
}

- (void) setString:(NSString *)label {
    if (_string.hash != label.hash) {
        [_string release];
        _string = [label copy];
        [self refreshView];
    }
}

- (NSString *) string {
    return _string;
}

- (NSString *) getFontName:(NSString *)fontName {
    // Custom .ttf file ?
    if ([[fontName lowercaseString] hasSuffix:@".ttf"])
    {
        // This is a file, register font with font manager
        NSString* fontFile = [[CCFileUtils sharedFileUtils] fullPathForFilename:fontName];
        NSURL* fontURL = [NSURL fileURLWithPath:fontFile];
        CTFontManagerRegisterFontsForURL((CFURLRef)fontURL, kCTFontManagerScopeProcess, NULL);
        
		return [[fontFile lastPathComponent] stringByDeletingPathExtension];
    }
    
    return fontName;
}

- (void) setFontName:(NSString *)fontName {
    fontName = [self getFontName:fontName];
    
	if( fontName.hash != _fontName.hash ) {
		[_fontName release];
		_fontName = [fontName copy];
		
		// Force update
		if( _string )
			[self refreshView];
	}
}

- (NSString *) fontName {
    return _fontName;
}

- (void) setFontSize:(float)fontSize {
    if( fontSize != _fontSIze ) {
		_fontSIze = fontSize;
		
		// Force update
		if( _string )
			[self refreshView];
	}
}

- (void) taskEnded:(NSTask*) task
{
    NSMutableArray* errors = [NSMutableArray array];
    
    if (task.terminationReason == NSTaskTerminationReasonExit)
    {
        // Last started task has ended, parse the output
        
        NSData* data = [[task.standardOutput fileHandleForReading] readDataToEndOfFile];
        NSString* str = [[[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding] autorelease];
        int width = 0;
        int height = 0;
        int idx = 0;
        NSMutableArray *pArray = [str objectFromJSONString];
        for (NSDictionary *pDict in pArray) {
            CCLabelTTF *pLabel = [self createLabelWithDictionary:pDict];
            CGSize size = [pLabel contentSize];
            if (height == 0) {
                height = size.height;
            }
            [pLabel setTag:idx];
            [pLabel setPosition:CGPointMake(width, 0)];
            [self addChild:pLabel];
            width += size.width;
            idx ++;
        }
    
        [self setContentSize:CGSizeMake(width, height)];
    }

    [task release];
    syntaxTask = NULL;
}

- (CCLabelTTF *) createLabelWithDictionary: (NSDictionary *)dict {
    ccColor3B color = ccc3([[dict objectForKey:@"r"] intValue], [[dict objectForKey:@"g"] intValue], [[dict objectForKey:@"b"] intValue]);
    NSString *text = [dict objectForKey:@"text"];
    
    CCLabelTTF *pLabel = [CCLabelTTF labelWithString:text fontName:_fontName fontSize:_fontSIze];
    [pLabel setColor:color];
    [pLabel setAnchorPoint:CGPointMake(0, 0)];
    return pLabel;
}

- (void) refreshView {
    [self removeAllChildren];
    if (syntaxTask && syntaxTask.isRunning)
    {
        // Terminate current task
        [syntaxTask terminate];
        syntaxTask = NULL;
    }
    
    syntaxTask = [[NSTask alloc] init];
    
    NSString* launchPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"nodejs/bin/moolabelttf"];
    
    [syntaxTask setLaunchPath: launchPath];
    [syntaxTask setCurrentDirectoryPath:[launchPath stringByDeletingLastPathComponent]];
    
    NSPipe* outPipe = [NSPipe pipe];
    [syntaxTask setStandardOutput:outPipe];
    
    NSPipe* pipe = [NSPipe pipe];
    [[pipe fileHandleForWriting] writeData:[_string dataUsingEncoding:NSUTF8StringEncoding]];
    [[pipe fileHandleForWriting] closeFile];
    
    
    [syntaxTask setStandardInput:pipe];
    
    [syntaxTask launch];
    
    syntaxTask.terminationHandler = ^(NSTask *task){
        [self performSelectorOnMainThread:@selector(taskEnded:) withObject:task waitUntilDone:YES];
    };
}

- (float) fontSize {
    return _fontSIze;
}

- (void) dealloc
{
	[_string release];
	[_fontName release];
    
	[super dealloc];
}

@end
