Intro to Foundry

```
source /Users/aboutika/.bashrc
forge init
```

## Compile

```
forge build
```

## Test

```
forge test
forge test -vvv
forge test --help
```

## Targeted Test

```
forge test --match-path test/HelloWorld.t.sol
forge test --match-path test/HelloWorld.t.sol -vvv
```

or

```
forge test --match-path test/Counter.t.sol
```

Failing test: we want to test for errors

Calling the `dec()` function will throw an error if there is an underflow (dec 0)

## Gas Reporter

```
forge test --match-path test/Counter.t.sol --gas-report
```

For example, the function `dec()` on average uses 1736 gas and is called 3 times

```
Running 4 tests for test/Counter.t.sol:CounterTest
[PASS] testDec() (gas: 30235)
[PASS] testDecUnderflow() (gas: 10967)
[PASS] testFail() (gas: 7543)
[PASS] testInc() (gas: 28360)
Test result: ok. 4 passed; 0 failed; finished in 871.65µs
| src/Counter.sol:Counter contract |                 |       |        |       |         |
|----------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                  | Deployment Size |       |        |       |         |
| 51705                            | 290             |       |        |       |         |
| Function Name                    | min             | avg   | median | max   | # calls |
| count                            | 261             | 261   | 261    | 261   | 2       |
| dec                              | 466             | 1736  | 2372   | 2372  | 3       |
| inc                              | 444             | 15044 | 22344  | 22344 | 3       |
```

## Fork mainnet (Fork.t.sol)

```
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/... --match-path test/Fork.t.sol -vvv
```

## Set Compiler Version

Inside `foundry.toml` add:

```
solc_version = "0.8.18"
```

## Set Optimizer configurations

```
optimizer = true
optimizer_runs = 200
```

