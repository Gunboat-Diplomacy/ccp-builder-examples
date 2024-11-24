// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IBaseWorld } from "@eveworld/world/src/codegen/world/IWorld.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
import { ERC20_REGISTRY_TABLE_ID } from "@latticexyz/world-modules/src/modules/erc20-puppet/constants.sol";
import { WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { ERC20Registry } from "@latticexyz/world-modules/src/modules/erc20-puppet/tables/ERC20Registry.sol";
import { registerERC20 } from "@latticexyz/world-modules/src/modules/erc20-puppet/registerERC20.sol";
import { ERC20MetadataData } from "@latticexyz/world-modules/src/modules/erc20-puppet/tables/ERC20Metadata.sol";
import { IWorld } from "../src/codegen/world/IWorld.sol";

library TokenUtils {
  function stringToBytes14(string memory str) public pure returns (bytes14) {
    bytes memory tempBytes = bytes(str);

    // Ensure the bytes array is not longer than 14 bytes.
    // If it is, this will truncate the array to the first 14 bytes.
    // If it's shorter, it will be padded with zeros.
    require(tempBytes.length <= 14, "String too long");

    bytes14 converted;
    for (uint i = 0; i < tempBytes.length; i++) {
      converted |= bytes14(tempBytes[i] & 0xFF) >> (i * 8);
    }

    return converted;
  }
}

contract RegisterToken is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);
    console.log("World Address:", worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    string memory tokenNamespace = vm.envString("TOKEN_NAMESPACE");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    console.log("Registering ERC20 Token");
    IERC20Mintable erc20TokenAddress = registerERC20(
      world,
      TokenUtils.stringToBytes14(tokenNamespace),
      ERC20MetadataData({ decimals: 18, name: "Scetrov 3", symbol: "SCE3" })
    );
    console.log("Registration Complete! Token Address: ", address(erc20TokenAddress));

    vm.stopBroadcast();
  }
}

contract MintTokens is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);
    console.log("World Address:", worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    address treasuryAddress = vm.envAddress("TREASURY_ADDRESS");
    string memory tokenNamespace = vm.envString("TOKEN_NAMESPACE");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    address erc20TokenAddress = ERC20Registry.getTokenAddress(
      ERC20_REGISTRY_TABLE_ID,
      WorldResourceIdLib.encodeNamespace(TokenUtils.stringToBytes14(tokenNamespace))
    );
    console.log("Found Token, Token Address: ", address(erc20TokenAddress));

    IERC20Mintable erc20 = IERC20Mintable(erc20TokenAddress);

    erc20.mint(treasuryAddress, 1337 * 1e18);

    vm.stopBroadcast();
  }
}
