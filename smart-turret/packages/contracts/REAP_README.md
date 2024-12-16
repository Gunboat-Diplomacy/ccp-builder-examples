## Prerequisites

### `pnpm` 8 or 9

```sh
 $ pnpm --version
    9.15.0
```

If you don't have this you can install it with:

```sh
 $ npm install -g pnpm@latest
```

### Node 18

```sh
 $ node --version
    v18.20.5
```

### Local World Deployed

You will need to have the world deployed [Setting up the World](https://docs.evefrontier.com/QuickstartGuide) as per CCPs documentation.

If you don't have this you can switch to it with `nvm`:

```sh
 $ nvm use 18
```

## Development and Testing

You will need to `cd` in this directory:

```sh
cd smart-turret/packages/contracts
```

Then run:

```sh
pnpm install
```

> [!TIP]
> If it all goes wrong, you can run `git clean -dfx` to remove any extra files, you will then need to re-run `pnpm install` to re-install the project. If you've made edits to files you can revert them all with `git reset --hard HEAD`, you will however lose all of your changes.

Copy the `.env` from the sample:

```sh
cp .env.sample .env
```

Run the tests with:

```sh
pnpm test
```

You should get four passing tests:

```
Ran 4 tests for test/SmartTurretTest.t.sol:SmartTurretTest
[PASS] testAggression() (gas: 63954)
[PASS] testAggressionFromCorp() (gas: 56495)
[PASS] testInProximity() (gas: 59989)
[PASS] testWorldExists() (gas: 4949)
Suite result: ok. 4 passed; 0 failed; 0 skipped; finished in 192.78ms (11.28ms CPU time)
```

Move on to [Deploying](./REAP_DEPLOY.md) next.