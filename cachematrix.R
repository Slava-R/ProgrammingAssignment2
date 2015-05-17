## R script is able to cache potentially time-consuming computations on matrices: 
## The following two functions work together to calculate the inverse of an invertible matrix
## and make it available in the cache environment; so that if the matrix has been cached before,
## the inverted matrix will be returned right away rather than being computed repeatedly

## The following function makeCacheMatrix creates a special "matrix" object (that can cache the inverse) -
## a list containing a function to set the value of the matrix, get the value of the matrix, 
## set the inverse of the matrix, and get the inverse of the matrix

makeCacheMatrix <- function(x = matrix()) {
    
    inv <- NULL
    set <- function(y) {                    ## Set the value of the matrix
        x <<- y
        inv <<- NULL
    }
    
    get <- function() x                     ## Get the value of the matrix
    setinverse <- function(inverse) inv <<- inverse         ## Set the inverse of the matrix
    getinverse <- function() inv                            ## Get the inverse of the matrix
    list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)        ## Create ""matrix" object
}


## The following function cacheSolve computes the inverse of the special "matrix" returned by the makeCacheMatrix above:
## It first checks to see if the inverse of the matrix has already been calculated (and the matrix has not changed) -
## If so, it gets the inverse from the cache and skips the computation; otherwise, 
## it calculates the inverse of the data and sets the inverse matrix in the cache via the setinverse function

cacheSolve <- function(x, ...) {
    
    inv <- x$getinverse()           ## Get the inverse "matrix" data from the cache
    if(!is.null(inv)) {             ## Check if the inverse of the matrix has already been calculated
        message("getting cached data")
        return(inv)                 ## Return the cached version of inverse matrix
    }
    
    data <- x$get()                 ## Get the data
    inv <- solve(data, ...)         ## Calculate the inverse of the invertible (square) 'data' matrix
    x$setinverse(inv)               ## Set the inverse matrix in the cache
    inv                             ## Return a matrix that is the inverse of 'x'
}