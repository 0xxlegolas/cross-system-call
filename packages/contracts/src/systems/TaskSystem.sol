// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { FunctionSelectors } from "@latticexyz/world/src/codegen/tables/FunctionSelectors.sol";

import { System } from "@latticexyz/world/src/System.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { Tasks, TasksData } from "../codegen/index.sol";
import { IncrementSystem } from "./IncrementSystem.sol";
import { IIncrementSystem } from "../codegen/world/IIncrementSystem.sol";
import { Utils } from "./Utils.sol";

contract TaskSystem is System {
  function addTask(string memory description) public returns (bytes32 id) {
    id = keccak256(abi.encode(block.prevrandao, _msgSender(), description));
    Tasks.set(id, TasksData({ description: description, createdAt: block.timestamp, completedAt: 0 }));
    IBaseWorld world = IBaseWorld(_world());

    bytes4 functionSelector = IIncrementSystem.app__increment.selector;


    ResourceId systemId = FunctionSelectors.getSystemId(functionSelector);
    world.call(systemId, abi.encodeCall(IncrementSystem.increment, ()));
  }
}
