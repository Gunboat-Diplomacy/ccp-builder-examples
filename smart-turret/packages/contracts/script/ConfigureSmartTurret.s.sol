// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";

import { Utils } from "../src/systems/Utils.sol";
import { Utils as SmartTurretUtils } from "@eveworld/world/src/modules/smart-turret/Utils.sol";
import { SmartTurretLib } from "@eveworld/world/src/modules/smart-turret/SmartTurretLib.sol";
import { FRONTIER_WORLD_DEPLOYMENT_NAMESPACE } from "@eveworld/common-constants/src/constants.sol";

contract ConfigureSmartTurret is Script {
  using SmartTurretUtils for bytes14;
  using SmartTurretLib for SmartTurretLib.World;

  SmartTurretLib.World smartTurret;

  function runCore(address worldAddress, uint256[] memory smartTurretIds) internal {
    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 playerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(playerPrivateKey);

    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);

    smartTurret = SmartTurretLib.World({
      iface: world,
      namespace: FRONTIER_WORLD_DEPLOYMENT_NAMESPACE
    });

    ResourceId systemId = Utils.smartTurretSystemId();


    for (uint256 i = 0; i < smartTurretIds.length; i++) {
      uint256 smartTurretId = smartTurretIds[i];
      // This function can only be called by the owner of the smart turret
      smartTurret.configureSmartTurret(smartTurretId, systemId);
    }

    vm.stopBroadcast();
  }

  function runCQX(address worldAddress) external {
    uint256[] memory smartTurretIds = new uint256[](3);
    // scetrov's turrets
    smartTurretIds[0] = 90751117774793868817432120689828306901801996660537889025505233990272746082187; // Left "So Much For Subtlety"
    smartTurretIds[1] = 11704671005735439463950973941874644084868982216748564838713575829882117304344; // Middle "Smart Turret Diplomat"
    smartTurretIds[2] = 49240198130190626126447286418625368499371258892696229807313310414687671817084; // Right "Flexible Demeanour"

    runCore(worldAddress, smartTurretIds);
  }
}
