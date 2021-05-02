import {ASSET_NUMBERS, OPTION_TYPE_NUMBERS, PROTOCOL_NUMBERS} from "../constants/constants";

export function convertOptionList(optionList) {
  let options = [];
  for (let i = 0; i < optionList.length; i++) {
    options.push({
      protocol: PROTOCOL_NUMBERS[optionList[i][0]],
      underlyingAsset: ASSET_NUMBERS[optionList[i][1]],
      paymentAsset: ASSET_NUMBERS[optionList[i][2]],
      optionType: OPTION_TYPE_NUMBERS[optionList[i][3]],
      expiryTimestamp: optionList[i][4].toString(),
      strikeUSD: optionList[i][5].toString(),
      size: optionList[i][6].toString(),
      premium: optionList[i][7].toString()
    });
  }
  return options;
}
//convert timestamp to readable date
