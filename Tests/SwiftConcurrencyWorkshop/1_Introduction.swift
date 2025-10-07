import Testing
import Foundation

/**
 # 1 Introduction to Swift Concurrency
    - What is it?
        - Just another abstraction on threads?
    - Which problems does it solve?
        1. Handle future events
        2. Performance
    - What did we use before?
        - Grand Central Dispatch, threads, and even: processes
        - Event loops, observation, reactive frameworks, ...
    - Why not use it? Are there better options?
        - It's hard!
        - Don't use concurrency if you don't need it (really)

 ## 1.1 Terms and Definitions
    - Concurrent vs. Parallel
    - Threads, Queues and Tasks
    - __Swift__ Concurrency
        - Umbrella term
        - async await, actors, async sequence, ...
    - __Structured__ Concurrency
        - Child tasks
    - __Strict__ Concurrency
        - Isolate Shared Mutable State
        - Statically enforced
    - __Approachable__ Concurrency
        - Xcode build setting
        - Available in Swift 6.2
        - Default actor isolation @MainActor (SE-0466)
        - Infer isolated conformances (SE-0470)
        - nonisolated(nonsending) by default (SE-0461)
 */
