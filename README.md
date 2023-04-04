Intro to Foundry

```
source /Users/aboutika/.bashrc
forge init
```

To compile:

```
forge build
```

To test:

```
forge test
forge test -vvv
forge test --help
```

To test only one file:

```
forge test --match-path test/HelloWorld.t.sol
forge test --match-path test/HelloWorld.t.sol -vvv
```
