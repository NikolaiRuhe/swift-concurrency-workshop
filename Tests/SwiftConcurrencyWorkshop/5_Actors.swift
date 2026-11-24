import Testing
import Foundation

/**
 # 5 Actors
    - Prevent data races in __shared mutable state__
    - provide general thread safety in Swift
        - by isolating their state
    - Comparison to GCD
        - caller and callee
    - Reentrancy in actors
    - Synchronous Transactions
        - potential suspension points
    - Alternatives:
        - Mutex, OSAllocatedUnfairLock
*/

actor BankAccount {
    var balance = 0

    func transfer(_ amount: Int) async {
        let originalBalance = balance
        balance += amount

        if await authorizeTransfer(amount) == false {
            balance = originalBalance
        }
    }

    @MainActor func authorizeTransfer(_ amount: Int) -> Bool {
        return amount > 0
    }
}

func performSomeTransactions(on account: BankAccount) async -> Int {
    await withTaskGroup { group in
        for _ in 1 ... 1000 {
            group.addTask { await account.transfer(1) }
        }
        for _ in 1 ... 1000 {
            group.addTask { await account.transfer(-1) }
        }
        await group.waitForAll()
        return await account.balance
    }
}

@Test func testActorIsolation() async {
    let account = BankAccount()
    let newBalance = await performSomeTransactions(on: account)
    #expect(newBalance == 1000)
}
