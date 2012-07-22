#import "Library.h"

#import "NSManagedObject+ViewAdditions.h"
#import "NSManagedObject+BAAdditions.h"


@implementation Library

+ (NSManagedObject *)insertObject {
    
    Library *library = (Library *)[super insertObject];
    
    library.name = @"New Library";
    
    return library;
}

+ (Library *)insertLibrary {
    return (Library *)[self insertObject];
}

@end
