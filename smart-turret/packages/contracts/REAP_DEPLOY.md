> [!IMPORTANT]
> This document assumes you have node and pnpm setup already

Make sure you are in the `smart-turret/packages/contracts` folder, i.e. if you are in the root of the repository:

```sh
cd smart-turret/packages/contracts
```

Make sure packages are installed with, you can skip this if you have done it recently:

```sh
pnpm install
```

## Deploy the Smart Contract

> [!NOTE]
> These instructions are broadly based on CCP's [Deploy Smart Turret Contracts](https://docs.evefrontier.com/SmartTurret/deploy-smart-turret-contracts) documentation.

Open `mud.config.ts` and ensure that the namspace is set to a unique name (lower case and `_` only)

```json
  namespace: "scetrov_cqx",
```

Make sure the same namespace is set in `src/systems/constants.sol`:

```solidity
bytes14 constant SMART_TURRET_DEPLOYMENT_NAMESPACE = "scetrov_cqx";
```

> [!IMPORANT]
> if the namespace doesn't match or you use someone elses namspace, then the deploy will fail.

Switch to Stillness

```sh
pnpm env-stillness
```

Update the `.env` to set the `PRIVATE_KEY` to the private key from the Frontier client:

![EVE Vault: View Private Key](https://docs.evefrontier.com/_next/static/media/private-key.f4b85978.png)

```ini
PRIVATE_KEY=[YOUR PRIVATE KEY]
```

> [!WARNING]
> If you have never deployed before, you will likely not have enough hETH, get some for free from the [Garnet Faucet](https://garnetchain.com/faucet).

Then deploy to garnet:

```sh
pnpm deploy:garnet
```

If the result is anything other than this, your deployment didn't work correctly and you will need to diagnose the error, reach out in Reapers `#dev-chat` or EVE Frontier `#builder-chat` if you are stuck:

```json
{
  worldAddress: '0x7fe660995b0c59b6975d5d59973e2668af6bb9c5',
  blockNumber: 10572312
}
```

## Configure Smart Turrets

> [!NOTE]
> Instructions are broadly based on CCP's [Configure Smart Turret](https://docs.evefrontier.com/SmartTurret/configure-smart-turret) instructions.

All of our configuration is now in the `configure-smart-turrets` script, so if you have never configured your smart turrets before you will need to add the folloing:

### A new task `package.json`:

```sh
"configure-smart-turret:cqx": ". ./.env && pnpm forge script ./script/ConfigureSmartTurret.s.sol:ConfigureSmartTurret --broadcast --rpc-url $RPC_URL --chain-id $CHAIN_ID --sig \"runCQX(address)\" $WORLD_ADDRESS -vvv",
```

Change `cqx` at the beginning to an identifier that isn't currently in use, change `runCQX` at the end to something similar. I'm using the last three digits of the solar system.

### A new function in `script/ConfigureSmartTurret.s.sol`

Update the following in the file:

- change `runCQX` to the same identifier you used earlier,
- update the Smart Turret IDs (you can get these from the game, or the API),
- update the comments so you know what these are.

```solidity
function runCQX(address worldAddress) external {
    uint256[] memory smartTurretIds;
    // scetrov's turrets
    smartTurretIds[0] = 90751117774793868817432120689828306901801996660537889025505233990272746082187; // Left "So Much For Subtlety"
    smartTurretIds[1] = 11704671005735439463950973941874644084868982216748564838713575829882117304344; // Middle "Smart Turret Diplomat"
    smartTurretIds[2] = 49240198130190626126447286418625368499371258892696229807313310414687671817084; // Right "Flexible Demeanour"

    runCore(worldAddress, smartTurretIds);
}
```

## Deploy

Run the deployment:

```sh
pnpm configure-smart-turrets:cqx
```

The following should now be printed to the console:

```
##### 17069
✅  [Success] Hash: 0x3ffbb8bb8936c9cbb1e71dbeefb76cb3ef28944a1cc86edaed030ee76bcfb9a6
Block: 11101787
Paid: 0.000000000008780823 ETH (172173 gas * 0.000000051 gwei)


##### 17069
✅  [Success] Hash: 0xaadcb7d4bedc5e732db46a8c64ce20950e106f36e14486eae178895c04a3f683
Block: 11101787
Paid: 0.000000000008780823 ETH (172173 gas * 0.000000051 gwei)


##### 17069
✅  [Success] Hash: 0x2cc8fa2d9db63c229689d97f443957875ea7dc91b1f08e63e6319c215aade7b2
Block: 11101787
Paid: 0.000000000008780823 ETH (172173 gas * 0.000000051 gwei)

✅ Sequence #1 on 17069 | Total Paid: 0.000000000026342469 ETH (516519 gas * avg 0.000000051 gwei)
```

## Check in the changes

Please make sure that you checkin your changes:

```sh
git add .
git commit # you will be prompted for a message
git push origin HEAD
```

At this point you can now go make yourself a nice cup of Tea! 