All of the configurations available for your `foundry` project can be found [here](https://github.com/foundry-rs/foundry/tree/master/config)

## Ramapping

There are 2 ways to import `libraries` inside your Foundry project

### Using `forge` command line

```
forge install rari-capital/solmate
```

Then import the library inside the contract like so:

```javascript
import "solmate/tokens/ERC20.sol";
```

Then `contract Token is ERC20("name", "symbol", 18) {}`

To see what files are installed:

```
forge remappings
```

If we wanted to update the `solmate` package, we can do it like so:

```
forge update lib/solmate
```

To remove the library:

```
forge remove solmate
```

### Using `npm` command line with `remappings.txt`

```
npm i @openzeppelin/contracts
```

It creates a new folder => `node_modules`

Then import a library inside the contract like so:

```javascript
import "@openzeppelin/contracts/access/Ownable.sol";
```

Then `contract TestOz is Ownable {}`

After that let's create a file nammed `remappings.txt`

We need to tell `forge` where to look for when it refers to `@openzeppelin`

Inside the `remappings.txt` file:

```
@openzeppelin/=node_modules/@openzeppelin
```

## Format code

```
forge fmt
```

## Console Log

Let's see examples of console logging in the `Counter.sol`contract, and also inside the `Counter.t.sol` test, and finally how to log `int`

### Log from contract

To print something to the `terminal` when we run the test and when we call the function `inc()`

Inside `Counter.sol`, import:

```javascript
import "forge-std/console.log.sol";
```

This is a feature only available for testing, so make sure to remove it when deploying a contract

```javascript
function inc() public {
    console.log("Here", count);
    count += 1;
}
```

Execute the test to see the message logged inside the terminal (-vv needed to print):

```
forge test --match-path test/Counter.t.sol -vv
```

### Log from test

We can also console inside a test contract => `Console.t.sol`

Execute the following command:

```
forge test --match-path test/Console.t.sol -vv
```

Here is the result:

```sh
Running 1 test for test/Console.t.sol:ConsoleTest
[PASS] testLogSomething() (gas: 3392)
Logs:
  Log something here 123

Test result: ok. 1 passed; 0 failed; finished in 12.23ms
```

### Log int

For more details on which values you can log with the console log, using VS CODE you can select `log` and type `F12` to get access to actual code of `console.sol` (or follow the path: lib/forge-std/src/console.sol)

Inside this file you can find all the variations for the messages that it can log.

However, it can not log `int` as we can see in the following compilation error

```sh
Compiler run failed
error[9582]: TypeError: Member "log" not found or not visible after argument-dependent lookup in type(library console).
  --> test/Console.t.sol:11:9:
   |
11 |         console.log(x);
   |         ^^^^^^^^^^^

```

**_We will need to use a specialize function `logInt()`_**

If we try using console.log as below, we'll get a compilation error:

```javascript
contract ConsoleTest is Test {
    function testLogSomething() public {
        console.log("Log something here", 123);

        int x = -1;
        console.log(x);
    }
}
```

We'll need to use `console.logInt(x)` to log `-1`

```sh
Running 1 test for test/Console.t.sol:ConsoleTest
[PASS] testLogSomething() (gas: 3731)
Logs:
  Log something here 123
  -1
```

## Authentication

Using `Wallet.sol` contract, let's see how how to test authentication

### Passing test

(setOwner)

### Fail test

By naming the test function `testFailNotOwner()`, we are telling foundry that the code inside this function should fail

Next, we call the function `vm()`to change `msg.sender`

```javascript
vm.prank(address(1));
```

Here we expect the function call to set the owner to fail

```sh
Running 2 tests for test/Auth.t.sol:AuthTest
[PASS] testFailNotOwner() (gas: 10482)
Traces:
  [10482] AuthTest::testFailNotOwner()
    ├─ [0] VM::prank(0x0000000000000000000000000000000000000001)
    │   └─ ← ()
    ├─ [2487] Wallet::setOwner(0x0000000000000000000000000000000000000001)
    │   └─ ← "caller is not the owner"
    └─ ← "caller is not the owner"

[PASS] testSetOwner() (gas: 11615)
Traces:
  [11615] AuthTest::testSetOwner()
    ├─ [5454] Wallet::setOwner(0x0000000000000000000000000000000000000001)
    │   └─ ← ()
    ├─ [347] Wallet::owner() [staticcall]
    │   └─ ← 0x0000000000000000000000000000000000000001
    └─ ← ()

Test result: ok. 2 passed; 0 failed; finished in 848.41µs
```

What happens if we wanted to call a function multiple times using the same `msg.sender`?

We can do it as follow to set the owner multiple times:

```javascript
function testFailSetOwnerAgain() public {
    wallet.setOwner(address(1));

    vm.prank(address(1));
    wallet.setOwner(address(1));

    vm.prank(address(1));
    wallet.setOwner(address(1));

    vm.prank(address(1));
    wallet.setOwner(address(1));
}
```

But there is a shortcup to set `msg.sender` to `address(1)` for **multiple calls**

```javascript
function testFailSetOwnerAgain() public {
    wallet.setOwner(address(1));

    vm.startPrank(address(1));

    // msg.sender = address(1)

    wallet.setOwner(address(1));
    wallet.setOwner(address(1));
    wallet.setOwner(address(1));

    vm.stopPrank();

    // msg.sender = address(this)

    wallet.setOwner(address(1));
}
```

## Error

- `vm.expectRevert`
- `require` error message
- custom error
- label assertions

### Test for errors (2 ways)

To test for fail, we can do it like this:

```javascript
    function testFail() public {
        err.throwError();
    }
```

Or without prefixing with testFail by using `vm.expectRevert()`:

```javascript
    function testRevert() public {
        vm.expectRevert();
        err.throwError();
    }
```

### Test for the require error message

How do we test that the error that was thrown has the message "not authorized"?

We'll use `vm.expectRevert()` by passing in the string

```javascript
vm.expectRevert(bytes("not authorized"));
```

### Test for custom errors

Similar to testRequireMessage but this time we'll be passing in the custom error as input of `vm.expertRevert()`

```javascript
vm.expectRevert(Error.NotAuthorized.selector);
```

### Label assertions

If we try the following test, it will fail, but foundry doesn't give us lot informations about where the code failed

```javascript
function testErrorLabel() public {
        assertEq(uint256(1), uint256(1));
        assertEq(uint256(1), uint256(1));
        assertEq(uint256(1), uint256(1));
        assertEq(uint256(1), uint256(2));
        assertEq(uint256(1), uint256(1));
    }
```

We can label the assertions

```javascript
function testErrorLabel() public {
        assertEq(uint256(1), uint256(1), "test 1");
        assertEq(uint256(1), uint256(1), "test 2");
        assertEq(uint256(1), uint256(1), "test 3");
        assertEq(uint256(1), uint256(1), "test 4");
        assertEq(uint256(1), uint256(1), "test 5");
    }
```

And execute the test command with more details

```sh
forge test --match-path test/Error.t.sol -vvv
```

As we can see, we get more details about the fail

```sh
Logs:
  Error: test 4
  Error: a == b not satisfied [uint]
        Left: 1
       Right: 2
```

## Event

To test for the event is emitted or not, we are gonna be calling the function `vm.expectEmit()`

- Tell foundry wich data to check
- Emit the expected event
- Call the function that should emit the event
