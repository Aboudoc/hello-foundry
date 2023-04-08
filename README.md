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

### Format code

```
forge frmt
```
