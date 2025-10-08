import Testing
import Foundation

/**
 # 3 Structured Concurrency
    - _structured_ like in structured code
    - Nathaniel J. Smith: "Notes on structured concurrency", Apr. 2018
      https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/
    - 2 x 2 ways to create tasks:
        - _unstructured_ Task
            - `Task {}`
            - `Task.detached {}`
        - _structured_ Task
            - Task group
            - `async let`
    - Terms: "child task", "detached task"
        - https://forums.swift.org/t/why-asyncstream-breaks-structured-concurrency/71477/3
    - Cancellation
    - Priority
    - Task Local Values
    - `SwiftUI.View.task() {}`
*/

@Suite struct StructuredVsUnstructuredTasks {
    @Test("Task {}")
    func unstructuredTask1() {
        Task {
            print("unstructured")
        }
    }

    @Test("Task.detached {}")
    func unstructuredTask2() {
        Task.detached {
            print("unstructured, detached")
        }
    }

    @Test("async let")
    func structuredTask1() async {
        async let result = someComputation()

        #expect(await result == 42)
    }

    @Test("withTaskGroup")
    func structuredTask2() async {
        let result = await withTaskGroup { group in
            for _ in 1 ... 10 {
                group.addTask { await someComputation() }
            }
            var result = 0
            for await partialResult in group {
                result += partialResult
            }
            return result
        }

        #expect(result == 420)
    }

    func someComputation() async -> Int {
        try? await Task.sleep(for: .seconds(1))
        return 42
    }
}
