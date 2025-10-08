import Testing
import Foundation

/**
 # 5 Actors and Isolation
    - Second of two big parts of Swift Concurrency
    - Prevent data races in __shared mutable state__
    - General thread safety in Swift
    - Sendable types
    - Isolation Domains
        - actor instances
        - global actors
        - nonisolated
    - Comparison: caller and callee
    - Reentrancy
    - Synchronous Transactions
    - Alternatives:
        - Mutex, OSAllocatedUnfairLock
    - Strict Concurrency
        - global variables
        - global actor isolated types are sendable
        - `Sendable`, `@Sendable`, `sending`
        - region based isolation
        - `assumeIsolated`
*/

#if RunIsolationTests
@Suite struct Isolation {

    final class BankAccount {
        public var balance = 0

        func transfer(_ amount: Int) async {
            balance += amount
        }
    }

    func performSomeTransactions(on account: BankAccount) async -> Int {
        await withTaskGroup { group in
            for _ in 1 ... 1000 {
                group.addTask { await account.transfer(1) }
            }
            await group.waitForAll()
            return account.balance
        }
    }

    @Test func testActorIsolation() async {
        let account = BankAccount()
        let newBalance = await performSomeTransactions(on: account)
        #expect(newBalance == 1000)
    }
}
#endif
