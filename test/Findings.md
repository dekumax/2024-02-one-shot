#Critical: RapBattle::goOnStageOrBattle() allows the attacker to win a battle without owning the Rapper's NFT

#Github link:

#Finding
    ##Summary:
        The RapBattle::goOnStageOrBattle() doesnt check if the second user (calling the function) actually is the owner of the Rapper NFT passed in the function parameter, allowing the user to Rapper's NFT from other accounts

    ##Impact:
        The attacker can win all battles and collect cred tokens from opponents without having the Rapper's NFT and without risking their CRED tokens

    ##Tools:
        -Foundry

    ##Recommendations:
        -Verify if the tokenID passed in the RapBattle::goOnStageOrBattle() belongs to the user:
            ```
                } else {
                    // credToken.transferFrom(msg.sender, address(this), _credBet);  
                    + // Add a require statement that checks if the msg.sender is the owner of the _tokenId
                    _battle(_tokenId, _credBet); 
                }
            ```

#Low: Mint token in Streets::unstake() for each If statement wastes gas

#Github Link:

#Finding:
    ##Summary:
        In each If statement in Streets::unstake() every time a condition is met, it will make an external call, which will consume more gas rather than some all the amount to mint and at the end make only one external call to mint once

    ##Impact:
        Calling the ming() in every If statement, the amount of the gas required to run Streets::unstake() is: 54932
        Calling mint() only once, the amount of the gas required to run Streets::unstake() is: 46360

    ##Recommendations:
        - Create a variable that will store and increment the amount of tokens, in each If statement, and at the end, make a single external call to mint the amount

        '''
            uint256 amountToMint = 0;
            // Apply changes based on the days staked
            if (daysStaked >= 1) {
                stakedRapperStats.weakKnees = false;
                amountToMint +=1;
                // credContract.mint(msg.sender, 1);
            }
            if (daysStaked >= 2) {
                stakedRapperStats.heavyArms = false;
                amountToMint +=1;
                // credContract.mint(msg.sender, 1);
            }
            if (daysStaked >= 3) {
                stakedRapperStats.spaghettiSweater = false;
                amountToMint +=1;
                // credContract.mint(msg.sender, 1);
            }
            if (daysStaked >= 4) {
                stakedRapperStats.calmAndReady = true;
                amountToMint +=1;
                // credContract.mint(msg.sender, 1);
            }

            // Only call the update function if the token was staked for at least one day
            if (daysStaked >= 1) {
                credContract.mint( msg.sender, amountToMint);
                oneShotContract.updateRapperStats(
                    tokenId,
                    stakedRapperStats.weakKnees,
                    stakedRapperStats.heavyArms,
                    stakedRapperStats.spaghettiSweater,
                    stakedRapperStats.calmAndReady,
                    stakedRapperStats.battlesWon
                );
            }
        '''