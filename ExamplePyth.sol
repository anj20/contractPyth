pragma solidity ^0.8.13;
 
import "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
 
contract ExamplePythContract {
  IPyth pyth;
  bytes32 ethUsdPriceId;
 
  constructor(address _pyth, bytes32 _ethUsdPriceId) {
    pyth = IPyth(_pyth);
    ethUsdPriceId = _ethUsdPriceId;
  }
 
  function mint() public payable {
    PythStructs.Price memory price = pyth.getPrice(ethUsdPriceId);
 
    uint ethPrice18Decimals = (uint(uint64(price.price)) * (10 ** 18)) /
      (10 ** uint8(uint32(-1 * price.expo)));
    uint oneDollarInWei = ((10 ** 18) * (10 ** 18)) / ethPrice18Decimals;
 
    if (msg.value >= oneDollarInWei) {
      // User paid enough money.
      // TODO: mint the NFT here
    } else {
      revert InsufficientFee();
    }
  }
 
  function updateAndMint(bytes[] calldata pythPriceUpdate) external payable {
    uint updateFee = pyth.getUpdateFee(pythPriceUpdate);
    pyth.updatePriceFeeds{ value: updateFee }(pythPriceUpdate);
 
    mint();
  }
 
  // Error raised if the payment is not sufficient
  error InsufficientFee();
}
 