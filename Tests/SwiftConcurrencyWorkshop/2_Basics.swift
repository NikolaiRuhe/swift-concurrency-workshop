import Testing
import Foundation

/**
 # 2 Basics: async/await
    - `await` suspends tasks
        - locks or semaphores block threads
    - Threads are expensive: stack size, kernel resources
    - Thread context switch is slower than suspending/resuming a task
    - Threads scheduled by OS, Tasks scheduled by process
    - Tasks are very lightweight
    - `Task.sleep` vs. `Thread.sleep`

 ## 2.1 Continuations
    - compiler generated
    - Swift standard library type
*/

@Suite @MainActor struct AsyncAwait {

    @Test func synchronousSleep() {
        print("falling asleep...")
        Thread.sleep(forTimeInterval: 10)
        print("wake up")
    }

    @Test func asynchronousSleep() async {
        print("falling asleep...")
        try? await Task.sleep(for: .seconds(10))
        print("wake up")
    }

    @Test func continuation() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 10) {
                continuation.resume()
            }
        }
    }
}

/**
 ## 2.2 Problems with async
     - async functions can only be called from async context
     - Bob Nystrom: "What Color is Your Function?", Feb. 2015
       https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/
*/

struct RedBlue {
    func blueFunction() {}
    func redFunction() async {}

    func asynchronousContext() async {
        blueFunction()
        await redFunction()
    }

    func synchronousContext() {
        blueFunction()
        Task { await redFunction() }
    }
}
