#Critical RapBattle::goOnStageOrBattle() allows the attacker to win a battle without owning the Rapper's NFT

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
                    + require(oneShotNft.)
                    _battle(_tokenId, _credBet); 
                }
            ```