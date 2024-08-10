pragma solidity ^0.8.0;
 
import "./node_modules/@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import "./node_modules/@pythnetwork/pyth-sdk-solidity/PythStructs.sol";
 
contract PythPrice {
  IPyth pyth;
 
  /**
   * @param pythContract The address of the Pyth contract
   */
  constructor(address pythContract) {
    pyth = IPyth(pythContract);
  }
 
  /**
     * This method is an example of how to interact with the Pyth contract.
     * Fetch the priceUpdate from Hermes and pass it to the Pyth contract to update the prices.
     * Add the priceUpdate argument to any method on your contract that needs to read the Pyth price.
     * See https://docs.pyth.network/price-feeds/fetch-price-updates for more information on how to fetch the priceUpdate.
 
     * @param priceUpdate The encoded data to update the contract with the latest price
     */
  function exampleMethod(bytes[] calldata priceUpdate) public payable {
    uint fee = pyth.getUpdateFee(priceUpdate);
    pyth.updatePriceFeeds{ value: fee }(priceUpdate);
    bytes32 priceFeedId = 0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace; 
    PythStructs.Price memory price = pyth.getPrice(priceFeedId);
  }
}
 