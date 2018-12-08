## My comments are based off of Daniele Pigni's very helpful
## PA2-clarifying_instructions repository on github. 

## makeCacheMatrix is a function that stores a list of 4 functions; set, get, setInverse
## and getInverse.
makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL
  
  ## set is a function that changes the matrix stored in the main function.
  ## We don't need to use this function unless we want to change the matrix. 
  set <- function(y) {
    ## "x <<- y" substitutes the matrix x with y (the input) in the main function (makeCacheMatrix). 
    ## If it was "x <- y" it would have substitute the matrix x with y only in the set function. 
    x <<- y
    ## "inv <<- NULL" restores to null the value of the inverse inv, because the old inverse of the old 
    ## matrix is not needed anymore. The new inverse needs to be recalculated through the function cacheSolve.
    inv <<- NULL
  }
  
  ## get is a function that returns the matrix x stored in the main function. 
  ## It Doesn't require any input.
  get <- function() x
  
##  setInverse and getInverse are functions very similar to set and get. 
## They don't calculate the inverse, they simply store the value of the input in 
## a variable inv into the main function makeCacheMatrix (setInverse) and return it (getInverse).
  setInverse <- function(i) inv <<- i
  getInverse <- function() inv

## To store the 4 functions in the function makeCacheMatrix, we need the function list(), 
## so that when we assign makeCacheMatrix to an object, the object has all the 4 functions.
  list(set = set, get = get,
       setInverse = setInverse,
       getInverse = getInverse)

}


## input of cacheSolve is the object where makeCacheMatrix is stored.

cacheSolve <- function(x, ...) {
  ## The first thing cachemean does is to verify the value inv, 
  ## stored previously with getInverse, exists and is not NULL.
  inv <- x$getInverse()
  if(!is.null(inv)) {
  ##  If it exists in memory, it simply returns a message and the value inv, 
  ##  that is supposed to be the inverse, but not necessarily.
    message("getting cached data")
    return(inv)
  }
  
  ## data gets the matrix stored with makeCacheMatrix
  data <- x$get()
  ## inv calculates the inverse of the matrix and 
  ## x$setInverse(inv) stores it in the object generated assigned with makeCacheMatrix.
  inv <- solve(data)
  x$setInverse(inv)
  inv
}
