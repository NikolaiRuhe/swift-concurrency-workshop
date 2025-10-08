import Testing
import Foundation

/**
 # 4 Forward Progress Contract
    - Swift Concurrency’s Thread Pool
    - Don’t wait on work __that is not yet running on a thread__.
        - Reason: Thread pool starvation.
        - Semaphores are bad!
    - Disadvantages:
        - In a synchronous context there is no way wait for a task to complete!
        - deadlocks
    - Advantages:
        - no deadlocks
        - no thread explosion
*/

@Suite struct ForwardProgress {

    @Test func breakContract() {
        let semaphore = DispatchSemaphore(value: 0)

        func performSomeWork() {
            semaphore.wait()
            Thread.sleep(forTimeInterval: 0.01)
            semaphore.signal()
        }

        for i in 1 ... 3 {
            Task {
                print("did start task \(i)")
                performSomeWork()
            }
        }
        Thread.sleep(forTimeInterval: 0.01)

        Task {
            print("start work")
            semaphore.signal()
        }

        print("wait for tasks to complete...")
        semaphore.wait()
        print("all done")
    }
}
