//
//  RoutingEntry.m
//  Frank
//
//  Created by Pete Hodgson on 7/7/13.
//
//

#import "RoutingEntry.h"

@interface RoutingEntry() {
    NSString *_path;
    NSArray *_supportedMethods;
    Class _handlerClass;
}
@end

@implementation RoutingEntry

- (id)initForPath:(NSString *)path
supportingMethods:(NSArray *)methods
   handledByClass:(Class)handlerClass
{
    self = [super init];
    if (self) {
        // TODO: normalize path (e.g. strip trailing /)
        _path = [path copy];
        _supportedMethods = [methods retain];
        _handlerClass = handlerClass;
    }
    return self;
}

- (void)dealloc
{
    [_path release];
    [_supportedMethods release];

    [super dealloc];
}

- (BOOL)handlesPath:(NSArray *)pathComponents{
    NSString *incomingPath = [@"/" stringByAppendingString:[pathComponents componentsJoinedByString:@"/"]];
    return( NSOrderedSame == [incomingPath compare:_path options:NSCaseInsensitiveSearch] );
}

- (BOOL)supportsMethod:(NSString *)method{
    NSPredicate *containsMethod = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",method];
    return ([[_supportedMethods filteredArrayUsingPredicate:containsMethod] count] > 0);
}

- (NSObject<HTTPRequestHandler> *)newHandlerWithContext:(HTTPRequestContext *)context
{
    return [[_handlerClass alloc] initWithContext:context];
}

@end